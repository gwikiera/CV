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

class ContactCollectionViewCell: UICollectionViewCell {
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        DispatchQueue.main.async {
            textView.dataDetectorTypes = [.link, .phoneNumber]
        }
        textView.isEditable = false
        textView.textColor = UIColor.Text.secondary
        textView.font = .paragraph
        textView.backgroundColor = .clear
        contentView.center(view: textView)
        contentView.heightAnchor.constraint(equalTo: textView.heightAnchor, multiplier: 1).isActive = true
        return textView
    }()
    
    func set(type: String, value: String) {
        textView.text = "\(type): \(value)"
    }
}

#if DEBUG
import SwiftUI

struct ContactCellViewRepresentable: UIViewRepresentable {
    let type: String
    let value: String
    
    func makeUIView(context: Context) -> UIView {
        let cell = ContactCollectionViewCell()
        cell.set(type: type, value: value)
        return cell
    }
    
    func updateUIView(_ view: UIView, context: Context) {}
}

struct ContactCellViewRepresentable_Preview: PreviewProvider { //swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            ContactCellViewRepresentable(type: "Test", value: "http://www.google.com")
                .previewLayout(.fixed(width: 320, height: 100))
        }
    }
}
#endif
