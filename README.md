## CV

[![Build Status](https://app.bitrise.io/app/58d6b8fa19361986/status.svg?token=ixZcR8_gebyATzpfIgc7KA&branch=develop)](https://app.bitrise.io/app/58d6b8fa19361986)
[![Build Status](https://app.travis-ci.com/gwikiera/CV.svg?branch=develop)](https://app.travis-ci.com/gwikiera/CV)
[![codecov](https://codecov.io/gh/gwikiera/CV/branch/develop/graph/badge.svg?token=S9E78LT4BV)](https://codecov.io/gh/gwikiera/CV)

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/gwikiera/CV">
    <img src="README/logo.png" alt="Logo" width="80" height="80">
  </a>

  <p align="center">
   A showcase project, which fetches data and renders my CV.
   <br>
   It is also my playground project, where I like to play with architecture, design patterns, and technics.</p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
      <li><a href="#license">License</a></li>
    </li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project
<p align="center">
 <img src="README/AppPreview.gif" alt="AppPreview" align="center">
</p>

A simple iOS app is written in Swift.

UI was created using the `UIKit` framework. `SwiftUI` is used only to enable previews of the views. New views will be created in `SwiftUI`.

The app is not built using only one architecture, but each view uses only one of them. Currently used architectures: 
* Clean Swift
* MVVM

All the code is written in a testable way. Unit tests are written using `XCText`, `Quick`, and `Nimble` frameworks.

[Bitrise](https://app.bitrise.io/app/58d6b8fa19361986) and [Travis CI](https://app.travis-ci.com/gwikiera/CV) are used for CI, [Codecov](https://codecov.io/gh/gwikiera/CV) for measuring code coverage.

[SwiftLint](https://github.com/realm/SwiftLint) is used for linting the Swift source code. It is added to the project as a build phase. 

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To run the project only Xcode is needed (version 13+). All the project dependencies will be fetched automatically by the Swift Package Manager. 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/gwikiera/CV.git
   ```
2. Open the `CV` Xcode project
   ```sh
   cd CV
   open CV.xcodeproj
   ```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the Apache  License. See [LICENSE](LICENSE) for more information.

<p align="right">(<a href="#top">back to top</a>)</p>