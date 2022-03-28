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
import Data

public struct CollectionViewState: Equatable {
    public typealias Item = AnyHashable

    struct Section: Equatable {
        enum Kind: Int, Hashable, CaseIterable { // swiftlint:disable:this nesting
            case image
            case personal
            case about
            case career
            case more
        }

        let kind: Kind
        let items: [Item]
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
    
    enum CareerSectionItem: Hashable {
        case title(String)
        case item(title: String, subtitle: String, text: String)
    }
    
    enum MoreSectionItem: Hashable {
        case item(title: String, content: String)
    }

    let sections: [Section]
}
