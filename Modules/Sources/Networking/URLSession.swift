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

extension URLSession {
    func downloadDataPublisher(for url: URL) -> AnyPublisher<(tempFileURL: URL, response: URLResponse), URLError> {
        Deferred {
            Future<(tempFileURL: URL, response: URLResponse), URLError> { promise in
                self.downloadTask(with: url) { tempFileURL, response, error in
                    guard let tempFileURL = tempFileURL, let response = response else {
                        promise(.failure(error as? URLError ?? URLError(.unknown)))
                        return
                    }
                    promise(.success((tempFileURL: tempFileURL, response: response)))
                }.resume()
            }
        }
        .eraseToAnyPublisher()
    }
}
