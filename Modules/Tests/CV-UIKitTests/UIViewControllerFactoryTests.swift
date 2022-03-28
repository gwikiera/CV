import XCTest
import Nimble

@testable import CV_UIKit

class UIViewControllerFactoryTests: XCTestCase {
    let sut = UIViewControllerFactory(apiClient: .noop, imageProvider: .noop)

    func testInitialViewController() {
        expect(self.sut.initialViewController()).to(beAnInstanceOf(CLEViewController<CollectionViewState>.self))
    }

    func testCollectionViewController() {
        expect(self.sut.collectionViewController(.stub())).to(beAnInstanceOf(CollectionViewController.self))
    }

    func testLoadingViewController() {
        expect(self.sut.loadingViewController()).to(beAnInstanceOf(UIViewController.self))
    }

    func testErrorViewController() {
        expect(self.sut.errorViewController(refreshAction: {})).to(beAnInstanceOf(UIViewController.self))
    }
}
