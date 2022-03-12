import Injection
import os
import TumblrNPF
import UIKit

/// Represents a media object suitable for a particular viewport.
struct BestMedia
{
    @Dependency private var log: Logger

    let url: URL
    let size: CGSize

    /**
     - Parameters:
       - media: Available media objects.
       - viewport: Size of the view where this image will be displayed.
     */
    init?(media: [MediaObject], viewport: CGSize) {
        guard
            let media = Self.firstFittingImage(images: media, viewport: viewport),
            let width = media.width,
            let height = media.height
        else {
            return nil
        }
        let originalMediaSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        let newMediaSize = Self.resizeWidth(originalSize: originalMediaSize, newWidth: viewport.width)
        self.url = media.url
        self.size = newMediaSize
    }

    /**
     Returns the first image whose dimensions fit inside the given viewport.

     The image returned will be resized to fit the width so images smaller
     than the viewport width may incur some loss of quality.
    */
    private static func firstFittingImage(images: [MediaObject], viewport: CGSize) -> MediaObject? {

        let scale = UIScreen.main.scale
        let scaledViewport = CGSize(width: viewport.width * scale, height: viewport.height * scale)

        let windowWidth = Int(scaledViewport.width)
        let windowHeight = Int(scaledViewport.height) - 46 /* 46 = nav bar height */

        // returning the first because the array arrives sorted.
        return images.first { media in
            if
                let mediaWidth = media.width,
                let mediaHeight = media.height,
                mediaWidth < windowWidth,
                mediaHeight < windowHeight
            {
                return true
            }
            return false
        }
    }

    /// Resizes to new width preserving the aspect ratio.
    private static func resizeWidth(originalSize: CGSize, newWidth: CGFloat) -> CGSize {
        let imageRatio = originalSize.width / originalSize.height
        let height = newWidth / imageRatio
        return CGSize(width: round(newWidth), height: round(height))
    }
}
