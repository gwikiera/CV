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

class CareerHeaderCollectionViewCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .header1
        center(view: label)
        heightAnchor.constraint(equalTo: label.heightAnchor, constant: 20).isActive = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .tertiarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String) {
        label.text = text
    }
}

#if DEBUG
import SwiftUI

struct CareerHeaderCollectionViewCell_Preview: PreviewProvider { // swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            GenericViewRepresentable(initializer: CareerHeaderCollectionViewCell.init,
                                     cofigurator: { $0.set(text: "text") })
                .previewCell()
                .previewColorSchemes()
        }
    }
}
#endif
