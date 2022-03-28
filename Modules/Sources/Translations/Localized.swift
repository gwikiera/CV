import Foundation

public extension String {
    enum Localized {
        public static let about = NSLocalizedString("about.header", bundle: .module, comment: "Header text for about section cell.")
        public static let tryAgain = NSLocalizedString("error.tryAgain", bundle: .module, comment: "Try again button label on error screen.")
    }
}
