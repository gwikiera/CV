import Foundation
import ComposableArchitecture
import Combine
import Networking
import TCADependencyKeys
import Data

struct CV: ReducerProtocol {
    public enum State: Equatable {
        case content(String)
        case loading
        case error
    }

    public enum Action {
        case fetchData
        case fetchDataFailed
        case fetchModelFinished(String)
    }

    @Dependency(\.apiClient) var apiClient
    @Dependency(\.imageProvider) var imageProvider
    @Dependency(\.logger) var logger

    public init() {}
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .fetchData:
            state = .loading
            return apiClient.request(endpoint: .data, as: Model.self)
                .map(\.fullname)
                .map(Action.fetchModelFinished)
                .replaceError(with: .fetchDataFailed)
                .eraseToEffect()
        case .fetchDataFailed:
            state = .error
            return .none
        case .fetchModelFinished(let model):
            state = .content(model)
            return .none
        }
    }
}
