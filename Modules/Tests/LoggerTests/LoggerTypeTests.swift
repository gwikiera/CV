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
@testable import Logger

class LoggerTypeTests: XCTestCase {
    func testTrace() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.trace = { parameters = $0 }

        // When
        sut.trace("trace")

        // Then
        expect(parameters) == ("trace", #file, #function, #line - 3)
    }

    func testDebug() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.debug = { parameters = $0 }

        // When
        sut.debug("debug")

        // Then
        expect(parameters) == ("debug", #file, #function, #line - 3)
    }

    func testInfo() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.info = { parameters = $0 }

        // When
        sut.info("info")

        // Then
        expect(parameters) == ("info", #file, #function, #line - 3)
    }

    func testNotice() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.notice = { parameters = $0 }

        // When
        sut.notice("notice")

        // Then
        expect(parameters) == ("notice", #file, #function, #line - 3)
    }

    func testWarning() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.debug = { parameters = $0 }

        // When
        sut.debug("warning")

        // Then
        expect(parameters) == ("warning", #file, #function, #line - 3)
    }

    func testError() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.debug = { parameters = $0 }

        // When
        sut.debug("error")

        // Then
        expect(parameters) == ("error", #file, #function, #line - 3)
    }

    func testCritical() {
        // Given
        var sut = LoggerType.noop
        var parameters: LoggerType.Parameters?
        sut.critical = { parameters = $0 }

        // When
        sut.critical("critical")

        // Then
        expect(parameters) == ("critical", #file, #function, #line - 3)
    }
}
