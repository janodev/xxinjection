import TumblrNPF
import UIKit

enum Item: Hashable, @unchecked Sendable
{
    case audio(ViewModel<AudioContent>)
    case header(ViewModel<Blog>)
    case image(ViewModel<ImageContent>)
    case link(ViewModel<LinkContent>)
    case notes(ViewModel<Int>)
    case paywall(ViewModel<PaywallContent>)
    case tags(ViewModel<TextContent>)
    case text(ViewModel<TextContent>)
    case video(ViewModel<VideoContent>)
    case rows([Item])

    var textContent: TextContent? {
        switch self {
        case .tags(let model): return model.content
        case .text(let model): return model.content
        default: return nil
        }
    }
}
