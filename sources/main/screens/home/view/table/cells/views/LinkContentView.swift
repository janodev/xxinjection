import AutoLayout
import Injection
import TumblrNPF
import os
import UIKit

final class LinkContentView: UIView, Configurable
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

        guard case .link(let link) = item else {
            log.error("🚨Wrong item type!, expected .audio(AudioContent), got \(String(describing: item))")
            return
        }

        configure(link)
    }

    func configure(_ link: ViewModel<LinkContent>)
    {
        let attributedText = NSMutableAttributedString(string: "LINK CONTENT IS NOT SUPPORTED")
        textLabel.attributedText = attributedText
    }
}
