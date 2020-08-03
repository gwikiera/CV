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
import Logging

class ViewController: UICollectionViewController {
    private var viewModel: ViewModel?
    private var dataSource: UICollectionViewDiffableDataSource<DataSource.Section, AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: "ContactCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        display(viewModel: .example)
    }
    
    func display(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        dataSource = UICollectionViewDiffableDataSource<DataSource.Section, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = DataSource.Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewControllerCell", for: indexPath)
            switch section {
            case .image:
                if let sectionItem = item as? DataSource.ImageSectionItem, case .url(let url) = sectionItem {
                    let imagePresenter = ImagePresenter()
                    let imageProvider = ImageProvider()
                    let imageInteractor = ImageInteractor(presenter: imagePresenter,
                                                          imageUrl: url,
                                                          provider: imageProvider)
                    let imageViewController = ImageViewController(interactor: imageInteractor)
                    imagePresenter.view = imageViewController
                    self.embed(viewController: imageViewController, containerView: cell.contentView)
                }
            case .personal:
                guard let sectionItem = item as? DataSource.PersonalSectionItem else {
                    return cell
                }
                switch sectionItem {
                case .fullname(let fullname):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
                    cell.text = fullname
                    return cell
                case .contact(type: let type, value: let value):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath) as! ContactCollectionViewCell
                    cell.set(type: type, value: value)
                    return cell
                }
            default:
                break
            }
            return cell
        })
        
        collectionView.dataSource = dataSource
        
        let snapshot = DataSource.snapshot(from: viewModel)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 300, height: 300)
    }
}

#if DEBUG
import SwiftUI

struct ViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController").view
    }
    
    func updateUIView(_ view: UIView, context: Context) {}
}

struct ViewRepresentable_Preview: PreviewProvider { //swiftlint:disable:this type_name
    static var devices = ["iPhone SE", "iPhone XS Max", "iPad Pro (11-inch)"]

    static var previews: some View {
        Group {
            ForEach(devices, id: \.self) { name in
                ViewRepresentable()
                    .previewDevice(PreviewDevice(rawValue: name))
                    .previewDisplayName(name)
            }
        }
    }
}
#endif
