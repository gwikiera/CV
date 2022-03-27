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

import Foundation
import Logging
import Networking
import NetworkingLive
import Logger
import LoggerLive

struct AppEnvironment {
    var apiClient: APIClient
    var imageProvider: ImageProvider
    var logger: LoggerType
}

extension AppEnvironment {
    static var current: AppEnvironment!
}

extension AppEnvironment {
    static let live = AppEnvironment(
        apiClient: .live,
        imageProvider: .live,
        logger: .live
    )

    #if DEBUG
    static let mock = AppEnvironment(
        apiClient: .mock,
        imageProvider: .mock,
        logger: .mock
    )
    #endif
}

func setupAppEnvironment() {
#if DEBUG
    let isMockBuild = ProcessInfo.processInfo.arguments.contains("-Mock")
    AppEnvironment.current = isMockBuild ? .mock : .live
#else
    AppEnvironment.current = .live
#endif

    logger = AppEnvironment.current.logger
}
