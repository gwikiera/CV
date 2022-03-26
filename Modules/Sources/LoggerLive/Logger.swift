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

import Logger
import Logging

public extension LoggerType {
    static let live: Self = .init(logger: Logger(label: "com.gwikiera.CV"))
    static let mock: Self = {
        var logger = Logger(label: "com.gwikiera.CV.mock")
        logger.logLevel = .trace
        return .init(logger: logger)
    }()
}

extension LoggerType {
    init(logger: Logger) {
        self.init(
            trace: { message, file, function, line in
                logger.trace(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            debug: { message, file, function, line in
                logger.debug(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            info: { message, file, function, line in
                logger.info(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            notice: { message, file, function, line in
                logger.notice(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            warning: { message, file, function, line in
                logger.warning(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            error: { message, file, function, line in
                logger.error(.init(stringLiteral: message), file: file, function: function, line: line)
            },
            critical: { message, file, function, line in
                logger.critical(.init(stringLiteral: message), file: file, function: function, line: line)
            }
        )
    }
}
