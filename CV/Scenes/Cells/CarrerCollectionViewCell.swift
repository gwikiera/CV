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

class CareerCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .header2
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .header3
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.font = .paragraph1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                     stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                                     stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                                     stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)])
        contentView.backgroundColor = .tertiarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, subtitle: String, description: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        descriptionLabel.text = description
    }
}

#if DEBUG
import SwiftUI

struct CareerCollectionViewCell_Preview: PreviewProvider { //swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            GenericViewRepresentable(initializer: CareerCollectionViewCell.init,
                                     cofigurator: { $0.set(title: "title", subtitle: "subtitle", description: "description") })
                .previewCell(height: 120)
                .previewColorSchemes()
        }
    }
}
#endif
