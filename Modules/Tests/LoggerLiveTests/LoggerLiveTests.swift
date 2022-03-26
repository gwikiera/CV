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

import XCTest
import Nimble
import Logging
import Logger
@testable import LoggerLive

class LoggerLiveTests: XCTestCase {
    func testTrace() {
        test(
            method: LoggerType.trace,
            logLevel: .trace
        )
    }

    func testDebug() {
        test(
            method: LoggerType.debug,
            logLevel: .debug
        )
    }

    func testInfo() {
        test(
            method: LoggerType.info,
            logLevel: .info
        )
    }

    func testNotice() {
        test(
            method: LoggerType.notice,
            logLevel: .notice
        )
    }

    func testWarning() {
        test(
            method: LoggerType.warning,
            logLevel: .warning
        )
    }

    func testError() {
        test(
            method: LoggerType.error,
            logLevel: .error
        )
    }

    func testCritical() {
        test(
            method: LoggerType.critical,
            logLevel: .critical
        )
    }

    // MARK: -
    private func test(
        method: (LoggerType) -> (@autoclosure () -> String, String, String, UInt) -> (),
        logLevel: Logger.Level,
        function: String = #function,
        file: FileString = #file,
        line: UInt = #line
    ) {
        let mock = LogHandlerMock()
        mock.logLevel = logLevel
        let logger = Logger(label: function) { _ in mock }
        let sut = LoggerType(logger: logger)
        let message = logLevel.rawValue

        // When
        method(sut)(message, function, file.description, line)

        // Then
        expect(file: file, line: line, mock.logs.last) == (logLevel, message, function, file.description, line)
    }
}
