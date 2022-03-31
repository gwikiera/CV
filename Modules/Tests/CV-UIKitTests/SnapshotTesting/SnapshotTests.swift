import Foundation
import XCTest
import SnapshotTesting
import TestHelpers
import Combine
import UIKit

@testable import Networking
@testable import CV_UIKit

class SnapshotTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

        UIFont.registerFonts()
        mainScheduler = .immediate
//        isRecording = true
    }

    func testLoadingViewController() {
        let viewControllerFactory = UIViewControllerFactory(apiClient: .noop, imageProvider: .noop)

        let sut = viewControllerFactory.loadingViewController()

        assertSnapshots(matching: sut, as: .testStrategies)
    }

    func testErrorViewController() {
        let viewControllerFactory = UIViewControllerFactory(apiClient: .noop, imageProvider: .noop)

        let sut = viewControllerFactory.errorViewController(refreshAction: {})

        assertSnapshots(matching: sut, as: .testStrategies)
    }

    func testCollectionViewController_imageLoading() {
        testCollectionViewController()
    }

    func testCollectionViewController_imageLoadingFailed() {
        var imageProvider = ImageProvider.noop
        imageProvider.imagePathPublisher = stubReturn(with: .stubFailure(ErrorStub()))

        testCollectionViewController(imageProvider: imageProvider)
    }

    func testCollectionViewController_imageLoadingSucceeded() {
        var imageProvider = ImageProvider.noop
        imageProvider.imagePathPublisher = stubReturn(with: .stubOutput(Image.whitePixel.url.path))

        testCollectionViewController(imageProvider: imageProvider)
    }

    // MARK: -
    func testCollectionViewController(
        imageProvider: ImageProvider = .noop,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let viewControllerFactory = UIViewControllerFactory(apiClient: .noop, imageProvider: imageProvider)
        let sut = viewControllerFactory.collectionViewController(.mock)

        assertSnapshots(
            matching: sut,
            as: .testStrategies,
            file: file,
            testName: testName,
            line: line
        )
    }
}

private extension Dictionary where Key == String, Value == Snapshotting<UIViewController, UIImage> {
    static let testStrategies: Self = [
        "light": .image(on: .iPhoneXsMax, traits: .init(userInterfaceStyle: .light)),
        "dark": .image(on: .iPhoneXsMax, traits: .init(userInterfaceStyle: .dark))
    ]
}
