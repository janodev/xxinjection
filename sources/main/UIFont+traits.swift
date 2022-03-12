import UIKit

public extension UIFont
{
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        fontDescriptor.withSymbolicTraits(traits).flatMap {
            UIFont(descriptor: $0, size: pointSize)
        } ?? self
    }

    func italic() -> UIFont {
        withTraits(.traitItalic)
    }

    func bold() -> UIFont {
        withTraits(.traitBold)
    }

    func boldItalic() -> UIFont {
        withTraits([ .traitBold, .traitItalic ])
    }
}
