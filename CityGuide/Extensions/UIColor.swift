import UIKit

enum AssetsColor : String {
  case background
  case cell
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
