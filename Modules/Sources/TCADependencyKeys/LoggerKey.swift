import Logger
import LoggerLive
import ComposableArchitecture

private enum LoggerKey: DependencyKey {
    static let liveValue = LoggerType.live
}

public extension DependencyValues {
    var logger: LoggerType {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }
}
