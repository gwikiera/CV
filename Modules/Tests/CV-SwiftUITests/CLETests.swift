import XCTest
import ComposableArchitecture
@testable import CV_SwiftUI
@testable import Networking
@testable import Data
@testable import TestHelpers
@testable import TCADependencyKeys

@MainActor
class CLETests: XCTestCase {
    typealias CLEString = CLE<String>
    static let value = ""
    static let error = ErrorStub()

    func testSuccess() async {
        let store = TestStore(
            initialState: CLEString.State.loading,
            reducer: CLEString(contentProvider: stubReturn(with: CLETests.value))
        )

        await store.send(.fetchContent)

        await store.receive(.fetchContentResult(.success(CLETests.value))) {
            $0 = .content(CLETests.value)
        }
    }

    func testError() async {
        let store = TestStore(
            initialState: CLEString.State.loading,
            reducer: CLEString(contentProvider: { throw CLETests.error })
        )

        await store.send(.fetchContent)

        await store.receive(.fetchContentResult(.failure(CLETests.error))) {
            $0 = .error
        }
    }

    func testReload() async {
        var firstCall = false
        let store = TestStore(
            initialState: CLEString.State.loading,
            reducer: CLEString(contentProvider: {
                guard firstCall else {
                    firstCall.toggle()
                    throw CLETests.error
                }
                return CLETests.value
            })
        )

        await store.send(.fetchContent)

        await store.receive(.fetchContentResult(.failure(CLETests.error))) {
            $0 = .error
        }

        await store.send(.fetchContent) {
            $0 = .loading
        }

        await store.receive(.fetchContentResult(.success(CLETests.value))) {
            $0 = .content(CLETests.value)
        }
    }
}
