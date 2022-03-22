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

public struct ViewModel: Equatable, Codable {
    public struct ContactItem: Hashable, Codable {
        public let name: String
        public let value: String
    }
    
    public struct AdditionalInfoItem: Equatable, Codable {
        public let title: String
        public let content: String
    }
    
    public struct CareerSection: Equatable, Codable {
        public let title: String
        public let items: [CareerItem]
    }
    
    public struct CareerItem: Equatable, Codable {
        public let title: String
        public let subtitle: String
        public let description: String
    }
    
    public let imageURL: URL
    public let fullname: String
    public let introduction: String
    public let contactItems: [ContactItem]
    public let careerHistory: [CareerSection]
    public let additionalInfo: [AdditionalInfoItem]
}
