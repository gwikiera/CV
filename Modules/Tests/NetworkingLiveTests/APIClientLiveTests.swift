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
import TestHelpers
@testable import Networking
@testable import NetworkingLive

class APIClientLiveTests: XCTestCase {
    func testDataEndpoint() {
        // Given
        let sut = APIClient.live

        // When
        let url = sut.url(for: .data)

        // Then
        expect(url) == "https://raw.githubusercontent.com/gwikiera/CV/develop/Resources/CV.json"
    }

    func testImageEndpoint() {
        // Given
        let sut = APIClient.live

        // When
        let url = sut.url(for: .image)

        // Then
        expect(url) == "https://raw.githubusercontent.com/gwikiera/CV/develop/Resources/Profile.jpeg"
    }

#if DEBUG
    func testDataTaskPublisher() {
        // Given
        let sut = APIClient.mock

        // When
        let observer = sut.dataTaskPublisher(.data).testObserver()

        // Then
        observer.assertError(FileManager.FileManagerError.fileNotFound)
    }

    func testDownloadTaskPublisher() {
        // Given
        let sut = APIClient.mock

        // When
        let observer = sut.downloadTaskPublisher(.data).testObserver()

        // Then
        observer.assertError(FileManager.FileManagerError.fileNotFound)
    }
#endif
}
