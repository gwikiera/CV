//
//  CV
//
//  Copyright 2022 - Grzegorz Wikiera - https://github.com/gwikiera
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

public struct LoggerType {
    public typealias Parameters = (message: String, file: String, function: String, line: UInt)
    var trace: (Parameters) -> Void
    var debug: (Parameters) -> Void
    var info: (Parameters) -> Void
    var notice: (Parameters) -> Void
    var warning: (Parameters) -> Void
    var error: (Parameters) -> Void
    var critical: (Parameters) -> Void

    public init(
        trace: @escaping (LoggerType.Parameters) -> Void,
        debug: @escaping (LoggerType.Parameters) -> Void,
        info: @escaping (LoggerType.Parameters) -> Void,
        notice: @escaping (LoggerType.Parameters) -> Void,
        warning: @escaping (LoggerType.Parameters) -> Void,
        error: @escaping (LoggerType.Parameters) -> Void,
        critical: @escaping (LoggerType.Parameters) -> Void
    ) {
        self.trace = trace
        self.debug = debug
        self.info = info
        self.notice = notice
        self.warning = warning
        self.error = error
        self.critical = critical
    }
}

public extension LoggerType {
    func trace(_ message: @autoclosure () -> String,
               file: String = #file, function: String = #function, line: UInt = #line) {
        self.trace((message(), file, function, line))
    }
    func debug(_ message: @autoclosure () -> String,
               file: String = #file, function: String = #function, line: UInt = #line) {
        self.debug((message(), file, function, line))
    }
    func info(_ message: @autoclosure () -> String,
              file: String = #file, function: String = #function, line: UInt = #line) {
        self.info((message(), file, function, line))
    }
    func notice(_ message: @autoclosure () -> String,
                file: String = #file, function: String = #function, line: UInt = #line) {
        self.notice((message(), file, function, line))
    }
    func warning(_ message: @autoclosure () -> String,
                 file: String = #file, function: String = #function, line: UInt = #line) {
        self.warning((message(), file, function, line))
    }
    func error(_ message: @autoclosure () -> String,
               file: String = #file, function: String = #function, line: UInt = #line) {
        self.error((message(), file, function, line))
    }
    func critical(_ message: @autoclosure () -> String,
                  file: String = #file, function: String = #function, line: UInt = #line) {
        self.critical((message(), file, function, line))
    }
}

public var logger: LoggerType = .noop

extension LoggerType {
    static let noop = LoggerType(
        trace: { _ in },
        debug: { _ in },
        info: { _ in },
        notice: { _ in },
        warning: { _ in },
        error: { _ in },
        critical: { _ in }
    )
}
