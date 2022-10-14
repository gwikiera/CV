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

    func testErrorView() {
        let errorView = ErrorView_Previews.previews

        assertSnapshots(matching: errorView, as: testStrategies())
    }

    // MARK: - Helpers
    private func testStrategies<V>() -> [String: Snapshotting<V, UIImage>] where V: View {
        return [
            "light": .image(layout: .device(config: .iPhoneXsMax), traits: .init(userInterfaceStyle: .light)),
            "dark": .image(layout: .device(config: .iPhoneXsMax), traits: .init(userInterfaceStyle: .dark))
        ]
    }
}
