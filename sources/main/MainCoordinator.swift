import Coordinator
import Injection
import Keychain
import OAuth2
import os
import UIKit

@MainActor
final class MainCoordinator: RootCoordinating
{
    // MARK: - Dependencies

    @Dependency private var log: Logger
    @Dependency private var oauth2Store: OAuth2Store

    // MARK: - Initialization

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - RootCoordinator

    var window: UIWindow

    // MARK: - Coordinator

    var children = [Coordinating]() {
        didSet {
            if children.isEmpty {
                log.debug("No children left. Calling start() again")
                start()
            }
        }
    }

    var parent: Coordinating?

    func start()
    {
        let isAuthorized = (try? oauth2Store.read() != nil) ?? false
        log.debug("Token response in store? \(isAuthorized ? "yes" : "no")")
        children = isAuthorized
            ? [HomeCoordinator(parent: self, window: window)]
            : [LoginCoordinator(parent: self, window: window)]
        log.debug("Starting \(self.debugDescription)")
        children.first?.start()
    }

    func finish() { /* never ends */ }
}
