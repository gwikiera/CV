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

extension Publisher {
    func ignoreFailure() -> AnyPublisher<Output, Never> {
        self.catch { error -> Empty<Output, Never> in
            logger.trace("Ignoring error: \(error)")
            return Empty(completeImmediately: false)
        }
            .eraseToAnyPublisher()
    }
}
