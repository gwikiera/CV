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

extension UIColor {
    enum Image {
        static var background: UIColor? { return UIColor(named: "ImageBG") }
        static var tint: UIColor? { return UIColor(named: "ImageTint") }
    }
    
    enum Text {
        static var primary: UIColor? { return UIColor(named: "PrimaryTextColor") }
        static var secondary: UIColor? { return UIColor(named: "SecondaryTextColor") }
        static var underline: UIColor? { return UIColor(named: "TextUnderline") }
    }
}
