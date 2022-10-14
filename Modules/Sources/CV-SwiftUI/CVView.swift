import SwiftUI
import Combine
import ComposableArchitecture

public struct CVView: View {
    let store: StoreOf<CV>

    init(store: StoreOf<CV>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                if case .content = viewStore.state.modelCLE {
                    CLEView(store: store.scope(state: \.imageCLE, action: CV.Action.image)) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                CLEView(store: store.scope(state: \.modelCLE, action: CV.Action.model)) { model in
                    Text(model.fullname)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

public extension CVView {
    init() {
        self.init(store: .init(initialState: .init(imageCLE: .loading, modelCLE: .loading), reducer: CV()))
    }
}

struct CVView_Previews: PreviewProvider {
    static var previews: some View {
        loading
        error
    }

    static var loading: some View {
        CVView(state: .init(imageCLE: .loading, modelCLE: .loading))
            .previewDisplayName("Loading")
    }

    static var error: some View {
        CVView(state: .init(imageCLE: .error, modelCLE: .error))
            .previewDisplayName("Error")
    }
}

private extension CVView {
    init(state: CV.State) {
        self.init(store: .init(initialState: state, reducer: EmptyReducer()))
    }
}
