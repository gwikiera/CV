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
        view as! UIImageView
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = view.tintColor
        view.center(view: activityIndicator)
        return activityIndicator
    }()
    
    private lazy var errorImage: UIImage? = {
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let errorImage = UIImage(systemName: "xmark.octagon.fill", withConfiguration: largeConfiguration)
        return errorImage
    }()
    
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
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
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
