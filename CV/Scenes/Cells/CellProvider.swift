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

class CellProvider {
    typealias SectionCellProvider = (UICollectionView, IndexPath, AnyHashable) -> UICollectionViewCell?
    
    weak var viewController: UIViewController?
    
    private lazy var sectionProviders: [DataSource.Section: SectionCellProvider] = [.image: provideImageSectionCell,
                                                                                    .personal: providePersonalSectionCell]

    init(viewController: UIViewController, collectionView: UICollectionView) {
        self.viewController = viewController
        
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(HeaderCollectionViewCell.self)
        collectionView.register(ContactCollectionViewCell.self)
    }
    
    func provideCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        guard let section = DataSource.Section(rawValue: indexPath.section) else {
            logger.assert("Unknown section for indexPath: \(indexPath)")
            return nil
        }
        
        guard let sectionProvider = sectionProviders[section] else {
            logger.assert("Section provider for section: \(section) not found.")
            return nil
        }

        return sectionProvider(collectionView, indexPath, item)
    }
}

private extension CellProvider {
    func provideImageSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let sectionItem = item as? DataSource.ImageSectionItem, case .url(let url) = sectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        let imagePresenter = ImagePresenter()
        let imageProvider = ImageProvider()
        let imageInteractor = ImageInteractor(presenter: imagePresenter,
                                              imageUrl: url,
                                              provider: imageProvider)
        let imageViewController = ImageViewController(interactor: imageInteractor)
        imagePresenter.view = imageViewController
        viewController?.embed(viewController: imageViewController, containerView: cell.contentView)
        return cell
    }
    
    func providePersonalSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        guard let sectionItem = item as? DataSource.PersonalSectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        switch sectionItem {
        case .fullname(let fullname):
            let cell: HeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setText(fullname)
            return cell
        case .contact(type: let type, value: let value):
            let cell: ContactCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(type: type, value: value)
            return cell
        }
    }
}
