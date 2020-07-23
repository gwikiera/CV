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

struct ViewModel {
    struct ContactItem {
        let name: String
        let value: String
    }
    
    struct AdditionalInfoItem {
        let title: String
        let content: String
    }
    
    struct CarrerSection {
        let title: String
        let items: [CarrerItem]
    }
    
    struct CarrerItem {
        let title: String
        let subtitle: String
        let description: String
    }
    
    let fullname: String
    let imageURL: URL
    let introduction: String
    let contactItems: [ContactItem]
    let carrerHistory: [CarrerSection]
    let additionalInfo: [AdditionalInfoItem]
}

extension ViewModel {
    static var example: ViewModel { //swiftlint:disable line_length
        guard let path = Bundle.main.path(forResource: "Profile", ofType: "jpeg") else {
            fatalError()
        }
        logger.debug("Loading image at path: \(path)")
        
        let url = URL(fileURLWithPath: path)
        
        return ViewModel(fullname: "Grzegorz Wikiera",
                         imageURL: url,
                         introduction: "I am an iOS developer with more than ten years of experience. I participated in many different projects, from building simple games for kids to designing and developing iOS frameworks. As a principal developer, I set up the standards of iOS development in the matter of architecture, tools, and code standards. I was presenting my findings on internal presentations and local meet-ups. Currently, I am leading one of the iOS teams in the company, which is responsible for most of the applications. I am still covering for the tech part, with some extra responsibilities. I am managing people, working on their development, motivation, and everything else which allows them to create the best products in an agile way.",
                         contactItems: [ContactItem(name: "phone", value: "+48 791 597 001"),
                                        ContactItem(name: "email", value: "gwikiera@gmail.com"),
                                        ContactItem(name: "LinkedIn", value: "https://www.linkedin.com/in/gwikiera"),
                                        ContactItem(name: "GitHub", value: "https://github.com/gwikiera")],
                         carrerHistory: [CarrerSection(title: "Experience", items: [CarrerItem(title: "iOS Team Lead",
                                                                                               subtitle: "William Hill (02.2019 – now)",
                                                                                               description: "Leading one of the two iOS teams responsible for all William Hill’s iOS apps, used by millions of our customers. Focusing on both aspects of the role: technical and managerial. I am mentoring other developers, setting up the standards for the whole process of creating iOS applications (development, testing, CI/CD), helping them with their career progress."),
                                                                                    CarrerItem(title: "Principal Software Developer",
                                                                                               subtitle: "William Hill (04.2018 – 01.2019)",
                                                                                               description: "Setting up the standards for the iOS developers inside the company, mentoring other developers, cooperating with other teams on shared projects. Conducting presentations on external meetups.")]),
                                         CarrerSection(title: "Education", items: [CarrerItem(title: "AGH University of Science and Technology", subtitle: "Master's degree (2011 – 2012)", description: ""),
                                                                                   CarrerItem(title: "AGH University of Science and Technology", subtitle: "Bachelor's degree (2007 – 2011)", description: "")])],
                         additionalInfo: [AdditionalInfoItem(title: "Skills", content: """
                         Swift, Objective C
                         Clean Swift, Viper, MVVM, MVC
                         Core Data, Realm
                         REST API
                         TDD, BDD, Quick, Nimble
                         UITests, Robot Pattern
                         Carthage, Rome, CocoaPods, SPM
                         Fastlane, Danger, Swiftlint, GitLab CI, CircleCI
                         JIRA, Trello, Confluence Agile/Scrum
"""), AdditionalInfoItem(title: "Interests", content: """
                         Climbing
                         Cycling
                         Running
                         Billiard
                         Urban infrastructure
""")])
    }
}
