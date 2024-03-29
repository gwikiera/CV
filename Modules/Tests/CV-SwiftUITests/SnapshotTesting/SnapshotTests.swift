import Foundation
import XCTest
import SnapshotTesting
import TestHelpers
import Combine
import SwiftUI

@testable import CV_SwiftUI

class SnapshotTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

//        isRecording = true
    }

    func testCVView_loading() {
        let loadingView = CVView_Previews.loading

        assertSnapshots(matching: loadingView, as: strategies())
    }

    func testCVView_error() {
        let errorView = CVView_Previews.error

        assertSnapshots(matching: errorView, as: strategies(precision: 0.999))
    }

    func testErrorView() {
        let errorView = ErrorView_Previews.previews

        assertSnapshots(matching: errorView, as: strategies(precision: 0.999))
    }

    // MARK: - Helpers
    private func strategies<V>(precision: Float = 1) -> [String: Snapshotting<V, UIImage>] where V: View {
        return [
            "light": .image(
                precision: precision,
                layout: .device(config: .iPhoneXsMax),
                traits: .init(userInterfaceStyle: .light)
            ),
            "dark": .image(
                precision: precision,
                layout: .device(config: .iPhoneXsMax),
                traits: .init(userInterfaceStyle: .dark)
            )
        ]
    }
}
