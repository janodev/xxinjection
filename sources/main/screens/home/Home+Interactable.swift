import Injection
import Kit
import os

// This file defines the interaction between view and domain.

enum HomeEvent {
    case viewDidAppear
    case logoutRequested
}

enum HomeUpdate: Sendable {
    case sections([Section])
    case error(FriendlyError)
}

extension HomeViewController: Interactable {

    var output: ((HomeEvent) -> Void)? {
        get { _output }
        set { _output = newValue }
    }

    func input(_ input: HomeUpdate) {
        switch input {
        case .sections(let sections):
            update(sections: sections)
        case .error(let error):
            alert(error)
        }
    }
}

extension HomeDomain: Interactable {

    private var log: Logger {
        DependencyContainer.resolve() as Logger
    }

    var output: ((HomeUpdate) -> Void)? {
        get { _output }
        set { _output = newValue }
    }

    func input(_ input: HomeEvent) {
        SafeTask {
            do {
                switch input {
                case .logoutRequested:
                    try await logout()
                case .viewDidAppear:

                    try await output?(
                        .sections(
                            posts(blogIdentifier: "swift-index")
                        )
                    )
                    // try await output?(.sections(recommendedBlogs()))
                    // try await output?(.sections(twoPostsWithBigImages()))
                    // try await output?(.sections(onePostsWithBigImages()))
                    // try await output?(.sections(oneRowTwoImages()))
                }
            } catch {
                self.log.error("🚨Event \(String(describing: input)) caught error \(String(describing: error))")
                output?(.error(FriendlyError(error)))
            }
        }
    }

    // MARK: - test data

    private func oneRowTwoImages() async throws -> [Section] {
        try await specificPost(blogId: "jano-dev.tumblr.com", postId: "674481990064537600")
    }

    private func complexLayout() async throws -> [Section] {
        try await specificPost(blogId: "truegritters.tumblr.com", postId: "673027028686192640")
    }

    /**
     One post with an image and caption: typewolf - PrimaHealth Credit.
     */
    private func postWithImageAndCaption() async throws -> [Section] {
        try await specificPost(blogId: "t:oQXghcpnjixHmoDNWjpCyA", postId: "674284877087227904")
    }

    /// One posts with big images: digitalchase - 2022 background.
    private func onePostsWithBigImages() async throws -> [Section] {
        try await specificPost(blogId: "t:7v0fkuPhjEa_pPdyh2r35w", postId: "671737882090815488")
    }

    /**
     Two posts with big images.
     - designmatazz - walston wine club
     - digitalchase - 2022 background
     */
    private func twoPostsWithBigImages() async throws -> [Section] {
        let designmatazz = try await specificPost(blogId: "t:WrW_l1m1h6EPTeG4x4GBgA", postId: "672940858171113472")
        let digitalchase = try await specificPost(blogId: "t:7v0fkuPhjEa_pPdyh2r35w", postId: "671737882090815488")
        return designmatazz + digitalchase
    }
}
