import Foundation

public struct ProfileResponse: Decodable {
    
    var status: String?
    var profile: ProfileEntity
    
    enum CodingKeys: String, CodingKey {
        
        case status = "STATUS"
        case profile = "person"
    }
}
