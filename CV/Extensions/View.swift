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
    
#if DEBUG
import SwiftUI

extension View {
    func previewCell(width: CGFloat = 320, height: CGFloat = 80) -> some View {
        previewLayout(.fixed(width: width, height: height))
    }
    
    func previewColorSchemes() -> some View {
        ForEach(ColorScheme.allCases, id: \.self, content: preferredColorScheme)
    }
    
    func previewForDevices() -> some View {
        let devices: [PreviewDevice] = ["iPhone SE (2nd generation)", "iPhone 11 Pro Max", "iPad Pro (12.9-inch) (4th generation)"]
        return ForEach(devices, id: \.rawValue, content: previewDevice)
    }
}
#endif
