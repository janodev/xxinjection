import APIClient
import CodableHelpers
import Foundation

final class TWAPIClient: APIClient {

//    func request(path: String) async throws -> Data {
//        let resource = Resource<ProfileResponse>(path: path, decode: { data, response in
//            guard let data = data else {
//                throw TeamworkError.expectedNonEmptyResponse
//            }
//            let string = String(data: data, encoding: .utf8)
//            do {
//                guard let response = try ProfileResponse.decode(json: string) else {
//
//
//                }
//            } catch {
//                throw APIClientError.JSONDecodingFailure(
//                    PrettyDecodingError(error, offendingJSON: data, intendedType: ProfileResponse.self)
//                )
//            }
//
//            return response
//        })
//        return try await super.request(resource)
//    }

    public func me() async throws -> ProfileResponse {
        try await request(
            resource(path: "me.json", queryItems: [:])
        )
    }

    public func resource<T: Decodable>(path: String, queryItems: [String: String]) -> Resource<T> {
        Resource<T>(
            additionalHeaders: HTTPHeader.acceptJSON.value,
            method: .get,
            path: path,
            queryItems: queryItems,
            decode: { data, response in
                guard let data = data else {
                    throw APIClientError.invalidResponseEmpty
                }
                return try self.decode(jsonData: data)
            })
    }
}
