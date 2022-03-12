import Injection
import TumblrNPF
import os
import UIKit

final class ImageContentView: UIView, Configurable, Identifiable, ManualLayout
{
    private static let margin = CGFloat(16)

    @Dependency var log: Logger

    lazy var imageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
    }
    let caption = UILabel().configure {
        $0.numberOfLines = 0
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
        clipsToBounds = true
        addSubview(imageView)
        addSubview(caption)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        id = UUID()
        // Don’t nil any other data. All properties are reset on each configure call.
    }

    // MARK: - Configurable

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor @escaping () -> Void) {

        guard case .image(let image) = item else {
            log.error("🚨Wrong item type!, expected .image(ImageContent), got \(String(describing: item))")
            return
        }

        guard self.item != item else {
            return
        }
        self.item = item

        if let text = image.content.altText {
            caption.text = text
            caption.frame = CGRect(x: 0, y: ImageContentView.margin, width: viewport.width, height: .greatestFiniteMagnitude)
            caption.sizeToFit()
        } else {
            caption.text = nil
            caption.frame = CGRect.zero
        }

        self.imageView.image = nil
        imageView.frame = CGRect.zero
        guard let bestMedia = BestMedia(media: image.content.media, viewport: viewport) else {
            return
        }

        let idBefore = id
        Task {
            imageView.ext.setImage(
                url: bestMedia.url,
                options: [
                    .discardUnless(condition: { idBefore == self.id }),
                    .resize(newSize: bestMedia.size),
                    .onSuccess(action: { [weak self] in
                        guard let self = self else { return }
                        self.layout()
                        updateLayout()
                    })
                ]
            )
        }
    }

    // MARK: - UIView

    private func layout() {
        guard let image = imageView.image else {
            imageView.frame = CGRect.zero
            caption.frame = CGRect.zero
            return
        }

        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        if caption.text != nil {
            let y = image.size.height + ImageContentView.margin
            caption.frame = CGRect(x: 0, y: y, width: image.size.width, height: .greatestFiniteMagnitude)
            caption.sizeToFit()
        } else {
            caption.frame = CGRect.zero
        }
        frame.size = calculateSize()
    }

    override var intrinsicContentSize: CGSize {
        calculateSize()
    }

    private func calculateSize() -> CGSize {
        guard let image = imageView.image else { return CGSize.zero }
        let height = image.size.height
            + caption.frame.size.height
            + ((caption.text != nil) ? ImageContentView.margin : 0)
        return CGSize(width: image.size.width, height: height)
    }

    // MARK: - ManualLayout

    static func height(item: Item, viewport: CGSize) -> CGFloat {

        let log = DependencyContainer.resolve() as Logger

        var height = CGFloat(0)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewport.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.sizeToFit()
        height += label.frame.size.height

        guard case .image(let image) = item else {
            log.error("🚨Wrong item type!, expected .image(ImageContent), got \(String(describing: item))")
            return height
        }
        guard let bestMedia = BestMedia(media: image.content.media, viewport: viewport) else {
            log.error("🚨No image found")
            return height
        }
        height += bestMedia.size.height
        return height
    }
}
