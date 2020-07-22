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
import Logging

class ViewController: UICollectionViewController {
}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewControllerCell", for: indexPath)
        
        guard let path = Bundle.main.path(forResource: "Profile", ofType: "jpeg") else {
            return cell
        }
        logger.debug("Loading image at path: \(path)")
        
        let url = URL(fileURLWithPath: path)

        let imagePresenter = ImagePresenter()
        let imageProvider = ImageProvider()
        let imageInteractor = ImageInteractor(presenter: imagePresenter,
                                              imageUrl: url,
                                              provider: imageProvider)
        let imageViewController = ImageViewController(interactor: imageInteractor)
        imagePresenter.view = imageViewController
        embed(viewController: imageViewController, containerView: cell.contentView)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 300, height: 300)
    }
}
