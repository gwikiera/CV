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
    
import Combine
import Nimble

public extension Publisher {
    static func stubOutput(_ value: Output) -> AnyPublisher<Output, Failure> {
        Just(value)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    static func stubFailure(_ error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(outputType: Output.self, failure: error).eraseToAnyPublisher()
    }

    static func noop(completeImmediately: Bool = false) -> AnyPublisher<Output, Failure> {
        Empty(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }
}

public extension Publisher where Output: Equatable {
    func expectFirstValue(
        _ expectedValue: Output,
        file: FileString = #file,
        line: UInt = #line
    ) {
        var output: Output?

        _ = first()
            .sink(
                receiveCompletion: { _ in /* No handling needed */ },
                receiveValue: {
                    output = $0
                })

        expect(file: file, line: line, { output }).to(equal(expectedValue))
    }

    func expectLastValue(
        _ expectedValue: Output,
        file: FileString = #file,
        line: UInt = #line
    ) {
        var output: Output?

        _ = sink(
            receiveCompletion: { _ in /* No handling needed */ },
            receiveValue: {
                output = $0
            })

        expect(file: file, line: line, { output }).to(equal(expectedValue))
    }

    func expectValues(
        _ expectedValues: [Output],
        file: FileString = #file,
        line: UInt = #line
    ) {
            var outputs: [Output] = []

            _ = sink(
                receiveCompletion: { _ in /* No handling needed */ },
                receiveValue: {
                    outputs.append($0)
                })

        expect(file: file, line: line, { outputs }).to(equal(expectedValues))
        }

    func expectNoValues(
        file: FileString = #file,
        line: UInt = #line
    ) {
        expectValues([], file: file, line: line)
    }
}

public extension Publisher {
    func firstResult() async -> Result<Output, Error> {
        return await withCheckedContinuation { continuation in
            _ = first()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(returning: .failure(error))
                    }
                } receiveValue: { value in
                    continuation.resume(returning: .success(value))
                }
        }
    }

    func expectComplete(
        file: FileString = #file,
        line: UInt = #line
    ) {
        var completed: Bool = false
        _ = sink(
            receiveCompletion: { result in
                switch result {
                case .failure:
                    break
                case .finished:
                    completed = true
                }
            },
            receiveValue: { _ in  /* receiveValue is a Combine requirement */ }
        )

        expect(file: file, line: line, { completed }).to(beTrue())
    }

    func expectFailure(
        _ expected: Failure,
        file: FileString = #file,
        line: UInt = #line
    ) where Failure: Equatable {
            var expectFailure: Failure?

            _ = sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    expectFailure = error
                case .finished: break
                }
            }, receiveValue: { _ in  /* No value */ })

        expect(file: file, line: line, { expectFailure }).to(matchError(expected))
    }
}
