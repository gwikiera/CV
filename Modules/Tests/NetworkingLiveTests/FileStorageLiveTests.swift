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

class FileStorageLiveTests: XCTestCase {
    let fileManager = FileManager.default
    let fileName = UUID().uuidString + ".txt"
    lazy var tempFileURL = fileManager.temporaryDirectory.appendingPathComponent(fileName)
    lazy var destinationPath = fileManager.cacheDirectory.appendingPathComponent(fileName).path

    override func setUp() async throws {
        try await super.setUp()

        try fileName.data(using: .utf8)?.write(to: tempFileURL)
    }

    override func tearDown() async throws {
        try? fileManager.removeItem(at: tempFileURL)
        try? fileManager.removeItem(atPath: destinationPath)

        try await super.tearDown()
    }

    func testLive() throws {
        // Given
        let sut = FileStorage(fileManager: fileManager)

        // When
        sut.getStoredFilePath(fileName).testObserver().assertError(FileManager.FileManagerError.fileNotFound)
        sut.storeFile(fileName, tempFileURL).expectComplete()

        // Then
        sut.getStoredFilePath(fileName).testObserver().assertValues([destinationPath])
    }

#if DEBUG
    func testMock() {
        let sut = FileStorage.mock

        sut.getStoredFilePath(fileName).testObserver().assertError(FileManager.FileManagerError.fileNotFound)
        sut.storeFile(fileName, tempFileURL).expectComplete()
    }
#endif
}
