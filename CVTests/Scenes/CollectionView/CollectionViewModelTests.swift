//
//  CV
//
//  Copyright 2022 - Grzegorz Wikiera - https://github.com/gwikiera
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
import Combine
import Data
import TestHelpers
@testable import Networking
@testable import CV

class CollectionViewModelTests: QuickSpec {
    override func spec() {
        describe("CollectionViewModel") {
            context("when client publish value") {
                let viewModel = ViewModel.stub()
                let data = (try? JSONEncoder().encode(viewModel)) ?? Data()
                let apiClient = APIClient(
                    baseURL: { .stub },
                    dataTask: stubReturn(with: .stubOutput(data)),
                    downloadTask: stubReturn(with: .stubOutput(.stub))
                )
                let sut = CollectionViewModel(client: apiClient)

                it("pass it forward") {

                    sut.viewModelPublisher.expectFirstValue(viewModel)
                }
            }

            context("when client fails") {
                let apiClient = APIClient(
                    baseURL: { .stub },
                    dataTask: stubReturn(with: .stubFailure(ErrorStub())),
                    downloadTask: stubReturn(with: .stubFailure(ErrorStub()))
                )

                let sut = CollectionViewModel(client: apiClient)

                it("does nothing") {
                    sut.viewModelPublisher.expectNoValues()
                }
            }
        }
    }
}
