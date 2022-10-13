import Foundation
import ComposableArchitecture
import Combine
import Networking
import TCADependencyKeys
import Data
import UIKit

struct CV: ReducerProtocol { // swiftlint:disable:this type_name
    typealias ImageCLE = CLE<UIImage>
    typealias ModelCLE = CLE<Model>

    public struct State: Equatable {
        var imageCLE: ImageCLE.State
        var modelCLE: ModelCLE.State
    }

    public enum Action {
        case image(ImageCLE.Action)
        case model(ModelCLE.Action)
    }

    enum Error: Swift.Error {
        case missingImage
    }

    @Dependency(\.apiClient) var apiClient
    @Dependency(\.imageProvider) var imageProvider
    @Dependency(\.logger) var logger

    public init() {}

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.imageCLE, action: /Action.image) {
            ImageCLE(contentProvider: self.profileImage)
        }

        Scope(state: \.modelCLE, action: /Action.model) {
            ModelCLE(contentProvider: self.model)
        }
    }

    func profileImage() async throws -> UIImage {
        let url = apiClient.url(for: .image)
        guard let image = try await imageProvider.imagePublisher(for: url).async() else {
            throw Error.missingImage
        }
        return image
    }

    func model() async throws -> Model {
        return try await apiClient.request(endpoint: .data, as: Model.self).async()
    }
}
