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

public extension UIView {
    func embed(view: UIView, offset: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -offset).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: -offset).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: offset).isActive = true
    }

    func center(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
