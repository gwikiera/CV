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
import Networking
#if DEBUG
import Combine
#endif

public class CollectionViewController: UICollectionViewController {
    private let viewState: CollectionViewState
    private var dataSource: UICollectionViewDiffableDataSource<CollectionViewState.Section.Kind, CollectionViewState.Item>?
    private let imageProvider: ImageProvider

    private lazy var cellProvider = CellProvider(collectionView: collectionView, imageProvider: imageProvider)
#if DEBUG
    private var cancellable: Cancellable?
#endif
    
    public init(viewState: CollectionViewState, imageProvider: ImageProvider) {
        self.viewState = viewState
        self.imageProvider = imageProvider
        super.init(collectionViewLayout: CollectionViewLayoutGenerator().generateLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .black
        
        dataSource = UICollectionViewDiffableDataSource<CollectionViewState.Section.Kind, CollectionViewState.Item>(collectionView: collectionView, cellProvider: cellProvider.provideCell)
        collectionView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewState.Section.Kind, CollectionViewState.Item>()
        viewState.sections.forEach { section in
            snapshot.appendSections([section.kind])
            snapshot.appendItems(section.items, toSection: section.kind)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

#if DEBUG
    /// Helper function to record preview video of the app
    func scrollToRecordPreview() {
        guard let numberOfSections = dataSource?.numberOfSections(in: collectionView), numberOfSections > 0 else { return }
        let scrollingPublisher = (2..<numberOfSections).publisher
            .map { IndexPath(item: 0, section: $0)}
        let timerPublisher = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect().delay(for: .seconds(1), scheduler: DispatchQueue.main, options: .none)

        cancellable = Publishers.Zip(scrollingPublisher, timerPublisher)
            .sink { [collectionView] indexPath, _ in
                collectionView?.scrollToItem(
                    at: indexPath,
                    at: .top,
                    animated: true
                )
            }
    }
#endif
}

#if DEBUG
import SwiftUI

struct CollectionViewController_Preview: PreviewProvider { // swiftlint:disable:this type_name
    static var previews: some View {
        GenericViewRepresentable(view: CollectionViewController(viewState: .init(sections: []), imageProvider: .noop).view)
            .previewForDevices()
    }
}
#endif
