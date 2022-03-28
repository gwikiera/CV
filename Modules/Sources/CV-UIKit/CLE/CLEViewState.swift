import Foundation

enum CLEViewState<ContentViewState: Equatable>: Equatable {
    case content(ContentViewState)
    case loading
    case error
}
