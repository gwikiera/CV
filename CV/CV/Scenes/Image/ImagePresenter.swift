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

typealias ImagePath = String

protocol ImagePresentationLogic {
    func presentLoading()
    func presentImage(at imagePath: ImagePath)
    func presentError(_ error: Error)
}

final class ImagePresenter: ImagePresentationLogic {
    weak var view: ImageViewLogic!
    
    func presentLoading() {
        view.displayLoading()
    }
    
    func presentImage(at imagePath: ImagePath) {
        view.displayImage(at: imagePath)
    }

    func presentError(_ error: Error) {
        view.displayErrorMessage(error.localizedDescription)
    }
}
