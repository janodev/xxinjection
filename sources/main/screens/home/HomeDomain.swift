import Coordinator
import CoreDataStack
import Injection
import Keychain
import OAuth2
import os
import TumblrNPFPersistence
import TumblrNPF

enum HomeDomainError: Error {
    case noSuchPost
    case logoutFailed
}

struct HomeDomain
{
    @Dependency private var accessTokenStore: OAuth2Store
    @Dependency private var log: Logger
    @Dependency private var persistence: PersistentContainer
    @Dependency private var tumblrClient: TumblrAPI
    private let repository = HomeRepository()
    var _output: ((HomeUpdate) -> Void)?

    private let parentCoordinator: Coordinating

    init(parentCoordinator: Coordinating) {
        self.parentCoordinator = parentCoordinator
    }

    /// Returns recommended blogs.
    func posts(blogIdentifier: String) async throws -> [Section] {
        let posts: [Post] = try await repository.posts(blogIdentifier: blogIdentifier)
        return posts.map { PostToViewModelMapper.map($0) }
    }

    /// Returns recommended blogs.
    func recommendedBlogs() async throws -> [Section] {
        let posts: [Post] = try await repository.recommendedBlogs()
        return posts.map { PostToViewModelMapper.map($0) }
    }

    /// Returns a specific post.
    func specificPost(blogId: String, postId: String) async throws -> [Section] {
        guard let post = try await repository.specificPost(blogId: blogId, postId: postId) else {
            throw HomeDomainError.noSuchPost
        }
        return [PostToViewModelMapper.map(post)]
    }

    /// Logs out the user, including removal of the access token.
    @MainActor
    func logout() throws {
        try accessTokenStore.write(nil)
        self.parentCoordinator.finish()
    }
}
