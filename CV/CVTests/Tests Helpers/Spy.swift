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

import XCTest

func spy<A, R>(of function: (A) -> R) -> Spy<A> {
    return .init()
}

func spy<A, R>(of function: (A...) -> R) -> Spy<[A]> {
    return .init()
}

func spyCompletion<A, C>(of function: (A, @escaping (C) -> Void) -> Void) -> Spy<A> {
    return .init()
}

class Spy<Arguments> {
    private(set) var invokedParametersList = [Arguments]()
    
    var invokedParameters: Arguments? {
        return invokedParametersList.last
    }
    
    var wasInvoked: Bool {
        return !invokedParametersList.isEmpty
    }
    
    func register(with arguments: Arguments) {
        invokedParametersList.append(arguments)
    }
}

extension Spy where Arguments == Void {
    func register() {
        register(with: ())
    }
}

extension Spy where Arguments: Equatable {
    func wasInvoked(with parameters: Arguments) -> Bool {
        wasInvoked && parameters == invokedParameters
    }
}
