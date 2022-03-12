import Coordinator
import Injection
import OAuth2
import os
import UIKit

@MainActor
public final class TWLoginCoordinator: Coordinating
{
    @Dependency private var log: Logger
    @Dependency private var store: OAuth2Store
    @Dependency private var configuration: OAuth2Configuration

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
        window.rootViewController = loginController()
    }

    // MARK: - Private

    /// - Returns: the login controller.
    private func loginController() -> UIViewController
    {
        let client = TeamworkOAuth2Client(configuration: configuration)
        let onLoginSuccess: (AccessTokenResponse, UIViewController) throws -> Void = { [weak self] tokenResponse, controller in

            guard let self = self else { return }
            guard tokenResponse.additionalInfo["APIEndpoint"] != nil else {
                self.log.error("""
                Error: Expected AccessTokenResponse.additionalInfo to contain a key APIEndpoint.
                The Teamwork client is expected to return this URL because it may change for each logged user.
                """)
                return
            }
            try self.store.write(tokenResponse)
            self.finish()
        }
        return LoginViewController(client: client, onSuccess: onLoginSuccess)
    }
}
