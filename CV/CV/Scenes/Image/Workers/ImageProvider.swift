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
import Files

protocol ImageProviding {    
    func imagePath(for url: URL, completion: @escaping (Result<ImagePath, Error>) -> Void)
}

final class ImageProvider: ImageProviding {
    enum Error: Swift.Error {
        case downloadingError(Swift.Error?)
        case imageStoringError(Swift.Error?)
    }
    
    let fileManager: FileManager
    let storagePath: String
    let urlSession: URLSession

    init(fileManager: FileManager = .default,
         storagePath: String,
         urlSession: URLSession = .shared) {
        self.fileManager = fileManager
        self.storagePath = storagePath
        self.urlSession = urlSession
    }
    
    convenience init(fileManager: FileManager = .default,
                     urlSession: URLSession = .shared) {
        guard let storagePath = fileManager.urls(for: .cachesDirectory, in: .allDomainsMask).first else {
            fatalError("Cannot find caches directory.")
        }
        self.init(fileManager: fileManager, storagePath: storagePath.path, urlSession: urlSession)
    }
    
    func imagePath(for url: URL, completion: @escaping (Result<ImagePath, Swift.Error>) -> Void) {
        let fileName = !url.lastPathComponent.isEmpty ? url.lastPathComponent : String(url.hashValue)
        
        if let imagePath = storedImagePathForImage(named: fileName) {
            logger.debug("Providing stored path: '\(imagePath) for image named: \(fileName).")
            completion(.success(imagePath))
            return
        }
        
        logger.debug("No stored image found, starting downloading image from url \(url).")

        downloadImage(for: url, imageName: fileName) { result in
            switch result {
            case .success(let imagePath):
                logger.debug("Image downloaded at path: \(imagePath).")
                completion(.success(imagePath))
                break
            case .failure(let error):
                logger.debug("Image downloading failed, error: \(error).")
                completion(.failure(error))
                return
            }
        }
    }
}

private extension ImageProvider {
    func storedImagePathForImage(named imageName: String) -> ImagePath? {
        let imagePath = pathForImage(named: imageName)
        guard fileManager.isReadableFile(atPath: imagePath) else { return nil }
        return imagePath
    }
    
    func downloadImage(for url: URL, imageName: String, completion: @escaping (Result<ImagePath, Error>) -> Void) {
        let downloadTask = urlSession.downloadTask(with: url) { (fileUrl, response, error) in
            guard let fileUrl = fileUrl else {
                logger.error("Downloading failed with error: \(String(describing: error))")
                DispatchQueue.main.async {
                    completion(.failure(.downloadingError(error)))
                }
                return
            }
            
            let storeResult = self.storeImage(named: imageName, sourceUrl: fileUrl)
            DispatchQueue.main.async {
                completion(storeResult)
            }
        }
        downloadTask.resume()
    }

    func storeImage(named imageName: String, sourceUrl: URL) -> Result<ImagePath, Error> {
        let imagePath = pathForImage(named: imageName)
        if fileManager.fileExists(atPath: imagePath) {
            do {
                try fileManager.removeItem(atPath: imagePath)
            } catch {
                logger.error("Cannot delete file at path:\(imagePath).\nError: \(error).")
                return .failure(.imageStoringError(error))
            }
        }
        
        let destinationUrl = URL(fileURLWithPath: imagePath)

        do {
            try fileManager.moveItem(at: sourceUrl, to: destinationUrl)
        } catch {
            logger.error("Cannot copy file from path:\(sourceUrl) to path: \(destinationUrl).\nError: \(error).")
            return .failure(.imageStoringError(error))
        }
        
        return .success(imagePath)
    }
    
    func pathForImage(named imageName: String) -> ImagePath {
        return storagePath + imageName
    }
}
