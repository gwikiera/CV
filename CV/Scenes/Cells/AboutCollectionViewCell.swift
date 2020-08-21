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

class AboutCollectionViewCell: UICollectionViewCell {
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .header1
        label.textColor = UIColor.Text.secondary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .paragraph1
        label.textAlignment = .justified
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [headerLabel, textLabel])
        stackView.spacing = 15
        stackView.axis = .vertical
    
        contentView.embed(view: stackView, offset: 20)
        
        contentView.backgroundColor = UIColor.Image.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderText(_ text: String) {
        headerLabel.text = text
    }
    
    func setText(_ text: String) {
        textLabel.text = text
    }
}

#if DEBUG
import SwiftUI

struct AboutCellViewRepresentable: UIViewRepresentable {
    let headerText, text: String
    
    func makeUIView(context: Context) -> UIView {
        let cell = AboutCollectionViewCell()
        cell.setHeaderText(headerText)
        cell.setText(text)
        return cell
    }
    
    func updateUIView(_ view: UIView, context: Context) {}
}

struct AboutCellViewRepresentable_Preview: PreviewProvider { //swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            AboutCellViewRepresentable(headerText: "ABOUT ME", text: String.loremIpsum)
                .previewLayout(.fixed(width: 320, height: .infinity))
        }
    }
}
#endif
