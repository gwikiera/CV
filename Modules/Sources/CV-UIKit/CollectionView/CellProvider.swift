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
import UIKitHelpers
import Logger
import Networking
import Translations
import Combine

class CellProvider {
    typealias SectionCellProvider = (UICollectionView, IndexPath, CollectionViewState.Item) -> UICollectionViewCell?
    let imageProvider: ImageProvider

    init(
        collectionView: UICollectionView,
        imageProvider: ImageProvider
    ) {
        collectionView.register(ImageCollectionViewCell.self)
        collectionView.register(HeaderCollectionViewCell.self)
        collectionView.register(ContactCollectionViewCell.self)
        collectionView.register(AboutCollectionViewCell.self)
        collectionView.register(CareerHeaderCollectionViewCell.self)
        collectionView.register(CareerCollectionViewCell.self)
        self.imageProvider = imageProvider
    }
    
    func provideCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        guard let section = CollectionViewState.Section.Kind(rawValue: indexPath.section) else {
            logger.assert("Unknown section for indexPath: \(indexPath)")
            return nil
        }

        switch section {
        case .image:
            return provideImageSectionCell(collectionView: collectionView, indexPath: indexPath, item: item)
        case .personal:
            return providePersonalSectionCell(collectionView: collectionView, indexPath: indexPath, item: item)
        case .about:
            return provideAboutSectionCell(collectionView: collectionView, indexPath: indexPath, item: item)
        case .career:
            return provideCareerSectionCell(collectionView: collectionView, indexPath: indexPath, item: item)
        case .more:
            return provideMoreSectionCell(collectionView: collectionView, indexPath: indexPath, item: item)
        }
    }
}

private extension CellProvider {
    func provideImageSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let sectionItem = item as? CollectionViewState.ImageSectionItem, case .url(let url) = sectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        let imagePresenter = ImagePresenter()
        let imageInteractor = ImageInteractor(presenter: imagePresenter,
                                              imageUrl: url,
                                              provider: imageProvider)
        cell.interactor = imageInteractor
        imagePresenter.view = cell
        cell.imageScalePublisher = collectionView.bounceScalePublisher()
        return cell
    }
    
    func providePersonalSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        guard let sectionItem = item as? CollectionViewState.PersonalSectionItem else {
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
    
    func provideAboutSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        guard let sectionItem = item as? CollectionViewState.AboutSectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        switch sectionItem {
        case .text(let text):
            let cell: AboutCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setHeader(String.Localized.about, text: text)
            return cell
        }
    }
    
    func provideCareerSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        guard let sectionItem = item as? CollectionViewState.CareerSectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        switch sectionItem {
        case .title(let text):
            let cell: CareerHeaderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(text: text)
            return cell
        case .item(let title, let subtitle, let description):
            let cell: CareerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(title: title, subtitle: subtitle, description: description)
            return cell
        }
    }
    
    func provideMoreSectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: CollectionViewState.Item) -> UICollectionViewCell? {
        guard let sectionItem = item as? CollectionViewState.MoreSectionItem else {
            logger.assert("Invalid item type: \(item) for index path: \(indexPath).")
            return nil
        }
        switch sectionItem {
        case .item(let title, let content):
            let cell: AboutCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setHeader(title, text: content)
            return cell
        }
    }
}

private extension UIScrollView {
    func bounceScalePublisher() -> AnyPublisher<CGFloat, Never> {
        Publishers.CombineLatest(
            publisher(for: \.adjustedContentInset).map(\.top),
            publisher(for: \.contentOffset).map(\.y)
        )
        .map(+)
        .filter { $0 < 0 }
        .map { $0 * -1 }
        .eraseToAnyPublisher()
    }
}
