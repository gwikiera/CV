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

import Combine
import Nimble

public extension Publisher {
    func testObserver() -> CombineTestObserver<Output, Failure> {
        CombineTestObserver<Output, Failure>(publisher: self)
    }
}

public final class CombineTestObserver<Output, Failure: Error> {
    public var values: [Output] = []
    public var error: Failure?
    public var completed = false
    private var cancellable: AnyCancellable?

    init<P: Publisher>(publisher: P) where P.Output == Output, P.Failure == Failure {
        cancellable = publisher.sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.completed = true
                case.failure(let error):
                    self?.error = error
                }
            },
            receiveValue: { [weak self] value in
                self?.values += [value]
            }
        )
    }

    public func assertCount(
        _ expectedCount: Int,
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.values.count }).to(equal(expectedCount))
        }

    public func assertError(
        _ expectedError: Failure,
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.error }).to(matchError(expectedError))
        }

    public func assertComplete(
        file: FileString = #file,
        line: UInt = #line
    ) {
        expect(file: file, line: line, { self.completed }).to(beTrue())
    }
}

extension CombineTestObserver where Output: Equatable {
    public func assertValues(
        _ expectedValues: [Output],
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.values }).to(equal(expectedValues))
        }

    public func assertFirstValue(
        _ expectedValue: Output,
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.values.first }).to(equal(expectedValue))
        }

    public func assertLastValue(
        _ expectedValue: Output,
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.values.last }).to(equal(expectedValue))
        }

    public func assertNil(
        file: FileString = #file,
        line: UInt = #line) {
            expect(file: file, line: line, { self.values.last }).to(beNil())
        }
}
