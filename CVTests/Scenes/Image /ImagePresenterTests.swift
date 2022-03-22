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
import TestHelpers
@testable import CV

class ImagePresenterTests: QuickSpec {
    override func spec() {
        let tested = ImagePresenter()
        let view = ImageViewLogic.Spy()
        tested.view = view

        describe("ImagePresenter") {
            context("presents image at path") {
                it("calls the view to display it") {
                    let imagePath = ImagePath.stub
                    
                    tested.presentImage(at: imagePath)
                    
                    expect(view.displayImageSpy.wasInvoked(with: imagePath)) == true
                }
            }
            
            context("presents loading") {
                it("calls the view to display loading state") {
                    tested.presentLoading()
                    
                    expect(view.displayLoadingSpy.wasInvoked) == true
                }
            }
            
            context("presents error") {
                it("calls the view to display its localized message") {
                    let error = ErrorStub.init()
                    
                    tested.presentError(error)
                    
                    expect(view.displayErrorMessageSpy.wasInvoked(with: error.localizedDescription)) == true
                }
            }
        }
    }
}
