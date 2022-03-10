import UIKit

@MainActor
protocol Configurable {
    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor @escaping () -> Void)
    func prepareForReuse()
}

extension Configurable {
    @MainActor
    func prepareForReuse() {}
}
