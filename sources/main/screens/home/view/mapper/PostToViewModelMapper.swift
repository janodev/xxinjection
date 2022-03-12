import Foundation
import Injection
import os
import TumblrNPF

/// Returns a sequence of "sectionId-0", "sectionId-1", etc.
private struct IndexIterator
{
    private(set) var index = 0
    let sectionId: String
    mutating func next() -> String {
        defer { index += 1 }
        return "\(sectionId)-\(index)"
    }
}

/// Maps a Post to a view model.
enum PostToViewModelMapper
{
    @Dependency private static var log: Logger

    /**
     Map each post to a dedicated section.

     - The section id is the post id.
     - The section item’s are the post elements (header, blocks, tags, etc.).
    */
    static func map(_ post: Post) -> Section {
        Section(
            id: post.id.value.description,
            items: Self.map(post)
        )
    }

    /**
     Map the content of each post to an array of Items.
     Each item has an id with format "section id - consecutive id".
     */
    static func map(_ post: Post) -> [Item]
    {
        var index = IndexIterator(sectionId: post.id.value.description)

        let header: Item? = post.basePost.blog.flatMap { blog in
            Item.header(ViewModel(id: index.next(), content: blog))
        }

        let contentBlocks: [Item] = post.basePost.content?.compactMap { contentBlock in
            createContentBlocks(id: index.next(), content: contentBlock)
        } ?? []

        let tags: Item? = post.basePost.tags.flatMap { tags in
            createTags(id: index.next(), tags: tags)
        }

        let note: Item? = post.basePost.noteCount.flatMap { count in
            Item.notes(ViewModel(id: index.next(), content: count))
        }

        var items = [Item?]()
        items.append(contentsOf: [header])

        let laidOutBlocks = layOutBlocks(
            blocks: contentBlocks.compactMap { $0 },
            layouts: post.basePost.layout ?? []
        )
        if let laidOutBlocks = laidOutBlocks {
            items.append(contentsOf: laidOutBlocks)
        } else {
            items.append(contentsOf: contentBlocks)
        }

        items.append(contentsOf: [tags])
        items.append(contentsOf: [note])

        return items.compactMap { $0 }
    }

    private static func layOutBlocks(blocks: [Item], layouts: [Layout]) -> [Item]?
    {
        guard let firstLayout: Layout = layouts.first, layouts.count == 1 else {
            log.warning("Only one layout is supported, got \(String(describing: layouts.count)). Returning original blocks.")
            return blocks
        }

        guard case .rows(let rowsLayout) = firstLayout else {
            log.error("🚨Layout.rows(RowsLayout) is the only layout supported. Returning the original blocks.")
            return blocks
        }

        var laidOutItems = [Item]()
        for row in rowsLayout.display {
            if let firstIndex = row.blocks.first, row.blocks.count == 1 {
                laidOutItems.append(blocks[firstIndex])
            } else {
                let rowItems = row.blocks.map { index in blocks[index] }
                laidOutItems.append(.rows(rowItems))
            }
        }
        return laidOutItems
    }

    private static func createTags(id: String, tags: [String]) -> Item {
        let text = tags.map { "#\($0)" }.joined(separator: " ")
        let textContent = TextContent(
            formatting: [
                Formatting(blog: nil, end: text.count, start: 0, type: .color, url: nil, hex: "#444444")
            ],
            indentLevel: nil,
            subtype: .heading2,
            text: text,
            type: "text"
        )
        let viewModel = ViewModel(id: id, content: textContent)
        return Item.tags(viewModel)
    }

    private static func createContentBlocks(id: String, content: Content) -> Item? {
        switch content {
        case .audio(let audio): return Item.audio(ViewModel(id: id, content: audio))
        case .image(let image): return Item.image(ViewModel(id: id, content: image))
        case .link(let link): return Item.link(ViewModel(id: id, content: link))
        case .paywall(let paywall): return Item.paywall(ViewModel(id: id, content: paywall))
        case .text(let text): return Item.text(ViewModel(id: id, content: text))
        case .video(let video): return Item.video(ViewModel(id: id, content: video))
        case .unknown: return nil
        }
    }

    private static func isImplemented(item: Item) -> Bool {
        switch item {
        case .audio, .link, .paywall: return false
        default: return true
        }
    }
}
