import UIKit

public final class Cache
{
    public enum Entry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }

    private final class CacheEntry: NSObject {
        let entry: Entry
        init(entry: Entry) {
            self.entry = entry
        }
    }

    private var cache = NSCache<NSURL, CacheEntry>()

    public func read(url: URL) -> Entry? {
        cache.object(forKey: url as NSURL)?.entry
    }

    public func add(entry: Entry, url: URL) {
        cache.setObject(CacheEntry(entry: entry), forKey: url as NSURL)
    }

    public func remove(url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }

    public func peek(url: URL) -> UIImage? {
        if case let .ready(image) = cache.object(forKey: url as NSURL)?.entry {
            return image
        } else {
            return nil
        }
    }
}
