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
@testable import CV_UIKit

enum ImageViewLogic {
    // MARK: - Spy
    class Spy: CV_UIKit.ImageViewLogic {
        lazy var displayLoadingSpy = spy(of: displayLoading)
        func displayLoading() {
            displayLoadingSpy.register()
        }
        
        lazy var displayImageSpy = spy(of: displayImage)
        func displayImage(at imagePath: String) {
            displayImageSpy.register(with: imagePath)
        }
        
        lazy var displayErrorMessageSpy = spy(of: displayErrorMessage)
        func displayErrorMessage(_ message: String) {
            displayErrorMessageSpy.register(with: message)
        }
    }
}
