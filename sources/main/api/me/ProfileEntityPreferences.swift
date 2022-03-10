import Foundation

public struct ProfileEntityPreferences: Codable, Equatable {
    
    public enum Order: String, Codable {
        
        case ascending = "asc"
        case descending = "desc"
    }
    
    public var messageRepliesSortOrder: Order?
    
    enum CodingKeys: String, CodingKey {
        
        case messageRepliesSortOrder = "message-thread-sort"
    }
 
    public init(messageRepliesSortOrder: Order?) {
        
        self.messageRepliesSortOrder = messageRepliesSortOrder
    }
}
