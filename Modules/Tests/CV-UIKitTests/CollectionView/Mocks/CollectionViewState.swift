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

@testable import CV_UIKit

extension CollectionViewState {
    static func stub(
        imageItems: [ImageSectionItem] = [],
        personalItems: [PersonalSectionItem] = [],
        aboutItems: [AboutSectionItem] = [],
        careerItems: [CareerSectionItem] = [],
        moreItems: [MoreSectionItem] = []
    ) -> CollectionViewState {
        let sections = [
            Section(kind: .image, items: imageItems),
            Section(kind: .personal, items: personalItems),
            Section(kind: .about, items: aboutItems),
            Section(kind: .career, items: careerItems),
            Section(kind: .more, items: moreItems)
        ]
        return .init(sections: sections)
    }

    static let mock = Self.stub(
        imageItems: [.url(Image.whitePixel.url)],
        personalItems: [.fullname("Full Name"), .contact(type: "name", value: "value")],
        aboutItems: [.text("introduction")],
        careerItems: [.title("title"), .item(title: "title", subtitle: "subtitle", text: "description")],
        moreItems: [.item(title: "title", content: "content")]
    )
}
