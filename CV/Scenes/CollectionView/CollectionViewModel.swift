//
//  CV
//
//  Copyright 2022 - Grzegorz Wikiera - https://github.com/gwikiera
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
import Combine
import Networking
import Data
import Logger

final class CollectionViewModel {
    private let client: APIClient
    private let viewStateSubject = PassthroughSubject<CollectionViewState, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(client: APIClient) {
        self.client = client
    }

    var viewStatePublisher: AnyPublisher<CollectionViewState, Never> {
        viewStateSubject
            .eraseToAnyPublisher()
    }

    func viewLoaded() {
        Publishers.CombineLatest(
            client.downloadTaskPublisher(.image)
                .map { url -> URL? in url }
                .prepend(.none),
            client.request(endpoint: .data, as: Model.self)
        )
        .map(CollectionViewState.init)
        .ignoreFailure()
        .sink { [viewStateSubject] viewState in
            viewStateSubject.send(viewState)
        }
        .store(in: &cancellables)
    }
}

private extension CollectionViewState {
    init(imageURL: URL?, model: Model) {
        let sections = CollectionViewState.Section.Kind.allCases
            .map { kind -> CollectionViewState.Section in
                let items = CollectionViewState.items(for: kind, from: imageURL, model: model)
                return CollectionViewState.Section(kind: kind, items: items)
            }
        self.init(sections: sections)
    }

    static func items(for section: CollectionViewState.Section.Kind, from imageURL: URL?, model: Model) -> [CollectionViewState.Item] {
        switch section {
        case .image:
            return [CollectionViewState.ImageSectionItem.url(imageURL)]
        case .personal:
            guard !model.fullname.isEmpty else {
                logger.error("Empty full name, personal section will not be presented.")
                return []
            }
            let contactInfo = model.contactItems.map { CollectionViewState.PersonalSectionItem.contact(type: $0.name, value: $0.value) }
            return [CollectionViewState.PersonalSectionItem.fullname(model.fullname)] + contactInfo
        case .about:
            guard !model.introduction.isEmpty else {
                logger.error("Empty introduction, about section will not be presented.")
                return []
            }
            return [CollectionViewState.AboutSectionItem.text(model.introduction)]
        case .career:
            return model.careerHistory.reduce(.init()) { (result, section) in
                return result + [CollectionViewState.CareerSectionItem.title(section.title)] + section.items.map { item in
                    CollectionViewState.CareerSectionItem.item(
                        title: item.title,
                        subtitle: item.subtitle,
                        text: item.description
                    )
                }
            }
        case .more:
            return model.additionalInfo.reduce(.init()) { (result, section) in
                return result + [CollectionViewState.MoreSectionItem.item(title: section.title, content: section.content)]
            }
        }
    }
}
