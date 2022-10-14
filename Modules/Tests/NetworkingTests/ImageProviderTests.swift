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
import TestHelpers
@testable import Networking

class ImageProviderTests: XCTestCase {
    let filePath = "/foo/bar"
    let fileURL: URL = "www.example.com/image.png"

    // MARK: - imagePathPublisher
    func testImagePathPublisher_WhenFileCached() {
        // Given
        let apiClient = APIClient.failing
        var fileStorage = FileStorage.failing
        fileStorage.getStoredFilePath = stubReturn(with: .stubOutput(filePath))
        let sut = ImageProvider(
            apiClient: apiClient,
            fileStorage: fileStorage
        )

        // When
        let observer = sut.imagePathPublisher(for: fileURL).testObserver()

        // Then
        observer.assertValues([filePath])
        observer.assertComplete()
    }

    func testImagePathPublisher_WhenFileNotCashed_DownloadingFails() {
        // Given
        var apiClient = APIClient.failing
        apiClient.downloadTask = { url in
            expect(url) == self.fileURL
            return .stubFailure(errorStub)
        }
        var fileStorage = FileStorage.failing
        fileStorage.getStoredFilePath = stubReturn(with: .stubFailure(errorStub))
        let sut = ImageProvider(
            apiClient: apiClient,
            fileStorage: fileStorage
        )

        // When
        let observer = sut.imagePathPublisher(for: fileURL).testObserver()

        // Then
        observer.assertError(errorStub)
    }

    func testImagePathPublisher_WhenFileNotCashed_StoringFails() {
        // Given
        var apiClient = APIClient.failing
        apiClient.downloadTask = stubReturn(with: .stubOutput(.stub))
        var fileStorage = FileStorage.failing
        fileStorage.getStoredFilePath = stubReturn(with: .stubFailure(errorStub))
        fileStorage.storeFile = { fileName, url in
            expect(fileName) == "image.png"
            expect(url) == .stub
            return .stubFailure(errorStub)
        }

        let sut = ImageProvider(
            apiClient: apiClient,
            fileStorage: fileStorage
        )

        // When
        let observer = sut.imagePathPublisher(for: fileURL).testObserver()

        // Then
        observer.assertError(errorStub)
    }

    func testImagePathPublisher_NewFile() {
        // Given
        var apiClient = APIClient.failing
        apiClient.downloadTask = stubReturn(with: .stubOutput(.stub))
        var fileStorage = FileStorage.failing
        fileStorage.getStoredFilePath = stubReturn(with: .stubFailure(errorStub))
        fileStorage.storeFile = { _, _ in .stubOutput(self.filePath) }
        let sut = ImageProvider(
            apiClient: apiClient,
            fileStorage: fileStorage
        )

        // When
        let observer = sut.imagePathPublisher(for: fileURL).testObserver()

        // Then
        observer.assertValues([filePath])
        observer.assertComplete()
    }
}
