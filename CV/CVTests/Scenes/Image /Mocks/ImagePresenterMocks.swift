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
    
import UIKit
@testable import CV

enum ImagePresentationLogic {
    // MARK: - Spy
    class Spy: CV.ImagePresentationLogic {
        lazy var presentLoadingSpy = spy(of: presentLoading)
        func presentLoading() {
            presentLoadingSpy.register()
        }
        
        lazy var presentImageSpy = spy(of: presentImage)
        func presentImage(_ imagePath: ImagePath) {
            presentImageSpy.register(with: imagePath)
        }
        
        lazy var presentErrorSpy = spy(of: presentError)
        func presentError(_ error: Error) {
            presentErrorSpy.register(with: error)
        }
    }
    
    // MARK: - Dummy
    class Dummy: CV.ImagePresentationLogic {
        func presentLoading() {}        
        func presentImage(_ imagePath: ImagePath) {}
        func presentError(_ error: Error) {}
    }
}
