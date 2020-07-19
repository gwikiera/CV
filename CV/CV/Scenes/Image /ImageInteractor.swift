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

protocol ImageBusinessLogic {
    func loadImage()
}

final class ImageInteractor: ImageBusinessLogic {
    let presenter: ImagePresentationLogic
    let url: URL
    let provider: ImageProviding
    
    init(presenter: ImagePresentationLogic,
         url: URL,
         provider: ImageProviding) {
        self.presenter = presenter
        self.url = url
        self.provider = provider
    }
    
    func loadImage() {
        presenter.presentLoading()
        provider.image(for: url) { [presenter] result in
            switch result {
            case .success(let image):
                presenter.presentImage(image)
            case .failure(let error):
                presenter.presentError(error)
            }
        }
    }
}
