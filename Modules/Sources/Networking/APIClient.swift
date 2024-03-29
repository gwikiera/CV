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
import Common

// Based on pointfree.co dependencies style
// Reference: https://www.pointfree.co/collections/dependencies
public struct APIClient {
    public typealias BaseURL = URL

    public struct Endpoint {
        let urlBuilder: (BaseURL) -> URL

        public init(urlBuilder: @escaping (BaseURL) -> URL) {
            self.urlBuilder = urlBuilder
        }
    }

    var baseURL: () -> BaseURL
    var dataTask: (URL) -> AnyPublisher<Data, Error>
    var downloadTask: (URL) -> AnyPublisher<URL, Error>

    public init(
        baseURL: @escaping () -> BaseURL,
        dataTask: @escaping (URL) -> AnyPublisher<Data, Error>,
        downloadTask: @escaping (URL) -> AnyPublisher<URL, Error>
    ) {
        self.baseURL = baseURL
        self.dataTask = dataTask
        self.downloadTask = downloadTask
    }
}

public extension APIClient {
    static let noop = Self(
        baseURL: { "/" },
        dataTask: { _ in .noop },
        downloadTask: { _ in .noop }
    )

    static let unimplemented = Self(
        baseURL: { fatalError() },
        dataTask: { _ in fatalError() },
        downloadTask: { _ in fatalError() }
    )
}

public extension APIClient {
    func dataTaskPublisher(_ url: URL) -> AnyPublisher<Data, Error> {
        dataTask(url)
    }

    func dataTaskPublisher(_ endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        dataTaskPublisher(url(for: endpoint))
    }

    func downloadTaskPublisher(_ url: URL) -> AnyPublisher<URL, Error> {
        downloadTask(url)
    }

    func downloadTaskPublisher(_ endpoint: Endpoint) -> AnyPublisher<URL, Error> {
        downloadTaskPublisher(url(for: endpoint))
    }

    func request<A: Decodable>(
        endpoint: Endpoint,
        as type: A.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<A, Error> {
        self.dataTaskPublisher(endpoint)
            .decode(type: A.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func url(for endpoint: Endpoint) -> URL {
        endpoint.urlBuilder(baseURL())
    }
}
