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
    override func spec() {
        let viewController = UIViewController()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let tested = CellProvider(viewController: viewController, collectionView: collectionView)

        describe("CellProvider") {
            context("for image section") {
                context("and invalid object") {
                    it("returns nil") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: IndexPath(row: 0, section: DataSource.Section.image.rawValue),
                                                      item: "")
                        
                        expect(cell).to(beNil())
                    }
                }

                context("and invalid object") {
                    it("provides image cell") {
                        let cell = tested.provideCell(collectionView: collectionView,
                                                      indexPath: IndexPath(row: 0, section: DataSource.Section.image.rawValue),
                                                      item: DataSource.ImageSectionItem.url(.stub))
                        
                        expect(cell).to(beAKindOf(UICollectionViewCell.self))
                    }
                }
            }
        }
    }
}
