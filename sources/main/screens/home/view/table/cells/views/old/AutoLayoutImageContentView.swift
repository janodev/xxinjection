import Injection
import TumblrNPF
import os
import UIKit

/**
 Doesn’t support animation.
 Consider using [JellyGIF](https://github.com/TaLinh/JellyGif) for image/gif and [Swift-WebP](https://github.com/ainame/Swift-WebP) for image/webp.
 */
class AutoLayoutImageContentView: UIView, Configurable, Identifiable
{
    @Dependency var log: Logger

    lazy var imageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    let caption = UILabel().configure {
        $0.numberOfLines = 0
    }
    lazy var imageViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: 0)

    /// Data used to configure this cell.
    var item: Item?

    // MARK: - Identifiable

    /// Id refreshed on dequeue.
    /// Used after downloading an image to know if the cell has been recycled.
    private(set) var id = UUID()

    // MARK: - Initialize

    func prepareForReuse() {
        id = UUID()
        // Don’t nil any other data. All properties are reset on each configure call.
    }

    override init(frame: CGRect){
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func layout() {
        clipsToBounds = true
        addSubview(imageView)
        addSubview(caption)
        al.applyVFL([
            "H:|[imageView]|",
            "H:|-[caption]-|",
            "V:|[imageView][caption]|"
        ], views: [
            "imageView": imageView, "caption": caption
        ])
        imageViewHeightAnchor.isActive = true
        imageViewHeightAnchor.priority = UILayoutPriority(999)
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
        caption.text = image.content.altText
        let idBefore = id
        self.imageView.image = nil

        Task {

            guard let bestMedia = BestMedia(media: image.content.media, viewport: viewport) else {
                return
            }
            self.imageViewHeightAnchor.constant = bestMedia.size.height

            imageView.ext.setImage(
                url: bestMedia.url,
                options: [
                    .discardUnless(condition: { idBefore == self.id }),
                    .resize(newSize: bestMedia.size),
                    .onSuccess(action: {
                        updateLayout()
                    })
                ]
            )
        }
    }
}
