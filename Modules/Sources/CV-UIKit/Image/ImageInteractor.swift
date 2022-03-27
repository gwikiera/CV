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
import Networking
import Combine

protocol ImageBusinessLogic {
    func loadImage()
}

final class ImageInteractor: ImageBusinessLogic {
    let presenter: ImagePresentationLogic
    let imageUrl: URL
    let provider: ImageProvider
    private var cancellable: Cancellable?

    init(presenter: ImagePresentationLogic,
         imageUrl: URL,
         provider: ImageProvider) {
        self.presenter = presenter
        self.imageUrl = imageUrl
        self.provider = provider
    }
    
    func loadImage() {
        presenter.presentLoading()
        cancellable = provider.imagePathPublisher(for: imageUrl)
            .handleEvents(receiveSubscription: { [presenter] _ in
                presenter.presentLoading()
            })
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [presenter] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    presenter.presentError(error)
                }
            } receiveValue: { [presenter] imagePath in
                presenter.presentImage(at: imagePath)
            }
    }
}
