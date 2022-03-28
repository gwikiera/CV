import Combine
import CombineSchedulers
import Networking

final class CLEViewModel<ContentViewState: Equatable> {
    typealias ViewState = CLEViewState<ContentViewState>
    
    private let contentViewStatePublisher: AnyPublisher<ContentViewState, Error>
    private let scheduler: AnySchedulerOf<DispatchQueue>

    private let viewStateSubject = PassthroughSubject<ViewState, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(
        contentViewStatePublisher: AnyPublisher<ContentViewState, Error>,
        scheduler: AnySchedulerOf<DispatchQueue>
    ) {
        self.contentViewStatePublisher = contentViewStatePublisher
        self.scheduler = scheduler
    }

    var viewStatePublisher: AnyPublisher<ViewState, Never> {
        viewStateSubject
            .eraseToAnyPublisher()
    }

    func fetchData() {
        contentViewStatePublisher
            .handleEvents(receiveSubscription: { [viewStateSubject] _ in
                viewStateSubject.send(.loading)
            })
            .map(CLEViewState.content)
            .replaceError(with: .error)
            .first()
            .receive(on: scheduler)
            .sink { [viewStateSubject] viewState in
                viewStateSubject.send(viewState)
            }
            .store(in: &cancellables)
    }
}
