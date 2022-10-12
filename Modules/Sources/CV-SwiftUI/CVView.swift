import SwiftUI
import Combine
import ComposableArchitecture

public struct CVView: View {
    let store: StoreOf<CV>

    init(store: StoreOf<CV>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store) { viewState in
            Group {
                switch viewState.state {
                case .loading:
                    ProgressView()
                case .error:
                    Text("Something went wrong :(")
                case .content(let string):
                    Text(string)
                }
            }
            .onAppear {
                viewState.send(.fetchData)
            }
        }
    }
}

extension CVView {
    init(state: CV.State) {
        self.init(store: .init(initialState: state, reducer: CV()))
    }

    public init() {
        self.init(state: .loading)
    }
}

struct CLEView_Previews: PreviewProvider {
    static var previews: some View {
        CVView(state: .loading)
        CVView(state: .error)
        CVView(state: .content("Hello world!"))
    }
}
