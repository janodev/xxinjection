import AutoLayout
import Injection
import TumblrNPF
import os
import UIKit

final class TextContentView: UIView, Configurable
{
    @Dependency private var log: Logger

    private let textLabel = UITextView().configure {
        $0.adjustsFontForContentSizeCategory = true
        $0.isScrollEnabled = false
        $0.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }

    // MARK: - Initialization

    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }

    private func initialize()
    {
        backgroundColor = .white
        layout()
    }

    func layout() {
        addSubview(textLabel)
        al.applyVFL([
            "H:|-[textLabel]-|",
            "V:|[textLabel]|"
        ], views: ["textLabel": textLabel])
    }

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor () -> Void) {
        guard let textContent = item.textContent else {
            log.error("🚨Wrong item type!. This cell handles .text or .tag, got \(String(describing: item))")
            return
        }
        configure(textContent)
    }

    func configure(_ textContent: TextContent)
    {
        let attributedText = NSMutableAttributedString(string: textContent.text)
        textContent.formatting?
            .compactMap { $0 }
            .forEach { format in
                if let font = textContent.subtype?.font {
                    var format = format
                    format.font = font
                    attributedText.addAttribute(format)
                } else {
                    attributedText.addAttribute(format)
                }
            }
        textLabel.attributedText = attributedText
    }
}
