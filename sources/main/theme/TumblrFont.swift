import UIKit

enum TumblrFont: String, CaseIterable
{
    case gibsonRegular = "Gibson-Regular"
    case gibsonRegularItalic = "Gibson-RegularItalic"
    case gibsonBold = "Gibson-Bold"
    case gibsonBoldItalic = "Gibson-BoldItalic"

    private static var cache: [String: UIFont] = Self.allCases.reduce(into: [String: UIFont]()) {
        $0[$1.rawValue] = UIFont(name: $1.rawValue, size: 17)
    }

    func font() -> UIFont? {
        Self.cache[rawValue]
    }

    func font(size: CGFloat) -> UIFont? {
        Self.cache[rawValue].flatMap {
            UIFont(descriptor: $0.fontDescriptor, size: size)
        }
    }

    init?(name: String, weight: String) {
        switch (name.lowercased(), weight.lowercased()) {
        case ("gibson", "regular"): self = .gibsonRegular
        case ("gibson", "regularitalic"): self = .gibsonRegularItalic
        case ("gibson", "bold"): self = .gibsonBold
        case ("gibson", "bolditalic"): self = .gibsonBoldItalic
        default: return nil
        }
    }
}
