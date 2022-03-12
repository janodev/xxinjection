import AutoLayout
import Injection
import os
import TumblrNPF
import UIKit

final class AudioContentView: UIView, Configurable
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

        guard case .audio(let audio) = item else {
            log.error("🚨Wrong item type!, expected .audio(AudioContent), got \(String(describing: item))")
            return
        }

        configure(audio)
    }

    func configure(_ audio: ViewModel<AudioContent>)
    {
        let attributedText = NSMutableAttributedString(string: "AUDIO CONTENT IS NOT SUPPORTED")
        textLabel.attributedText = attributedText
    }
}
