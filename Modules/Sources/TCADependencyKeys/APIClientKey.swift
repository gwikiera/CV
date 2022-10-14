import Networking
import NetworkingLive
import ComposableArchitecture

private enum APIClientKey: DependencyKey {
    static let liveValue = APIClient.live
    static let testValue = APIClient.unimplemented
    static let previewValue = APIClient.mock
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
