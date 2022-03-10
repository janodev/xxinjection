import Foundation

public enum UserTypeEntity: String, Codable, Equatable {

    case account
    case collaborator
    case contact
    case unknown

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()
        self = (try? container.decode(String.self)).flatMap(UserTypeEntity.init) ?? .unknown
    }
}
