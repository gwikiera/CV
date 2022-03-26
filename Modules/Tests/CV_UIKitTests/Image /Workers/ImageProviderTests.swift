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
@testable import CV_UIKit

class ImageProviderTests: QuickSpec {
    override func spec() {
        describe("ImageProviderTests when loading image") {
            context("for invalid url") {
                it("calls completion with downloading error") {
                    let url = URL.stub
                    let tested = ImageProvider()
                    let completionSpy: Spy<Result<ImagePath, Error>> = .init()
                    
                    tested.imagePath(for: url) { result in
                        completionSpy.register(with: result)
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).toEventually(throwError(ImageProvider.Error.downloadingError(nil)))
                }
            }
            
            context("for image url") {
                let url = Image.whitePixel.url
                let fileManager = FileManager.default

                var storagePath: String!
                var imagePath: ImagePath!
                var tested: ImageProvider!
                var completionSpy: Spy<Result<ImagePath, Error>>!

                beforeEach {
                    storagePath = NSTemporaryDirectory() + UUID().uuidString + "/"
                    try! fileManager.createDirectory(atPath: storagePath, withIntermediateDirectories: true, attributes: nil) // swiftlint:disable:this force_try
                    imagePath = storagePath + url.lastPathComponent
                    tested = ImageProvider(storagePath: storagePath)
                    completionSpy = .init()
                }
                
                afterEach {
                    try! fileManager.removeItem(atPath: storagePath) // swiftlint:disable:this force_try
                }
                
                it("downloads the image") {
                    tested.imagePath(for: url) { result in
                        completionSpy.register(with: result)
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).toNot(throwError())
                    expect(try completionSpy.invokedParameters?.get()) == imagePath
                }
                
                it("returns the cached image") {                    
                    tested.imagePath(for: url) { _ in }

                    tested.imagePath(for: url) { _ in
                        tested.imagePath(for: url) { result in
                            completionSpy.register(with: result)
                        }
                    }
                    
                    expect(completionSpy.wasInvoked).toEventually(beTrue())
                    expect(try completionSpy.invokedParameters?.get()).toNot(throwError())
                    expect(try completionSpy.invokedParameters?.get()) == imagePath
                }
            }
        }
    }
}
