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
import Quick
import Nimble
@testable import CV

class CellProviderTests: QuickSpec {
    override func spec() { //swiftlint:disable:this function_body_length
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let tested = CellProvider(collectionView: collectionView)
        let invalidItem = ""
        
        describe("CellProvider") {
            context("for invalid section") {
                let indexPath = IndexPath(row: 0, section: 999)

                it("returns nil") {
                    let cell = tested.provideCell(collectionView: collectionView,
                                                  indexPath: indexPath,
                                                  item: invalidItem)
                    
                    expect(cell).to(beNil())
                }
            }
            
            context("for image section") {
                let indexPath = IndexPath(row: 0, section: DataSource.Section.image.rawValue)
                context("and invalid object") {
                    it("returns nil") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: indexPath,
                                                      item: invalidItem)
                        
                        expect(cell).to(beNil())
                    }
                }

                context("and ImageSectionItem.url object") {
                    let item = DataSource.ImageSectionItem.url(.stub)
                    
                    it("provides ImageCollectionViewCell cell") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: indexPath,
                                                      item: item)
                        
                        expect(cell).to(beAnInstanceOf(ImageCollectionViewCell.self))
                    }
                }
            }
            
            context("for personal section") {
                let indexPath = IndexPath(row: 0, section: DataSource.Section.personal.rawValue)

                context("and invalid object") {
                    it("returns nil") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: indexPath,
                                                      item: invalidItem)
                        
                        expect(cell).to(beNil())
                    }
                }

                context("and PersonalSectionItem.fullname object") {
                    let item = DataSource.PersonalSectionItem.fullname("fullname")

                    it("provides HeaderCollectionViewCell cell") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: indexPath,
                                                      item: item)
                        
                        expect(cell).to(beAnInstanceOf(HeaderCollectionViewCell.self))
                    }
                }
                
                context("and PersonalSectionItem.contact object") {
                    let item = DataSource.PersonalSectionItem.contact(type: "type", value: "value")

                    it("provides ContactCollectionViewCell cell") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: indexPath,
                                                      item: item)
                        
                        expect(cell).to(beAnInstanceOf(ContactCollectionViewCell.self))
                    }
                }
            }
        }
    }
}
