import UIKit

extension CGSize {
    static func threeRowSize(with padding: CGFloat) -> CGSize {
        let totalPadding: CGFloat = 6 * padding
        let width: CGFloat = (UIScreen.main.bounds.width - totalPadding) / 3
        let ratio: CGFloat = 1.5
        return CGSize(width: width, height: width * ratio)
    }
}

