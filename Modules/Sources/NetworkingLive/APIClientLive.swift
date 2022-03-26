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
import Data
import Combine
import Common
import Networking

public extension APIClient.Endpoint {
    static let image = Self { url in
        url.appendingPathComponent("Profile.jpeg")
    }

    static let data = Self { url in
        url.appendingPathComponent("CV.json")
    }
}

public extension APIClient {
    private static let baseURL: URL = "https://raw.githubusercontent.com/gwikiera/CV/develop/Resources"

    static let live = Self(
        baseURL: { baseURL},
        dataTask: { url in
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .mapError { $0 }
                .eraseToAnyPublisher()
    },
        downloadTask: { url in
            URLSession.shared.downloadDataPublisher(for: url)
                .map(\.tempFileURL)
                .mapError { $0 }
                .eraseToAnyPublisher()
        }
    )

#if DEBUG
    static let mock = Self(
        baseURL: { URL(fileURLWithPath: Bundle.main.path(forResource: "CV", ofType: "json")!).deletingLastPathComponent() },
        dataTask: { url in
            Deferred {
                Future { promise in
                    do {
                        let data = try Data(contentsOf: url)
                        promise(.success(data))
                    } catch {
                        promise(.failure(error))
                    }
                    fatalError()
                }
            }
            .receive(on: DispatchQueue.global())
            .eraseToAnyPublisher()
        },
        downloadTask: { url in
            Just(url)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )
#endif
}
