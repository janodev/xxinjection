import Foundation
import os
import XCTest

extension XCTestCase
{
    class BundleFinder {}

    func decode<T: Decodable>(filename: String) -> T? {
        guard let url = Bundle(for: BundleFinder.self).url(forResource: filename, withExtension: "json"),
            let jsonData = try? Data(contentsOf: url) else {
                XCTFail("Missing \(filename).json. Is it added to build phases?")
                return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            let errorMessage = "\(error)"
                .components(separatedBy: ", ")
                .joined(separator: ", \n                   ")
            Logger(subsystem: "dev.jano", category: "apptests").warning("""
                Error decoding. Details follow...
                Source JSON: \(filename)
                Decoded type: \(T.self)
                Error: \(errorMessage)
                JSON contents: \n\(String(decoding: jsonData, as: UTF8.self))
                """)
            return nil
        }
    }
}

