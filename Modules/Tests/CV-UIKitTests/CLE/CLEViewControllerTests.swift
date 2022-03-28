import XCTest
import Nimble
import TestHelpers

@testable import CV_UIKit

class CLEViewControllerTests: XCTestCase {
    var viewModel: CLEViewModel<String>!
    var loadingViewControllerBuilderSpy: Spy<Void>!
    var errorViewControllerBuilderSpy: Spy<Void>!
    var contentViewControllerBuilderSpy: Spy<String>!

    lazy var sut: CLEViewController<String>! = CLEViewController<String>(
        viewModel: viewModel,
        contentViewControllerBuilder: { viewModel in
            self.contentViewControllerBuilderSpy.register(with: viewModel)
            return .init()
        },
        errorViewControllerBuilder: { _ in
            self.errorViewControllerBuilderSpy.register()
            return .init()
        },
        loadingViewControllerBuilder: { [self] in
            loadingViewControllerBuilderSpy.register()
            return .init()
        }
    )

    override func setUp() async throws {
        try await super.setUp()
        loadingViewControllerBuilderSpy = .init()
        errorViewControllerBuilderSpy = .init()
        contentViewControllerBuilderSpy  = .init()
    }

    override func tearDown() async throws {
        loadingViewControllerBuilderSpy = nil
        errorViewControllerBuilderSpy = nil
        contentViewControllerBuilderSpy  = nil
        sut = nil
        viewModel = nil
        try await super.tearDown()
    }

    func testLoading() {
        // Given
        viewModel = CLEViewModel<String>(
            contentViewStatePublisher: .noop,
            scheduler: .immediate
        )

        // When
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)

        // Then
        expect(self.loadingViewControllerBuilderSpy.wasInvoked) == true
    }

    func testError() {
        // Given
        viewModel = CLEViewModel<String>(
            contentViewStatePublisher: .stubFailure(ErrorStub()),
            scheduler: .immediate
        )

        // When
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)

        // Then
        expect(self.errorViewControllerBuilderSpy.wasInvoked) == true
    }

    func testContent() {
        // Given
        viewModel = CLEViewModel<String>(
            contentViewStatePublisher: .stubOutput("Test"),
            scheduler: .immediate
        )

        // When
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)

        // Then
        expect(self.contentViewControllerBuilderSpy.wasInvoked(with: "Test")) == true
    }
}
