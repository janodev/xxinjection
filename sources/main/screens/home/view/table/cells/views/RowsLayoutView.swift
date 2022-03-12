import Injection
import Kit
import TumblrNPF
import os
import UIKit

final class RowsLayoutView: UIView, Configurable, Identifiable, ManualLayout
{
    @Dependency var log: Logger
    static let horizontalMargin: CGFloat = 8

    private let stackView = StackView().configure {
        $0.backgroundColor = .green
        $0.spacing = RowsLayoutView.horizontalMargin
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.alignment = .fill
    }

    /// Data used to configure this cell.
    var item: Item?

    // MARK: - Identifiable

    /// Id refreshed on dequeue.
    /// Used after downloading an image to know if the cell has been recycled.
    private(set) var id = UUID()

    // MARK: - UIView

    override init(frame: CGRect){
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = calculateSize()
        stackView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        frame = stackView.frame
    }

    override var intrinsicContentSize: CGSize {
        calculateSize()
    }

    private func calculateSize() -> CGSize {
        guard let width = superview?.frame.size.width,
              let height = stackView.arrangedSubviews.map({ $0.intrinsicContentSize.height }).sorted().last
        else {
            return CGSize.zero
        }
        return CGSize(width: width, height: height)
    }

    // MARK: - Layout

    private func layout() {
        clipsToBounds = true
        addSubview(stackView)
        stackView.frame = CGRect.zero
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
            stackView.addArrangedSubview(view)
            view.configure(item, viewport: viewportPerElement, updateLayout: {
                self.setNeedsLayout()
            })
        }
#warning("download images in a task group, and updatelayout once")
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

    // MARK: - ManualLayout

    static let log = DependencyContainer.resolve() as Logger

    static func viewportPerElement(numberOfItems: Int, containingViewport viewport: CGSize) -> CGSize {
        let widthPerElement = round(viewport.width / CGFloat(numberOfItems))
            - CGFloat(RowsLayoutView.horizontalMargin * max(CGFloat(numberOfItems) - 1, 0))
        return CGSize(width: widthPerElement, height: viewport.height)
    }

    static func height(item: Item, viewport: CGSize) -> CGFloat {

        guard case .rows(let items) = item else {
            log.error("🚨Expected item .rows([Item]), got instead \(String(describing: item)). Returning 0 as height.")
            return 0
        }

        let containsOnlyImages = items.allSatisfy { item in
            guard case .image = item else {
                log.error("🚨Expected rows to contain [Item.image], got instead \(String(describing: item)). Returning 0 as height.")
                return false
            }
            return true
        }

        guard containsOnlyImages else {
            return 0
        }

        let viewportPerElement = RowsLayoutView.viewportPerElement(
            numberOfItems: items.count,
            containingViewport: viewport
        )

        let itemsHeight: [CGFloat] = items.map { ImageContentView.height(item: $0, viewport: viewportPerElement) }
        guard let maxHeight = itemsHeight.sorted().last else {
            log.error("🚨Failed to calculate max height. Returnin 0 as height")
            return 0
        }
        return maxHeight
    }
}
