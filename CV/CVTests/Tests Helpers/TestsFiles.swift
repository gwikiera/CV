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

class TestFile {
    let url: URL
    var data: Data {
        try! Data(contentsOf: url)
    }

    init(url: URL) {
        self.url = url
    }
    
    convenience init(resource: String?, ofType type: String?, bundle: Bundle = .testsBundle) {
        let path = bundle.path(forResource: resource, ofType: type)!
        self.init(url: URL(fileURLWithPath: path))
    }
}

class JSON: TestFile {
    static let empty = JSON(resource: "empty")

    convenience init(resource: String?, bundle: Bundle = .testsBundle) {
        self.init(resource: resource, ofType: "json", bundle: bundle)
    }
}

class Image: TestFile {
    static let whitePixel = Image(resource: "whitePixel")

    var image: UIImage {
        UIImage(data: data)!
    }
    
    convenience init(resource: String?, bundle: Bundle = .testsBundle) {
        self.init(resource: resource, ofType: "png", bundle: bundle)
    }
}

extension Bundle {
    static var testsBundle: Bundle {
        return Bundle(for: TestFile.self)
    }
}
