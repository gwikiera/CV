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

class ViewModelClientTests: XCTestCase {
    let baseURL: URL = .stub
    
    func testViewModelPublisher_AskForDataForURL() {
        // Given
        var expectedUrl: URL?
        let sut = ViewModelClient.client(
            baseURL: baseURL,
            dataTaskPublisher: { url -> Fail<Data, Error> in
                expectedUrl = url
                return Fail<Data, Error>(error: ErrorStub())
            }
        )

        // When
        _ = sut.viewModelPublisher().sink(receiveCompletion: noop(), receiveValue: noop())

        // Then
        expect(expectedUrl) == baseURL.appendingPathComponent("CV.json")
    }

    func testViewModelPublisher_WhenDataTaskPublisherFails() async {
        // Given
        let sut = ViewModelClient.client(
            baseURL: baseURL,
            dataTaskPublisher: stubReturn(with: AnyPublisher<Data, Error>.stubFailure(ErrorStub()))
        )

        // When
        let firstResult = await sut.viewModelPublisher().firstResult()

        // Then
        expect(try firstResult.get()).to(throwError())
    }

    func testViewModelPublisher_WhenDataTaskPublisherReturnsInvalidData() async {
        // Given
        let sut = ViewModelClient.client(
            baseURL: baseURL,
            dataTaskPublisher: stubReturn(with: AnyPublisher<Data, Error>.stubOutput(Data()))
        )

        // When
        let firstResult = await sut.viewModelPublisher().firstResult()

        // Then
        expect(try firstResult.get()).to(throwError())
    }

    func testViewModelPublisher_WhenDataTaskPublisherReturnsValidData() async throws {
        // Given
        let data = try JSONEncoder().encode(ViewModel.stub())
        let sut = ViewModelClient.client(baseURL: "baseURL", dataTaskPublisher: { _ in
            AnyPublisher<Data, Error>.stubOutput(data)
        })

        // When
        let firstResult = await sut.viewModelPublisher().firstResult()

        // Then
        expect(try firstResult.get()) == .stub()
    }
}
