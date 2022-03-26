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

import Networking
import Foundation
import Combine
import Logger

extension FileStorage {
    static let live = Self(fileManager: .default)
}

public extension FileStorage {
    init(fileManager: FileManager) {
        let storagePath = fileManager.cacheDirectory.path
        self.init(
            getStoredFilePath: { fileName in
                fileManager.getStoredFilePath(for: fileName, storagePath: storagePath)
            },
            storeFile: { fileName, sourceUrl in
                fileManager.storeFile(named: fileName, storagePath: storagePath, sourceUrl: sourceUrl)
            }
        )
    }
}
