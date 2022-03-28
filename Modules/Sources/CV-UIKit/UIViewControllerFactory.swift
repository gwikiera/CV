import UIKit
import Networking

public final class UIViewControllerFactory {
    private let apiClient: APIClient
    private let imageProvider: ImageProvider

    public init(apiClient: APIClient, imageProvider: ImageProvider) {
        self.apiClient = apiClient
        self.imageProvider = imageProvider
    }

    public func initialViewController() -> UIViewController {
        cleViewController()
    }
}

extension UIViewControllerFactory {
    func cleViewController() -> UIViewController {
        let viewModel = CLEViewModel<CollectionViewState>(client: apiClient)
        return CLEViewController<CollectionViewState>(
            viewModel: viewModel,
            contentViewControllerBuilder: self.collectionViewController,
            errorViewControllerBuilder: self.errorViewController,
            loadingViewControllerBuilder: self.loadingViewController
        )
    }

    func collectionViewController(_ collectionViewState: CollectionViewState) -> UIViewController {
        return CollectionViewController(viewState: collectionViewState, imageProvider: imageProvider)
    }

    func errorViewController(refreshAction: () -> Void) -> UIViewController {
        // TODO: Provide error view
        return .init()
    }

    func loadingViewController() -> UIViewController {
        // TODO: Provide loading view
        return .init()
    }
}
