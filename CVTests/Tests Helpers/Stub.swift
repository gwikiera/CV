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

func stub<T>(of value: T) -> T {
    return nil!
}

func dummy<T>() -> ((T) -> Void) {
    return { _ in }
}

func stubCompletion<A, T>(with value: T) -> ((A, @escaping (T) -> Void) -> Void) {
    return { _, completion in
        completion(value)
    }
}
