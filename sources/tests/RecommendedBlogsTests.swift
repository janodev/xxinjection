import Foundation
import TumblrNPF
import os
import XCTest
@testable import MyTumblr

final class RecommendedBlogsTests: XCTestCase
{
    private let log = Logger(subsystem: "dev.jano", category: "apptests")

    func testTumblr1() throws
    {
        guard let blogs: TumblrResponse<BlogPage> = decode(filename: "tumblr1") else {
            XCTFail("Decoding failed.")
            return
        }

        log.debug("\(String(describing: blogs))")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(blogs)
        let json = String(data: jsonData, encoding: .utf8)!
        log.debug("\n\(json)")
    }

    func testTumblr2() throws
    {
        guard let blogs: TumblrResponse<BlogPage> = decode(filename: "tumblr2") else {
            XCTFail("Decoding failed.")
            return
        }

        log.debug("\(String(describing: blogs))")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(blogs)
        let json = String(data: jsonData, encoding: .utf8)!
        log.debug("\n\(json)")
    }

    func testTumblr3() throws
    {
        guard let blogs: TumblrResponse<BlogPage> = decode(filename: "tumblr3") else {
            XCTFail("Decoding failed.")
            return
        }

        log.debug("\(String(describing: blogs))")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(blogs)
        let json = String(data: jsonData, encoding: .utf8)!
        log.debug("\n\(json)")
    }

    func testAPIError() throws
    {
        guard let blogs: TumblrResponse<[BlogPage]> = decode(filename: "APIError") else {
            XCTFail("Decoding failed.")
            return
        }

        log.debug("\(String(describing: blogs))")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(blogs)
        let json = String(data: jsonData, encoding: .utf8)!
        log.debug("\n\(json)")
    }
}
