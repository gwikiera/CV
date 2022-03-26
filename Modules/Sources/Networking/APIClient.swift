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

public typealias BaseURL = URL

public struct Endpoint {
    let urlBuilder: (BaseURL) -> URL
}

// Based on pointfree.co dependencies style
// Reference: https://www.pointfree.co/collections/dependencies
public struct APIClient {
    var baseURL: () -> BaseURL
    var dataTask: (URL) -> AnyPublisher<Data, Error>
    var downloadTask: (URL) -> AnyPublisher<URL, Error>

    public func dataTaskPublisher(_ url: URL) -> AnyPublisher<Data, Error> {
        dataTask(url)
    }

    public func dataTaskPublisher(_ endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        dataTaskPublisher(url(for: endpoint))
    }

    public func downloadTaskPublisher(_ url: URL) -> AnyPublisher<URL, Error> {
        downloadTask(url)
    }

    public func downloadTaskPublisher(_ endpoint: Endpoint) -> AnyPublisher<URL, Error> {
        downloadTaskPublisher(url(for: endpoint))
    }

    public func request<A: Decodable>(
        endpoint: Endpoint,
        as type: A.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<A, Error> {
        self.dataTaskPublisher(endpoint)
            .decode(type: A.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    public func url(for endpoint: Endpoint) -> URL {
        endpoint.urlBuilder(baseURL())
    }
}
