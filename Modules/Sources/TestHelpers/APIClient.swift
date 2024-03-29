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
@testable import Networking

public extension APIClient.Endpoint {
    static let stub = Self(urlBuilder: stubReturn(with: .stub))
}

public extension APIClient {
    static func client(
        baseURL: @escaping () -> URL = stubReturn(with: .stub),
        dataTask: @escaping (URL) -> AnyPublisher<Data, Error> = { _ in fatalError() },
        downloadTask: @escaping (URL) -> AnyPublisher<URL, Error> = { _ in fatalError() }
    ) -> APIClient {
        self.init(
            baseURL: baseURL,
            dataTask: dataTask,
            downloadTask: downloadTask
        )
    }

    static let failing = Self(
        baseURL: stubReturn(with: .stub),
        dataTask: stubReturn(with: .stubFailure(errorStub)),
        downloadTask: stubReturn(with: .stubFailure(errorStub))
    )

    mutating func overrideDataTask(
        endpoint: Endpoint,
        withResult result: Result<Data, Error>
    ) {
        self.dataTask = { [self] url in
            if self.url(for: endpoint) == url {
                return result.publisher.eraseToAnyPublisher()
            } else {
                return self.dataTask(url)
            }
        }
    }

    mutating func overrideDataTask<T: Encodable>(
        endpoint: Endpoint,
        with result: T
    ) {
        self.dataTask = { [self] url in
            if self.url(for: endpoint) == url {
                do {
                    let data = try JSONEncoder().encode(result)
                    return AnyPublisher<Data, Error>.stubOutput(data)
                } catch {
                    return AnyPublisher<Data, Error>.stubFailure(error)
                }
            } else {
                return self.dataTask(url)
            }
        }
    }

    mutating func overrideDownloadTask(
        endpoint: Endpoint,
        withResult result: Result<URL, Error>
    ) {
        self.downloadTask = { [self] url in
            if self.url(for: endpoint) == url {
                return result.publisher.eraseToAnyPublisher()
            } else {
                return self.downloadTask(url)
            }
        }
    }
}
