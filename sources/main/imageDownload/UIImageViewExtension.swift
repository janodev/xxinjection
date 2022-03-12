@preconcurrency import Foundation
import os
@preconcurrency import UIKit

public enum UIImageViewExtensionOptions {
    case discardUnless(condition: () -> Bool)
    case resize(newSize: CGSize)
    case onSuccess(action: @MainActor () -> Void)
}

public final class UIImageViewExtension
{
    private var log = Logger(subsystem: "dev.jano", category: "kit")
    public var imageDownloader = ImageDownloader()
    private let base: UIImageView

    public init(_ base: UIImageView) {
        self.base = base
    }

    public func setImage(url: URL, options: [UIImageViewExtensionOptions]) {
        Task {
            guard var image = try await imageDownloader.image(from: url) else {
                return
            }
            var onSuccess: @MainActor () -> Void = {}
            for option in options {
                switch option {
                case .discardUnless(let condition):
                    if !condition() {
                        log.trace("Discarded")
                        return
                    }
                case .resize(let newSize):
                    image = await resize(image: image, newSize: newSize)
                case .onSuccess(let action): 
                    onSuccess = action
                }
            }
            log.trace("image is \(String(describing: image.size))")
            
            let decodedImage = await image.byPreparingForDisplay()
            await MainActor.run { [decodedImage, onSuccess] in
                base.image = decodedImage
                onSuccess()
            }
        }
    }

    private func resize(image: UIImage, newSize: CGSize) async -> UIImage {
        guard image.size != newSize else {
            return image
        }
        if let resizedImage = await image.byPreparingThumbnail(ofSize: newSize) {
            return resizedImage
        }
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

public extension UIImageView {
    var ext: UIImageViewExtension {
        UIImageViewExtension(self)
    }
}
