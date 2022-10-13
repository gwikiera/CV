import Foundation
import ComposableArchitecture
import Combine

struct CLE<Content: Equatable>: ReducerProtocol { // swiftlint:disable:this type_name
    public enum State: Equatable {
        case content(Content)
        case loading
        case error
    }

    public enum Action {
        case fetchContent
        case fetchContentResult(TaskResult<Content>)
    }

    let contentProvider: () async throws -> Content

    public init(
        contentProvider: @escaping () async throws -> Content
    ) {
        self.contentProvider = contentProvider
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .fetchContent:
            state = .loading
            return .task {
                return await .fetchContentResult(TaskResult {
                    try await contentProvider()
                })
            }
        case .fetchContentResult(.failure):
            state = .error
            return .none
        case .fetchContentResult(.success(let content)):
            state = .content(content)
            return .none
        }
    }
}
