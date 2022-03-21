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

private let baseURL: URL = "https://raw.githubusercontent.com/gwikiera/CV/develop/Resources"

// Based on pointfree.co dependencies style
// Reference: https://www.pointfree.co/collections/dependencies
struct ViewModelClient {
    let viewModelPublisher: () -> AnyPublisher<ViewModel, Error>
}

extension ViewModelClient {
    static let live = ViewModelClient.client(
        baseURL: baseURL,
        dataTaskPublisher: { url in
            URLSession.shared.dataTaskPublisher(for: url).map(\.data)
        }
    )

#if DEBUG
    static let mock = ViewModelClient.client(
        baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "CV", ofType: "json")!).deletingLastPathComponent(),
        dataTaskPublisher: { url in
            Future<Data, Error> { promise in
                do {
                    let data = try Data(contentsOf: url)
                    promise(.success(data))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    )
#endif
}

extension ViewModelClient {
    static func client<P: Publisher>(baseURL: URL,
                                     dataTaskPublisher: @escaping (URL) -> P
    ) -> ViewModelClient where P.Output == Data {
        self.init {
            dataTaskPublisher(baseURL.appendingPathComponent("CV.json"))
                .decode(type: ViewModel.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    }
}
