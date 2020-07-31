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

import Quick
import Nimble
@testable import CV

class DataSourceTests: QuickSpec {
    override func spec() { //swiftlint:disable:this function_body_length
        describe("DataSource snapshot created from") {
            context("view model with image url") {
                let viewModel = ViewModel(imageURL: .stub, fullname: "", introduction: "", contactItems: [], carrerHistory: [], additionalInfo: [])
                
                it("contains one section") {
                    let snapshot = DataSource.snapshot(from: viewModel)
                    
                    expect(snapshot.sectionIdentifiers) == [.image]
                }
                
                it("contains one item") {
                    let snapshot = DataSource.snapshot(from: viewModel)
                    
                    expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub)]
                }
                
                context("and contact items") {
                    let contactItems = (1...3).map { ViewModel.ContactItem(name: "\($0)", value: "\($0)\($0)") }
                    let viewModel = ViewModel(imageURL: .stub, fullname: "", introduction: "", contactItems: contactItems, carrerHistory: [], additionalInfo: [])
                    
                    it("contains one section") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.sectionIdentifiers) == [.image]
                    }
                    
                    it("contains one item") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub)]
                    }
                }
                
                context("and fullname") {
                    let fullname = "Full Name"
                    let viewModel = ViewModel(imageURL: .stub, fullname: fullname, introduction: "", contactItems: [], carrerHistory: [], additionalInfo: [])
                    
                    it("contains two sections") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.sectionIdentifiers) == [.image, .personal]
                    }
                    
                    it("contains two items") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.itemIdentifiers) ==  [DataSource.ImageSectionItem.url(.stub),
                                                              DataSource.PersonalSectionItem.fullname(fullname)]
                    }
                    
                    context("and contact items") {
                        let contactItems = (1...3).map { ViewModel.ContactItem(name: "\($0)", value: "\($0)\($0)") }
                        let viewModel = ViewModel(imageURL: .stub, fullname: fullname, introduction: "", contactItems: contactItems, carrerHistory: [], additionalInfo: [])
                        
                        it("contains two sections") {
                            let snapshot = DataSource.snapshot(from: viewModel)
                            
                            expect(snapshot.sectionIdentifiers) == [.image, .personal]
                        }
                        
                        it("returns all items") {
                            let snapshot = DataSource.snapshot(from: viewModel)
                            
                            expect(snapshot.itemIdentifiers) ==  [DataSource.ImageSectionItem.url(.stub),
                                                                  DataSource.PersonalSectionItem.fullname(fullname)] + (1...3).map {
                                                                    DataSource.PersonalSectionItem.contact(type: "\($0)", value: "\($0)\($0)")
                            }
                        }
                    }
                }
                
                context("and introduction") {
                    let introduction = "introduction"
                    let viewModel = ViewModel(imageURL: .stub, fullname: "", introduction: introduction, contactItems: [], carrerHistory: [], additionalInfo: [])
                    
                    it("contains two sections") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.sectionIdentifiers) == [.image, .about]
                    }
                    
                    it("contains two items") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub),
                                                             DataSource.AboutSectionItem.text(introduction)]
                    }
                }
                
                context("and carrer history") {
                    let carrerHistory = [ViewModel.CarrerSection.init(title: "1", items: [ViewModel.CarrerItem(title: "title1", subtitle: "subtitle1", description: "description1")]),
                                         ViewModel.CarrerSection.init(title: "", items: [ViewModel.CarrerItem(title: "title2", subtitle: "subtitle2", description: "description2")])]
                    let viewModel = ViewModel(imageURL: .stub, fullname: "", introduction: "", contactItems: [], carrerHistory: carrerHistory, additionalInfo: [])
                    
                    it("contains two sections") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.sectionIdentifiers) == [.image, .carrer]
                    }
                    
                    it("contains many items") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub),
                                                             DataSource.CarrerSectionItem.title("1"),
                                                             DataSource.CarrerSectionItem.item(title: "title1", subtitle: "subtitle1", text: "description1"),
                                                             DataSource.CarrerSectionItem.title(""),
                                                             DataSource.CarrerSectionItem.item(title: "title2", subtitle: "subtitle2", text: "description2")]
                    }
                }
                
                context("and additional info") {
                    let additionalInfo = [ViewModel.AdditionalInfoItem(title: "1", content: "12"),
                                          ViewModel.AdditionalInfoItem(title: "3", content: "45")]
                    let viewModel = ViewModel(imageURL: .stub, fullname: "", introduction: "", contactItems: [], carrerHistory: [], additionalInfo: additionalInfo)
                    
                    it("contains two sections") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.sectionIdentifiers) == [.image, .more]
                    }
                    
                    it("contains many items") {
                        let snapshot = DataSource.snapshot(from: viewModel)
                        
                        expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub),
                                                             DataSource.MoreSectionItem.title("1"),
                                                             DataSource.MoreSectionItem.content("12"),
                                                             DataSource.MoreSectionItem.title("3"),
                                                             DataSource.MoreSectionItem.content("45")]
                    }
                }
            }
            
            context("complete view model") {
                let viewModel = ViewModel(imageURL: .stub,
                                          fullname: "Full Name",
                                          introduction: "introduction",
                                          contactItems: [.init(name: "name", value: "value")],
                                          carrerHistory: [.init(title: "title", items: [.init(title: "title", subtitle: "subtitle", description: "description")])],
                                          additionalInfo: [.init(title: "title", content: "content")])
                
                it("contains two sections") {
                    let snapshot = DataSource.snapshot(from: viewModel)
                    
                    expect(snapshot.sectionIdentifiers) == [.image, .personal, .about, .carrer, .more]
                }
                
                it("contains many items") {
                    let snapshot = DataSource.snapshot(from: viewModel)
                    
                    expect(snapshot.itemIdentifiers) == [DataSource.ImageSectionItem.url(.stub),
                                                         DataSource.PersonalSectionItem.fullname("Full Name"),
                                                         DataSource.PersonalSectionItem.contact(type: "name", value: "value"),
                                                         DataSource.AboutSectionItem.text("introduction"),
                                                         DataSource.CarrerSectionItem.title("title"),
                                                         DataSource.CarrerSectionItem.item(title: "title", subtitle: "subtitle", text: "description"),
                                                         DataSource.MoreSectionItem.title("title"),
                                                         DataSource.MoreSectionItem.content("content")]
                }
            }
        }
    }
}
