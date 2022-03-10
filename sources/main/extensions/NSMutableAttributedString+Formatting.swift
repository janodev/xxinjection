import os
import TumblrNPF
import UIKit

extension NSMutableAttributedString
{
    private func warning(_ string: String) {
        Logger(subsystem: "dev.jano", category: "app").warning("\(string)")
    }

    // swiftlint:disable:next function_body_length
    func addAttribute(_ format: Formatting)
    {
        guard format.end - format.start > 0 else {
            warning("Wrong parameters: start=\(format.start), end=\(format.end).")
            return
        }

        let range = NSRange(location: format.start, length: format.end - format.start)

        switch format.type {
        case .bold:
            addAttribute(
                NSAttributedString.Key.font,
                value: format.font.bold(),
                range: range
            )

        case .color:
            guard let hex = format.hex else {
                warning("Missing hex.")
                return
            }
            addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor(hexString: hex),
                range: range
            )

        case .italic:
            addAttribute(
                NSAttributedString.Key.font,
                value: format.font.italic(),
                range: range
            )

        case .link:
            guard let urlString = format.url else {
                warning("Missing url.")
                return
            }
            addAttribute(
                NSAttributedString.Key.link,
                value: urlString,
                range: range
            )

        case .mention:
            addAttribute(
                NSAttributedString.Key.font,
                value: format.font.boldItalic(),
                range: range
            )

        case .small:
            addAttribute(
                NSAttributedString.Key.font,
                value: format.font,
                range: range
            )

        case .strikethrough:
            addAttributes([
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.strikethroughColor: UIColor.lightGray
            ], range: range)
        }

        return
    }
}
