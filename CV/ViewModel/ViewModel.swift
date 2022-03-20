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

struct ViewModel: Equatable, Codable {
    struct ContactItem: Hashable, Codable {
        let name: String
        let value: String
    }
    
    struct AdditionalInfoItem: Equatable, Codable {
        let title: String
        let content: String
    }
    
    struct CareerSection: Equatable, Codable {
        let title: String
        let items: [CareerItem]
    }
    
    struct CareerItem: Equatable, Codable {
        let title: String
        let subtitle: String
        let description: String
    }
    
    let imageURL: URL
    let fullname: String
    let introduction: String
    let contactItems: [ContactItem]
    let careerHistory: [CareerSection]
    let additionalInfo: [AdditionalInfoItem]
}
