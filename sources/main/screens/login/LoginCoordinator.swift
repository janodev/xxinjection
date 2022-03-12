import Coordinator
import Injection
import Keychain
import OAuth2
import os
import UIKit

@MainActor
public final class LoginCoordinator: Coordinating
{
    @Dependency private var log: Logger
    @Dependency private var oauth2Store: OAuth2Store
    @Dependency private var oauthClient: OAuth2Client
    
    var window: UIWindow

    public init(parent: Coordinating, window: UIWindow) {
        self.children = []
        self.parent = parent
        self.window = window
    }

    // MARK: - Coordinator

    public var children: [Coordinating]
    public var parent: Coordinating?

    public func start() {
        log.debug("Starting LoginCoordinator...")
        window.rootViewController = LoginViewController(client: oauthClient) { [weak self] response, _ /*controller*/ in
            self?.finish()
            try self?.oauth2Store.write(response)
        }
    }
}
