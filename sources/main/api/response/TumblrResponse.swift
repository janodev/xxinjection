import CodableHelpers
import Foundation
import TumblrNPF

// TumblrAPIResponse<Page<Blog>>

struct TumblrResponse<T: Codable & Hashable>: Error, Codable, CustomStringConvertible
{
    let meta: Meta
    let errors: [TumblrAPIError]?
    let response: CodableArrayOrObject<T>

    var description: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let json = try? encoder.encode(self), let string = String(data: json, encoding: .utf8) else {
            return "<failed to encode a JSON description>"
        }
        return string
    }

    enum CodingKeys: String, CodingKey {
        case meta
        case errors
        case response
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meta = try container.decode(Meta.self, forKey: .meta)
        self.errors = try container.decodeIfPresent([TumblrAPIError].self, forKey: .errors)
        self.response = try container.decode(CodableArrayOrObject<T>.self, forKey: .response)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(meta, forKey: .meta)
        try container.encode(errors, forKey: .errors)
        try container.encode(response, forKey: .response)
    }
}
