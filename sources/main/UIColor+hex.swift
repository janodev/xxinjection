import UIKit

public extension UIColor
{
    // Creates a color from a hex string.
    convenience init(hexString: String)
    {
        /*
         This method is expensive to type-check:
            - 392ms for 'init(hexString:)',
            - 130ms for the divisions at the bottom
         */

        let hex = String(hexString.dropFirst())
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(red: CGFloat(r) / 255,
                  green: CGFloat(g) / 255,
                  blue: CGFloat(b) / 255,
                  alpha: CGFloat(a) / 255)
    }
}
