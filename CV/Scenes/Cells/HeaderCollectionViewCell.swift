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

class HeaderCollectionViewCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .header
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor.Text.underline
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(underlineView)
        contentView.center(view: label)

        underlineView.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 1, constant: 20).isActive = true
        underlineView.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 0.4, constant: 0).isActive = true
        underlineView.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        underlineView.topAnchor.constraint(equalTo: label.lastBaselineAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}

#if DEBUG
import SwiftUI

struct HeaderCellViewRepresentable: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> UIView {
        let cell = HeaderCollectionViewCell()
        cell.setText(text)
        return cell
    }
    
    func updateUIView(_ view: UIView, context: Context) {}
}

struct HeaderCellViewRepresentable_Preview: PreviewProvider { //swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            HeaderCellViewRepresentable(text: "Test")
                .previewLayout(.fixed(width: 320, height: 100))
        }
    }
}
#endif
