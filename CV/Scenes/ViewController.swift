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
    private var dataSource: UICollectionViewDiffableDataSource<DataSource.Section, AnyHashable>?
    private lazy var cellProvider = CellProvider(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource<DataSource.Section, AnyHashable>(collectionView: collectionView, cellProvider: cellProvider.provideCell(collectionView:indexPath:item:))
        collectionView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Placeholder
        display(viewModel: .example)
    }
    
    func display(viewModel: ViewModel) {
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
