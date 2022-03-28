import UIKit
import Networking
import Translations

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

    func errorViewController(refreshAction: @escaping () -> Void) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let errorImage = UIImage(systemName: "xmark.octagon.fill", withConfiguration: largeConfiguration)
        let imageView = UIImageView(image: errorImage)
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.tintColor = .white
        let refreshButton = UIButton(type: .roundedRect, primaryAction: .init(handler: { _ in refreshAction() }))
        refreshButton.setTitle(.Localized.tryAgain, for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.titleLabel?.textColor = .white
        let stackView = UIStackView(arrangedSubviews: [imageView, refreshButton])
        stackView.axis = .vertical
        viewController.view.center(view: stackView)
        return viewController
    }

    func loadingViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        viewController.view.center(view: activityIndicator)
        return viewController
    }
}
