//
//  CV
//
//  Copyright 2020 - Grzegorz Wikiera - https://github.com/gwikiera
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

import Foundation
import Combine

public typealias FilePath = String

public struct FileStorage {
    var getStoredFilePath: (String) -> AnyPublisher<FilePath, Error>
    var storeFile: (String, URL) -> AnyPublisher<FilePath, Error>

    public init(getStoredFilePath: @escaping (String) -> AnyPublisher<FilePath, Error>, storeFile: @escaping (String, URL) -> AnyPublisher<FilePath, Error>) {
        self.getStoredFilePath = getStoredFilePath
        self.storeFile = storeFile
    }
}

public extension FileStorage {
    static let noop = Self(
        getStoredFilePath: { _ in .noop },
        storeFile: { _, _ in .noop }
    )

    static let failing = Self(
        getStoredFilePath: { _ in fatalError() },
        storeFile: { _, _ in fatalError() }
    )
}
