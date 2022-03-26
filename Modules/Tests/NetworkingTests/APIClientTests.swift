//
//  CV
//
//  Copyright 2022 - Grzegorz Wikiera - https://github.com/gwikiera
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
import Nimble
import Combine
import Data
import TestHelpers
@testable import Networking

class APIClientTests: XCTestCase {
    // MARK: - dataTaskPublisher
    func testDataTaskPublisher() async throws {
        // Given
        let expectedUrl: URL = "/"
        let endpoint = Endpoint(urlBuilder: stubReturn(with: expectedUrl))

        let sut = APIClient.client(
            dataTask: { url in
                expect(url) == expectedUrl
                return .stubOutput(.stub)
            }
        )

        // When
        let firstResult = await sut.dataTaskPublisher(endpoint).firstResult()

        // Then
        expect(try firstResult.get()) == .stub
    }

    func testDataTaskPublisher_Failing() async throws {
        // Given
        let sut = APIClient.client(
            dataTask: stubReturn(with: .stubFailure(ErrorStub()))
        )

        // When
        let firstResult = await sut.dataTaskPublisher(Endpoint.stub).firstResult()

        // Then
        expect(try firstResult.get()).to(throwError(ErrorStub()))
    }

    // MARK: - downloadTaskPublisher
    func testDownloadTaskPublisher() async throws {
        // Given
        let expectedUrl: URL = "/"
        let endpoint = Endpoint(urlBuilder: stubReturn(with: expectedUrl))

        let sut = APIClient.client(
            downloadTask: { url in
                expect(url) == expectedUrl
                return .stubOutput(.stub)
            }
        )

        // When
        let firstResult = await sut.downloadTaskPublisher(endpoint).firstResult()

        // Then
        expect(try firstResult.get()) == .stub
    }

    func testDownloadTaskPublisher_Failing() async throws {
        // Given
        let sut = APIClient.client(
            downloadTask: stubReturn(with: .stubFailure(ErrorStub()))
        )

        // When
        let firstResult = await sut.downloadTaskPublisher(Endpoint.stub).firstResult()

        // Then
        expect(try firstResult.get()).to(throwError(ErrorStub()))
    }

    // MARK: - request
    func testRequestPublisher() async throws {
        // Given
        let data = try XCTUnwrap("1".data(using: .utf8))
        let sut = APIClient.client(
            dataTask: stubReturn(with: .stubOutput(data))
        )

        // When
        let firstResult = await sut.request(endpoint: .stub, as: Int.self).firstResult()

        // Then
        expect(try firstResult.get()) == 1
    }

    func testRequestPublisher_Failing() async throws {
        // Given
        let sut = APIClient.client(
            dataTask: stubReturn(with: .stubOutput(Data()))
        )

        // When
        let firstResult = await sut.request(endpoint: .stub, as: Int.self).firstResult()

        // Then
        expect(try firstResult.get()).to(throwError())
    }
}
