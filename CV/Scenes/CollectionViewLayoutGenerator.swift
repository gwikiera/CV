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

final class CollectionViewLayoutGenerator {
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            guard let dataSection = DataSource.Section(rawValue: section) else {
                logger.assert("Unknown section: \(section)")
                return nil
            }

            switch dataSection {
            case .image:
                return self.imageSectionLayout(for: environment)
            case .personal, .about:
                return self.fullWidthSectionLayout(for: environment)
            default:
                // TODO: Fix later
                return self.fullWidthSectionLayout(for: environment)
            }
        }
        return layout
    }
}

private extension CollectionViewLayoutGenerator {
    func imageSectionLayout(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupHeightDimmension: NSCollectionLayoutDimension = environment.traitCollection.verticalSizeClass == .compact ? .fractionalHeight(1.0) : .fractionalWidth(1.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeightDimmension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    func fullWidthSectionLayout(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: itemSize.widthDimension,
            heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
}
