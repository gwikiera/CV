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
    
import UIKit
import Logger
import Combine

public typealias ImagePath = String

public struct ImageProvider {
    var imagePathPublisher: (URL) -> AnyPublisher<ImagePath, Error>

    public init(imagePathPublisher: @escaping (URL) -> AnyPublisher<ImagePath, Error>) {
        self.imagePathPublisher = imagePathPublisher
    }

    public func imagePathPublisher(for url: URL) -> AnyPublisher<ImagePath, Error> {
        imagePathPublisher(url)
    }

    public func imagePublisher(for url: URL) -> AnyPublisher<UIImage?, Error> {
        imagePathPublisher(for: url)
            .map(UIImage.init(contentsOfFile:))
            .eraseToAnyPublisher()
    }
}

public extension ImageProvider {
    static let noop = Self(imagePathPublisher: { _ in .noop })
}

public extension ImageProvider {
    init(
        apiClient: APIClient,
        fileStorage: FileStorage
    ) {
        self.imagePathPublisher = { url in
            let fileName = !url.lastPathComponent.isEmpty ? url.lastPathComponent : String(url.hashValue)

            return fileStorage.getStoredFilePath(fileName)
                .catch { error -> AnyPublisher<ImagePath, Error> in
                    logger.debug("No stored image found, starting downloading image from url \(url).")
                    return apiClient.downloadTaskPublisher(url)
                        .handleEvents(receiveOutput: { url in
                            logger.debug("Image downloaded at path: \(url.absoluteString).")
                        }, receiveCompletion: { completion in
                            guard case let .failure(error) = completion else { return }
                            logger.debug("Image downloading failed, error: \(error).")
                        })
                        .flatMap { tempURL in
                            fileStorage.storeFile(fileName, tempURL)
                        }
                        .eraseToAnyPublisher()
                }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
}
