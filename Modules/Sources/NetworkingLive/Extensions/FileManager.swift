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

import Foundation
import Combine
import Logger

extension FileManager {
    enum FileManagerError: Swift.Error, Equatable {
        case fileNotFound
    }

    var cacheDirectory: URL {
        guard let cacheDirectory = urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            let message = "Cannot find caches directory."
            logger.critical(message)
            fatalError(message)
        }

        return cacheDirectory
    }

    func getStoredFilePath(for fileName: String, storagePath: String) -> AnyPublisher<String, Error> {
        let filePath = self.pathForFile(named: fileName, storagePath: storagePath)
        return Deferred {
            return Future { promise in
                guard self.isReadableFile(atPath: filePath) else {
                    promise(.failure(FileManagerError.fileNotFound))
                    return
                }

                logger.debug("Providing stored path: '\(filePath) for file named: \(fileName).")
                promise(.success(filePath))
            }
        }
        .eraseToAnyPublisher()
    }

    func storeFile(named fileName: String, storagePath: String, sourceUrl: URL) -> AnyPublisher<String, Error> {
        let filePath = self.pathForFile(named: fileName, storagePath: storagePath)
        return Deferred {
            Future { promise in
                if self.fileExists(atPath: filePath) {
                    do {
                        try self.removeItem(atPath: filePath)
                    } catch {
                        logger.error("Cannot delete file at path:\(filePath).\nError: \(error).")
                        promise(.failure(error))
                        return
                    }
                }

                let destinationUrl = URL(fileURLWithPath: filePath)

                do {
                    try self.moveItem(at: sourceUrl, to: destinationUrl)
                } catch {
                    logger.error("Cannot copy file from path:\(sourceUrl) to path: \(destinationUrl).\nError: \(error).")
                    promise(.failure(error))
                    return
                }

                return promise(.success(filePath))
            }
        }
        .eraseToAnyPublisher()
    }

    private func pathForFile(named fileName: String, storagePath: String) -> String {
        return "\(storagePath)/\(fileName)"
    }
}
