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

enum DataSource {
    enum Section: Int, Hashable, CaseIterable {
        case image
        case personal
        case about
        case carrer
        case more
    }
    
    enum ImageSectionItem: Hashable {
        case url(URL)
    }
    
    enum PersonalSectionItem: Hashable {
        case fullname(String)
        case contact(type: String, value: String)
    }
    
    enum AboutSectionItem: Hashable {
        case text(String)
    }
    
    enum CarrerSectionItem: Hashable {
        case title(String)
        case item(title: String, subtitle: String, text: String)
    }
    
    enum MoreSectionItem: Hashable {
        case item(title: String, content: String)
    }
}

extension DataSource {
    static func snapshot(from viewModel: ViewModel) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        Section.allCases.forEach { section in
            let items = self.items(for: section, from: viewModel)
            guard !items.isEmpty else { return }
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }

        return snapshot
    }
    
    private static func items(for section: Section, from viewModel: ViewModel) -> [AnyHashable] {
        switch section {
        case .image:
            return [ImageSectionItem.url(viewModel.imageURL)]
        case .personal:
            guard !viewModel.fullname.isEmpty else {
                logger.error("Empty full name, personal section will not be presented.")
                return []
            }
            let contactInfo = viewModel.contactItems.map { PersonalSectionItem.contact(type: $0.name, value: $0.value) }
            return [PersonalSectionItem.fullname(viewModel.fullname)] + contactInfo
        case .about:
            guard !viewModel.introduction.isEmpty else {
                logger.error("Empty introduction, about section will not be presented.")
                return []
            }
            return [AboutSectionItem.text(viewModel.introduction)]
        case .carrer:
            return viewModel.carrerHistory.reduce(.init()) { (result, section) in
                return result + [CarrerSectionItem.title(section.title)] + section.items.map { item in
                    CarrerSectionItem.item(title: item.title,
                                           subtitle: item.subtitle,
                                           text: item.description)
                }
            }
        case .more:
            return viewModel.additionalInfo.reduce(.init()) { (result, section) in
                return result + [MoreSectionItem.item(title: section.title, content: section.content)]
            }
        }
    }
}
