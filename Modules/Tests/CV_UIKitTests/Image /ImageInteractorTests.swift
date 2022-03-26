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
@testable import CV_UIKit

class ImageInteractorTests: QuickSpec {
    override func spec() {
        describe("ImageInteractor when loading image") {
            context("started") {
                it("presents loading") {
                    let presenter = ImagePresentationLogic.Spy()
                    let tested = ImageInteractor(presenter: presenter, imageUrl: .stub, provider: ImageProviding.Dummy())
                    
                    tested.loadImage()
                    
                    expect(presenter.presentLoadingSpy.wasInvoked) == true
                }

                it("does nothing for nil url") {
                    let imageProvider = ImageProviding.Spy()
                    let tested = ImageInteractor(presenter: ImagePresentationLogic.Dummy(), imageUrl: nil, provider: imageProvider)

                    tested.loadImage()

                    expect(imageProvider.imagePathSpy.wasInvoked(with: .stub)) == false
                }

                it("asks for image if url is not nil") {
                    let imageProvider = ImageProviding.Spy()
                    let tested = ImageInteractor(presenter: ImagePresentationLogic.Dummy(), imageUrl: .stub, provider: imageProvider)
                    
                    tested.loadImage()
                    
                    expect(imageProvider.imagePathSpy.wasInvoked(with: .stub)) == true
                }
            }
            
            context("succeded") {
                it("presents image") {
                    let presenter = ImagePresentationLogic.Spy()
                    let imageProvider = ImageProviding.Stub()
                    imageProvider.imagePathStub = { _, completion in completion(.success(.stub)) }
                    let tested = ImageInteractor(presenter: presenter, imageUrl: .stub, provider: imageProvider)
                    
                    tested.loadImage()
                    
                    expect(presenter.presentImageSpy.wasInvoked(with: .stub)) == true
                }
            }
            
            context("failed") {
                it("presents error") {
                    let error = ErrorStub()
                    let presenter = ImagePresentationLogic.Spy()
                    let imageProvider = ImageProviding.Stub()
                    imageProvider.imagePathStub = { _, completion in completion(.failure(error)) }
                    let tested = ImageInteractor(presenter: presenter, imageUrl: .stub, provider: imageProvider)
                    
                    tested.loadImage()
                    
                    expect(presenter.presentErrorSpy.wasInvoked) == true
                    expect(presenter.presentErrorSpy.invokedParameters) === error
                }
            }
        }
    }
}