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
import Nimble
import Combine
import TestHelpers
import XCTest
@testable import Networking
@testable import Data
@testable import CV

class CollectionViewModelTests: XCTestCase {
    var sut: CollectionViewModel!
    var apiClient: APIClient!

    func testViewStatePublisher_FailingApiClient() {
        testViewStatePublisher(
            apiClient: .failing,
            expectedViewState: nil
        )
    }

    func testViewStatePublisher_FirstDataTaskFinished() {
        testViewStatePublisher(
            model: .stub(),
            expectedViewState: .stub(imageItems: [.url(.none)])
        )
    }

    func testViewStatePublisher_FirstImageTaskFinished() {
        testViewStatePublisher(
            model: .stub(),
            expectedViewState: .stub(imageItems: [.url(.none)])
        )
    }

    func testViewStatePublisher_EmptyModel() {
        testViewStatePublisher(
            model: .stub(),
            imageResult: .success(.stub),
            expectedViewState: .stub(imageItems: [.url(.stub)])
        )
    }

    func testViewStatePublisher_FullModel() {
        let model = Model.stub(
            fullname: "Full Name",
            introduction: "introduction",
            contactItems: [.init(name: "name", value: "value")],
            careerHistory: [.init(title: "title", items: [.init(title: "title", subtitle: "subtitle", description: "description")])],
            additionalInfo: [.init(title: "title", content: "content")]
        )
        let expectedViewState = CollectionViewState.stub(
            imageItems: [.url(.stub)],
            personalItems: [.fullname("Full Name"), .contact(type: "name", value: "value")],
            aboutItems: [.text("introduction")],
            careerItems: [.title("title"), .item(title: "title", subtitle: "subtitle", text: "description")],
            moreItems: [.item(title: "title", content: "content")]
        )

        testViewStatePublisher(
            model: model,
            imageResult: .success(.stub),
            expectedViewState: expectedViewState
        )
    }

    // MARK: -
    private func testViewStatePublisher(
        apiClient client: APIClient = .noop,
        model: Model? = nil,
        imageResult: Result<URL, Error>? = nil,
        expectedViewState: CollectionViewState? = nil,
        file: FileString = #file,
        line: UInt = #line
    ) {
        // Given
        var apiClient = client
        if let model = model {
            apiClient.overrideDataTask(endpoint: .data, with: model)

        }
        if let imageResult = imageResult {
            apiClient.overrideDownloadTask(endpoint: .image, withResult: imageResult)
        }
        sut = CollectionViewModel(client: apiClient)

        // When
        let observer = sut.viewStatePublisher.testObserver()
        sut.viewLoaded()

        // Then
        if let expectedViewState = expectedViewState {
            observer.assertLastValue(expectedViewState, file: file, line: line)
        } else {
            observer.assertNil(file: file, line: line)
        }
    }
}
