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

private let url: URL = "https://raw.githubusercontent.com/gwikiera/CV/develop/Resources/CV.json"

// Based on pointfree.co dependencies style
// Reference: https://www.pointfree.co/collections/dependencies
struct ViewModelClient {
    let viewModel: () -> AnyPublisher<ViewModel, Error>
}

extension ViewModelClient {
    static let live = Self {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data: Data, _) in
                return data
            }
            .decode(type: ViewModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    #if DEBUG
    static let mock = Self {
        let path = Bundle.main.path(forResource: "CV", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path)) // swiftlint:disable:this force_try
        return Just(data)
            .decode(type: ViewModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    #endif
}
