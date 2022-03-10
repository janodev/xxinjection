import Coordinator
import Injection
import os
import UIKit
import OAuth2

@MainActor
public final class TWMainCoordinator: RootCoordinating
{
    @Dependency private var log: Logger
    @Dependency private var store: OAuth2Store

    // MARK: - Coordinator

    public var children = [Coordinating]() {
        didSet {
            if children.isEmpty {
                log.debug("No children left. Calling start() again")
                start()
            }
        }
    }

    public var parent: Coordinating?

    public func start()
    {
        log.debug("Starting \(String(describing: self))")
        guard let child = try? initialCoordinator() else {
            log.debug("Can’t start. The initial coordinator is not ready.")
            return
        }
        children = [child]
        child.start()
    }

    public func finish() { /* never ends */ }

    // MARK: - RootCoordinator

    public var window: UIWindow

    // MARK: - Other

    private func accessToken() throws -> AccessTokenResponse? {
        try store.read()
    }

    private func initialCoordinator() throws -> Coordinating? {
        guard DependencyContainer.isRegistered(TWAPIClient.self) else {
            log.debug("TeamworkAPI is not registered. Loading login coordinator.")
            return TWLoginCoordinator(parent: self, window: window)
        }
        guard try accessToken() != nil else {
            log.debug("Missing access token. Loading login coordinator.")
            return TWLoginCoordinator(parent: self, window: window)
        }
        log.debug("Credentials found. Loading home coordinator.")
        return TWHomeCoordinator(parent: self, window: window)
    }

    public init(window: UIWindow) {
        self.window = window
    }
}
