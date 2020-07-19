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

class ImageProviderTests: QuickSpec {
    override func spec() {
        describe("ImageProviderTests when loading image") {
            context("for invalid url") {
                it("calls completion with downloading error") {
                    let url = URL.stub
                    let tested = ImageProvider()
                    let completionSpy: Spy<Result<UIImage, Error>> = .init()
                    
                    tested.image(for: url) { result in
                        completionSpy.register(with: result)
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).to(throwError(ImageProvider.Error.downloadingError(nil)))
                }
            }
            
            context("for invalid data url") {
                it("calls completion with invalid data error") {
                    let url = JSON.empty.url
                    let tested = ImageProvider()
                    let completionSpy: Spy<Result<UIImage, Error>> = .init()
                    
                    tested.image(for: url) { result in
                        completionSpy.register(with: result)
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).to(throwError(ImageProvider.Error.invalidData))
                }
            }
            
            context("for image url") {
                it("calls completion with image data") {
                    let url = Image.whitePixel.url
                    let tested = ImageProvider()
                    let completionSpy: Spy<Result<UIImage, Error>> = .init()
                    
                    tested.image(for: url) { result in
                        completionSpy.register(with: result)
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).toNot(throwError())
                    expect(try completionSpy.invokedParameters?.get()).toNot(beNil())
                }
            }
        }
    }
}
