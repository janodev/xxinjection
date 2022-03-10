import os
@preconcurrency import UIKit

public enum FetchError: Error {
    case badResponse
    case badImage
    case badURL
}

/**
 Image cache.
 This is an actor so only one request is alive at a time,
 even when there can be many ongoing but suspended at the suspension points (await).
*/
public actor ImageDownloader
{
    private let log = Logger(subsystem: "dev.jano", category: "ImageDownloader")
    public static let shared = ImageDownloader()

    private let cache = Cache()

    public func image(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            log.error("🚨Ignoring request. URL is not valid: \(urlString)")
            return nil
        }
        return try await image(from: url)
    }

    public func image(from url: URL) async throws -> UIImage? {

        if let cached = cache.read(url: url) {
            // the cache contains images either downloaded or in progress
            switch cached {
                case .ready(let image):
                    return image // return image immediately
                case .inProgress(let handle):
                    return try await handle.value // await the download and return the image
            }
        }

        // create and store an image in progress
        let handle = Task {
            try await downloadImage(from: url)
        }
        cache.add(entry: .inProgress(handle), url: url)

        do {
            // await the download, store the image, return the image
            let image = try await handle.value
            cache.add(entry: .ready(image), url: url)
            return image
        } catch {
            cache.remove(url: url) // remove the download in progress
            throw error
        }
    }

    private func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw FetchError.badURL
        }
        return try await downloadImage(from: url)
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
//        log.trace("Downloading \(url.absoluteString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badResponse
        }
        guard let image = UIImage(data: data) else {
            throw FetchError.badImage
        }
        return image
    }
}
