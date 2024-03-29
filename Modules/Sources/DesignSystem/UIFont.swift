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
    
import UIKit

public extension UIFont {
    static var header: UIFont { UIFont(name: "BebasNeue", size: 40)! }
    static var header1: UIFont { UIFont(name: "BebasNeue", size: 28)! }
    static var header2: UIFont { UIFont(name: "BebasNeue-Bold", size: 18)! }
    static var header3: UIFont { UIFont(name: "BebasNeue", size: 16)! }
    static var paragraph: UIFont { UIFont(name: "OpenSans", size: 12)! }
    static var paragraph1: UIFont { UIFont(name: "OpenSans", size: 14)! }
}

public extension UIFont {
    static func registerFonts() {
        ["BebasNeue-Bold", "BebasNeue-Regular", "OpenSans-Regular"]
            .compactMap { fontName in
                guard
                    let url = Bundle.module.url(forResource: fontName, withExtension: "ttf"),
                    let dataProvider = CGDataProvider(url: url as CFURL) else { return nil }
                return CGFont(dataProvider)
            }
            .forEach { font in
                CTFontManagerRegisterGraphicsFont(font, nil)
            }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
public extension View {
    func previewWithCustomFonts() -> some View {
        UIFont.registerFonts()
        return self
    }
}
#endif
