import Injection
import Kit
import os
import TumblrNPF
import UIKit

final class AutoLayoutRowsLayoutView: UIView, Configurable, Identifiable
{
    @Dependency var log: Logger
    static let horizontalMargin: CGFloat = 8

    private let stackView = StackView().configure {
        $0.backgroundColor = .green
        $0.spacing = AutoLayoutRowsLayoutView.horizontalMargin
        $0.distribution = .fill
        $0.axis = .horizontal
    }

    /// Data used to configure this cell.
    var item: Item?

    // MARK: - Identifiable

    /// Id refreshed on dequeue.
    /// Used after downloading an image to know if the cell has been recycled.
    private(set) var id = UUID()

    // MARK: - Initialize

    override init(frame: CGRect){
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func layout() {
        clipsToBounds = true
        addSubview(stackView)
        al.applyVFL([
            "H:|[stackView]|",
            "V:|[stackView]|"
        ], views: [
            "stackView": stackView
        ])
    }

    // MARK: - Configurable

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor @escaping () -> Void)
    {
        guard case .rows(let rows) = item else {
            log.error("🚨Wrong item type!, expected .rows([Item]), got \(String(describing: item))")
            return
        }

        guard self.item != item else {
            return /* nothing to do */
        }
        self.item = item

        // prepare for reuse
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let viewItemTuple: [(UIView & Configurable, Item)] = rows.compactMap { item in
            guard let view = createView(for: item) else  { return nil }
            return (view, item)
        }

        let viewportPerElement = RowsLayoutView.viewportPerElement(
            numberOfItems: viewItemTuple.count,
            containingViewport: viewport
        )

        for (view, item) in viewItemTuple {
            view.configure(item, viewport: viewportPerElement, updateLayout: updateLayout)
            stackView.addArrangedSubview(view)
        }
    }

    private func createView(for item: Item) -> (UIView & Configurable)? {
        switch item {
        case .audio: return AudioContentView()
        case .header: return HeaderView()
        case .image: return ImageContentView()
        case .link: return LinkContentView()
        case .notes: return NoteBarView()
        case .paywall: return PaywallContentView()
        case .rows: log.error("🚨Ignoring a nested rows element. Not supported."); return nil
        case .tags: return TextContentView()
        case .text: return TextContentView()
        case .video: return VideoContentView()
        }
    }
}
