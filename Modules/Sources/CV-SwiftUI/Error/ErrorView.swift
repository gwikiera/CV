import SwiftUI
import Translations
import ComposableArchitecture

struct ErrorView: View {
    struct State: Equatable {}
    struct Action: Equatable {}

    let store: Store<State, Action>

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "xmark.octagon.fill")
                .imageScale(.large)
                .foregroundColor(.white)
            WithViewStore(store) { viewStore in
                Button(
                    action: { viewStore.send(.init()) },
                    label: {
                        Text(verbatim: .Localized.tryAgain)
                            .foregroundColor(.white)
                    }
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .ignoresSafeArea()
        .background(Color.black)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(store: .init(initialState: .init(), reducer: EmptyReducer()))
    }
}
