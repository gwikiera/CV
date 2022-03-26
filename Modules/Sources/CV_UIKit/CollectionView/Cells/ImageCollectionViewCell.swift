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
import UIKitHelpers
import Networking

class ImageCollectionViewCell: UICollectionViewCell {
    var interactor: ImageBusinessLogic?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.Image.background
        contentView.embed(view: imageView)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = tintColor
        contentView.center(view: activityIndicator)
        return activityIndicator
    }()
    
    private var errorImage: UIImage? {
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let errorImage = UIImage(systemName: "xmark.octagon.fill", withConfiguration: largeConfiguration)
        return errorImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = UIColor.Image.tint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else { return }
        
        interactor?.loadImage()
    }
}

extension ImageCollectionViewCell: ImageViewLogic {
    func displayLoading() {
        activityIndicator.startAnimating()
    }
    
    func displayImage(at imagePath: ImagePath) {
        activityIndicator.stopAnimating()
        imageView.image = UIImage(contentsOfFile: imagePath)
        imageView.contentMode = .scaleAspectFit
    }
    
    func displayErrorMessage(_ message: String) {
        activityIndicator.stopAnimating()
        imageView.image = errorImage
        imageView.contentMode = .center
    }
}

#if DEBUG
import SwiftUI

struct ImageCollectionViewCellConfigurator {
    enum Mode: CaseIterable {
        case loading, error, image
    }
    
    let mode: Mode

    func configure(_ cell: ImageCollectionViewCell) {
        switch mode {
        case .loading:
            cell.displayLoading()
        case .error:
            cell.displayErrorMessage("error message")
        case .image:
            cell.displayImage(at: Bundle.main.path(forResource: "Profile", ofType: "jpeg")!)
        }
    }
}

struct ImageCollectionViewCell_Preview: PreviewProvider { // swiftlint:disable:this type_name
    static var previews: some View {
        Group {
            ForEach(ImageCollectionViewCellConfigurator.Mode.allCases, id: \.self) { mode in
                GenericViewRepresentable(
                    initializer: ImageCollectionViewCell.init,
                    configurator: ImageCollectionViewCellConfigurator(mode: mode).configure
                )
                    .previewCell()
                    .previewColorSchemes()
            }
        }
    }
}
#endif
