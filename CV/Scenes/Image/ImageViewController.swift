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

protocol ImageViewLogic: AnyObject {
    func displayLoading()
    func displayImage(at imagePath: ImagePath)
    func displayErrorMessage(_ message: String)
}

final class ImageViewController: UIViewController {
    let interactor: ImageBusinessLogic
    
    private var imageView: UIImageView {
        view as! UIImageView // swiftlint:disable:this force_cast
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = view.tintColor
        view.center(view: activityIndicator)
        return activityIndicator
    }()
    
    private var errorImage: UIImage? {
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let errorImage = UIImage(systemName: "xmark.octagon.fill", withConfiguration: largeConfiguration)
        return errorImage
    }

    init(interactor: ImageBusinessLogic) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIImageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Image.background
        view.tintColor = UIColor.Image.tint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor.loadImage()
    }
}

extension ImageViewController: ImageViewLogic {
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

struct ImageInteractorDummy: ImageBusinessLogic {
    func loadImage() {}
}

struct ImageViewRepresentable: UIViewRepresentable {
    enum Mode: CaseIterable {
        case loading, error, image
    }
    
    let mode: Mode
    
    func makeUIView(context: Context) -> UIView {
        let viewController = ImageViewController(interactor: ImageInteractorDummy())
        switch mode {
        case .loading:
            viewController.displayLoading()
        case .error:
            viewController.displayErrorMessage("error message")
        case .image:
            viewController.displayImage(at: Bundle.main.path(forResource: "Profile", ofType: "jpeg")!)
        }
        return viewController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ImageViewRepresentable_Preview: PreviewProvider { // swiftlint:disable:this type_name
    static var devices = ["iPhone SE", "iPhone XS Max", "iPad Pro (11-inch)"]

    static var previews: some View {
        Group {
            ForEach(devices, id: \.self) { name in
                ForEach(ImageViewRepresentable.Mode.allCases, id: \.self) { mode in
                    ImageViewRepresentable(mode: mode)
                        .previewDevice(PreviewDevice(rawValue: name))
                        .previewDisplayName(name)
                }
            }
        }
    }
}
#endif
