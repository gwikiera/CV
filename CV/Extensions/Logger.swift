//
//  CV
//
//  Copyright 2020 - Grzegorz Wikiera - https://github.com/gwikiera
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
    
import Logging
import Foundation

var logger: Logger {
    AppEnvironment.current.logger
}

extension Logger {
    static let live = Logger(label: "com.gwikiera.CV")

    static let mock: Logger = {
        var logger = Logger(label: "com.gwikiera.CV.mock")
        logger.logLevel = .trace
        return logger
    }()
}

extension Logger {
    func assert(_ message: @autoclosure () -> Logger.Message,
                metadata: @autoclosure () -> Logger.Metadata? = nil,
                source: @autoclosure () -> String? = nil,
                file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        critical(message(), metadata: metadata(), source: source(), file: "\(file)", function: "\(function)", line: line)
        #if DEBUG
        guard !isRunningUnitTests else { return }
        assertionFailure(message().description, file: file, line: line)
        #endif
    }
}
