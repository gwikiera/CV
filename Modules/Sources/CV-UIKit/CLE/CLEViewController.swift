import UIKit
import Combine

final class CLEViewController<ContentViewState: Equatable>: UIViewController {
    private let viewModel: CLEViewModel<ContentViewState>
    private let contentViewControllerBuilder: (ContentViewState) -> UIViewController
    private let errorViewControllerBuilder: (@escaping () -> Void) -> UIViewController
    private let loadingViewControllerBuilder: () -> UIViewController
    private var cancellables = Set<AnyCancellable>()

    init(
        viewModel: CLEViewModel<ContentViewState>,
        contentViewControllerBuilder: @escaping (ContentViewState) -> UIViewController,
        errorViewControllerBuilder: @escaping (@escaping () -> Void) -> UIViewController,
        loadingViewControllerBuilder: @escaping () -> UIViewController
    ) {
        self.viewModel = viewModel
        self.contentViewControllerBuilder = contentViewControllerBuilder
        self.errorViewControllerBuilder = errorViewControllerBuilder
        self.loadingViewControllerBuilder = loadingViewControllerBuilder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        viewModel.viewStatePublisher
            .map { [unowned self] state -> UIViewController in
                switch state {
                case let .content(contentViewState):
                    return self.contentViewControllerBuilder(contentViewState)
                case .loading:
                    return self.loadingViewControllerBuilder()
                case .error:
                    return self.errorViewControllerBuilder(self.viewModel.fetchData)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewController in
                self?.children.forEach { $0.detach() }
                self?.embed(viewController: viewController)
                self?.setNeedsStatusBarAppearanceUpdate()
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        children.first?.preferredStatusBarStyle ?? .default
    }
}
