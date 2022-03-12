import Foundation

public struct DefaultViewsEntity: Codable, Equatable {

    public enum CommentItem: String, CodingKey {

        case commentItem = "comments-item"
    }

    public enum Items: String, CodingKey {

        case sortOrder
        case sortBy
    }

    public enum Order: String, Codable {
        
        public static let defaultSortFieldName = "date"
        
        case ascending = "asc"
        case descending = "desc"
    }

    public var itemCommentsSortOrder: Order

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CommentItem.self)
        if container.contains(.commentItem) {

            let nestedContainer = try container.nestedContainer(keyedBy: Items.self, forKey: .commentItem)
            itemCommentsSortOrder = try nestedContainer.decodeIfPresent(Order.self, forKey: .sortOrder) ?? Order.descending
        } else {

            itemCommentsSortOrder = .descending
        }
    }
}
