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
    
import Foundation
import TestHelpers
@testable import CV

enum ImageProviding {
    // MARK: - Stub
    class Stub: CV.ImageProviding {
        lazy var imagePathStub = stub(of: imagePath)
        func imagePath(for url: URL, completion: @escaping (Result<ImagePath, Error>) -> Void) {
            imagePathStub(url, completion)
        }
    }
    
    // MARK: - Spy
    class Spy: CV.ImageProviding {
        lazy var imagePathSpy = spyCompletion(of: imagePath)
        func imagePath(for url: URL, completion: @escaping (Result<ImagePath, Error>) -> Void) {
            imagePathSpy.register(with: url)
        }
    }

    // MARK: - Dummy
    class Dummy: CV.ImageProviding {
        func imagePath(for url: URL, completion: @escaping (Result<ImagePath, Error>) -> Void) {}
    }
}
