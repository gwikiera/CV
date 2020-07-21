//
//  Workouts
//
//  Copyright 2019 - Grzegorz Wikiera - https://github.com/gwikiera
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

import UIKit

class ErrorStub: Error, LocalizedError {
    var errorDescription: String? {
        "errorDescription"
    }
}

extension URL {
    static let stub = URL(string: "scheme://host")!
}

extension URLRequest {
    static let stub = URLRequest(url: .stub)
}

extension Data {
    static let stub = Data()
}

extension UIImage {
    static let stub = UIImage()
}
