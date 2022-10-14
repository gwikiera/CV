import Combine
import ComposableArchitecture
import SwiftUI

public struct CLEView<Content: Equatable, ContentView: View>: View {
    let store: StoreOf<CLE<Content>>
    let viewProvider: (Content) -> ContentView

    init(
        store: StoreOf<CLE<Content>>,
        @ViewBuilder viewProvider: @escaping (Content) -> ContentView
    ) {
        self.store = store
        self.viewProvider = viewProvider
    }

    public var body: some View {
        WithViewStore(self.store) { viewState in
            Group {
                switch viewState.state {
                case .content(let content):
                    viewProvider(content)
                case .loading:
                    ProgressView()
                case .error:
                    ErrorView(store: store.scope(
                        state: { _ in return .init() },
                        action: { _ in return .fetchContent }
                    ))
                }
            }
            .onAppear {
                viewState.send(.fetchContent)
            }
        }
    }
}
