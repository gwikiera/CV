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

protocol ImageProviding {
    func image(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageProvider: ImageProviding {
    enum Error: Swift.Error {
        case downloadingError(Swift.Error?)
        case invalidData
    }
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func image(for url: URL, completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        let downloadTask = urlSession.downloadTask(with: url) { (fileUrl, response, error) in
            guard let fileUrl = fileUrl else {
                logger.error("Downloading failed with error: \(String(describing: error))")
                completion(.failure(Error.downloadingError(error)))
                return
            }
            logger.debug("Image downloaded at path: \(fileUrl)")
            guard let image = UIImage(contentsOfFile: fileUrl.path) else {
                logger.error("Cannot create an image from file at path: \(fileUrl.path)")
                completion(.failure(Error.invalidData))
                return
            }
            completion(.success(image))
        }
        downloadTask.resume()
    }
}
