import AutoLayout
import Injection
import Kit
import os
import TumblrNPF
import UIKit

final class HeaderView: UIView, Configurable
{
    @Dependency private var log: Logger
    @Dependency private var imageDownloader: ImageDownloader

    private let avatar = UIImageView().configure {
        $0.contentMode = .scaleToFill
    }

    private let title = UILabel().configure {
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }

    private lazy var more = UIButton(
        configuration: UIButton.Configuration.plain(),
        primaryAction: moreAction
    )

    private lazy var moreAction = UIAction(
        title: "",
        image: UIImage(systemName: "ellipsis")
    ){ [weak self] _ in self?.didPressMore() }

    private lazy var follow = UIButton(
        configuration: UIButton.Configuration.plain(),
        primaryAction: followAction
    )

    private lazy var followAction = UIAction(title: ""){ [weak self] _ in self?.didPressFollow() }

    private let separator = UIView().configure {
        $0.backgroundColor = .lightGray
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
        addSubview(avatar)
        addSubview(title)
        addSubview(follow)
        addSubview(more)
        addSubview(separator)
        layout()
    }

    func layout() {
        al.applyVFL([
            "H:|-16-[avatar(24)]-[title][follow]-(>=m)-[more(48)]-|",
            "H:|-(m)-[separator]-(m)-|",
            "V:[avatar(24)]",
            "V:|-(>=m)-[title]-(>=m)-[separator(1)]|"
        ], metrics: ["m": 8])
        
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        follow.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        [avatar, title, follow, more].forEach { $0.al.centerY() }
    }

    // MARK: - Buttons actions

    func didPressFollow() {
        log.debug("You pressed follow.")
    }

    func didPressMore() {
        log.debug("You pressed more.")
    }

    // MARK: - Configurable

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor () -> Void) {
        guard case .header(let headerViewModel) = item else {
            log.error("🚨Wrong item type!, expected .header(Blog), got \(String(describing: item))")
            return
        }
        configure(headerViewModel.content)
    }

    func prepareForReuse() {
        avatar.image = nil
        title.text = ""
    }

    // MARK: -

    func configure(_ blog: Blog)
    {
        blog.theme.flatMap {
            applyTheme($0)
        }

        configure(avatars: blog.avatar)
        configure(name: blog.name)
        configureFollow(
            isFollowing: blog.followed ?? false,
            canBeFollowed: blog.canBeFollowed ?? false
        )
    }

    /// Configure the blog avatar
    private func configure(avatars: [Avatar]?) {
        if let urlString = avatars?.first(where: { $0.width == 64 })?.url {
            Task { [weak self] in
                guard let self = self else { return }
                self.avatar.image = try await self.imageDownloader.image(from: urlString)
            }
        }
    }

    /// Configure the blog name.
    private func configure(name: String?) {
        if let font = title.font {
            title.attributedText = NSAttributedString(
                string: name ?? "",
                attributes: [NSAttributedString.Key.font: font]
            )
        } else {
            title.text = name
        }
    }

    /// Configure the 'Follow' title.
    private func configureFollow(isFollowing: Bool, canBeFollowed: Bool) {
        let followTitle: String
        switch (isFollowing, canBeFollowed) {
        case (true, _): followTitle = "Followed"
        case (false, true): followTitle = "Follow"
        case (false, false): followTitle = "Follow" // no link
        }
        follow.configuration?.title = followTitle
    }

    private func applyTheme(_ theme: Theme) {
        follow.configuration?.buttonSize = .small
        if let font = TumblrFont(name: theme.titleFont, weight: theme.titleFontWeight)?.font() {
            title.font = font
        }
    }
}
