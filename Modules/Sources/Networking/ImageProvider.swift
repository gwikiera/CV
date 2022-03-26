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

public protocol ImageProviding {
    func imagePath(for url: URL) -> AnyPublisher<ImagePath, Error>
}

public final class ImageProvider: ImageProviding {
    public enum ImageProviderError: Error {
        case downloadingError(Error)
        case imageStoringError(Error)
    }

    let fileManager: FileManager
    let storagePath: String
    let apiClient: APIClient

    init(fileManager: FileManager = .default,
         storagePath: String,
         apiClient: APIClient) {
        self.fileManager = fileManager
        self.storagePath = storagePath
        self.apiClient = apiClient
    }
    
    convenience init(fileManager: FileManager = .default,
                     apiClient: APIClient) {
        guard let storagePath = fileManager.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            fatalError("Cannot find caches directory.")
        }
        self.init(fileManager: fileManager, storagePath: storagePath.path, apiClient: apiClient)
    }
    
    public func imagePath(for url: URL) -> AnyPublisher<ImagePath, Error> {
        let fileName = !url.lastPathComponent.isEmpty ? url.lastPathComponent : String(url.hashValue)

        return storedImagePathForImage(named: fileName)
            .catch { error -> AnyPublisher<ImagePath, ImageProviderError> in
                guard (error as? CacheError) == .cachedFileNotFound else {
                    return Fail(error: .imageStoringError(error)).eraseToAnyPublisher()
                }
                logger.debug("No stored image found, starting downloading image from url \(url).")
                return self.apiClient.downloadTaskPublisher(url)
                    .handleEvents(receiveOutput: { url in
                        logger.debug("Image downloaded at path: \(url.absoluteString).")
                    }, receiveCompletion: { completion in
                        guard case let .failure(error) = completion else { return }
                        logger.debug("Image downloading failed, error: \(error).")
                    })
                    .mapError(ImageProviderError.downloadingError)
                    .flatMap { [self] tempURL in
                        self.storeImage(named: fileName, sourceUrl: tempURL)
                    }
                    .eraseToAnyPublisher()
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

private extension ImageProvider {
    enum CacheError: Swift.Error, Equatable {
        case cachedFileNotFound
    }

    func storedImagePathForImage(named imageName: String) -> AnyPublisher<ImagePath, Swift.Error> {
        return Future { [weak self, fileManager] promise in
            guard let imagePath = self?.pathForImage(named: imageName),
                fileManager.isReadableFile(atPath: imagePath) else {
                promise(.failure(CacheError.cachedFileNotFound))
                return
            }

            logger.debug("Providing stored path: '\(imagePath) for image named: \(imageName).")
            promise(.success(imageName))
        }
        .eraseToAnyPublisher()
    }

    func storeImage(named imageName: String, sourceUrl: URL) -> AnyPublisher<ImagePath, ImageProviderError> {
        let imagePath = pathForImage(named: imageName)
        return Future { [fileManager] promise in
            if fileManager.fileExists(atPath: imagePath) {
                do {
                    try fileManager.removeItem(atPath: imagePath)
                } catch {
                    logger.error("Cannot delete file at path:\(imagePath).\nError: \(error).")
                    promise(.failure(.imageStoringError(error)))
                    return
                }
            }

            let destinationUrl = URL(fileURLWithPath: imagePath)

            do {
                try fileManager.moveItem(at: sourceUrl, to: destinationUrl)
            } catch {
                logger.error("Cannot copy file from path:\(sourceUrl) to path: \(destinationUrl).\nError: \(error).")
                promise(.failure(.imageStoringError(error)))
                return
            }

            return promise(.success(imagePath))
        }
        .eraseToAnyPublisher()
    }
    
    func pathForImage(named imageName: String) -> ImagePath {
        return storagePath + imageName
    }
}
