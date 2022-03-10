import Coordinator
import CoreDataStack
import Injection
import Keychain
import os
@preconcurrency import TumblrNPFPersistence
@preconcurrency import TumblrNPF

struct HomeRepository
{
    @Dependency private var log: Logger
    @Dependency private var persistence: PersistentContainer
    @Dependency private var tumblrClient: TumblrAPI

    func posts(blogIdentifier: String) async throws -> [Post] {

        // save API to database
        let recommended: TumblrResponse<BlogPage> = try await self.tumblrClient.posts(blogIdentifier: blogIdentifier)
        if let blogs: BlogPage = recommended.response.objectValue {
            try await persistence.save(model: blogs.blogs)
        }

        // read from database
        let blogMOs: [BlogMO] = try await persistence.read()

        // map to sections
        let storedBlogs = blogMOs.compactMap { Blog(mo: $0) }
        let posts: [[Post]] = storedBlogs.compactMap { $0.posts }
        return Array(posts.joined())
    }

    func recommendedBlogs() async throws -> [Post] {

        // save API to database
        let recommended: TumblrResponse<BlogPage> = try await self.tumblrClient.recommendedBlogs()
        if let blogs: BlogPage = recommended.response.objectValue {
            try await persistence.save(model: blogs.blogs)
        }

        // read from database
        let blogMOs: [BlogMO] = try await persistence.read()

        // map to sections
        let storedBlogs = blogMOs.compactMap { Blog(mo: $0) }
        let posts: [[Post]] = storedBlogs.compactMap { $0.posts }
        return Array(posts.joined())
    }

    func specificPost(blogId: String, postId: String) async throws -> Post? {
        let postResponse: TumblrResponse<Post> = try await self.tumblrClient.post(blogId: blogId, postId: postId)
        return postResponse.response.objectValue
    }
}
