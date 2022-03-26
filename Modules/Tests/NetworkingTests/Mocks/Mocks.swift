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

@testable import Networking
import TestHelpers
import Foundation
import Combine

extension APIClient.Endpoint {
    static let stub = Self(urlBuilder: stubReturn(with: .stub))
}

extension APIClient {
    static func client(
        baseURL: @escaping () -> URL = { .stub },
        dataTask: @escaping (URL) -> AnyPublisher<Data, Error> = unimplemented(),
        downloadTask: @escaping (URL) -> AnyPublisher<URL, Error> = unimplemented()
    ) -> APIClient {
        self.init(
            baseURL: baseURL,
            dataTask: dataTask,
            downloadTask: downloadTask
        )
    }
}
