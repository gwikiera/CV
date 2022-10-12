import Networking
import NetworkingLive
import ComposableArchitecture

private enum ImageProviderKey: DependencyKey {
    static let liveValue = ImageProvider.live
}

public extension DependencyValues {
    var imageProvider: ImageProvider {
        get { self[ImageProviderKey.self] }
        set { self[ImageProviderKey.self] = newValue }
    }
}

