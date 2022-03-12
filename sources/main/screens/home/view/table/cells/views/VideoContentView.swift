import Injection
import Kit
import TumblrNPF
import os
import UIKit

/**
 Related info
 - https://gist.github.com/protrolium/8831763
 - https://medium.com/@anthonysaltarelli_10509/how-to-embed-youtube-videos-in-an-ios-app-with-swift-4-3d0b80a5cba6
 - https://developers.google.com/youtube/v3/guides/ios_youtube_helper
 - https://vikaskore.medium.com/embed-youtube-video-in-ios-swift-4-2-7befde21188d
 - http://www.wepstech.com/play-youtube-video-swift-5/
 */
final class VideoContentView: UIView, Configurable, Identifiable
{
    @Dependency var log: Logger

    lazy var imageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private let caption = UILabel().configure {
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

    private func layout() {
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
        guard case .video(let video) = item else {
            log.error("🚨Wrong item type!, expected .video(VideoContent), got \(String(describing: item))")
            return
        }
        Signpost.post(cell: self).begin("Configuration")
        guard self.item != item else {
            Signpost.post(cell: self).poi("Same item.")
            Signpost.post(cell: self).end("Configuration")
            return
        }
        self.item = item
        let idBefore = id

        Task {
            guard
                let mediaCandidates = video.content.poster,
                !mediaCandidates.isEmpty,
                let bestMedia = BestMedia(media: mediaCandidates, viewport: viewport)
            else {
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
