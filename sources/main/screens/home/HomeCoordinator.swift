import APIClient
import Coordinator
import Injection
import Keychain
import OAuth2
import os
import UIKit

@MainActor
final class HomeCoordinator: NSObject, NavigationCoordinating
{
    @Dependency private var accessTokenStore: OAuth2Store
    @Dependency private var log: Logger
    @Dependency private var tumblrClient: TumblrAPI

    // MARK: - Initialization

    init(parent: Coordinating, window: UIWindow) {
        self.children = []
        self.parent = parent
        self.window = window
    }

    // MARK: - Coordinator

    private var window: UIWindow

    // MARK: - NavigationCoordinator

    let navigationController = UINavigationController()
    var children: [Coordinating]
    var parent: Coordinating?

    func start() {
        log.debug("Starting HomeCoordinator...")
        var domain = HomeDomain(parentCoordinator: self)
        let controller = HomeViewController(domain: domain)
        controller.output = { domain.input($0) }
        domain.output = { output in
            DispatchQueue.main.async {
                controller.input(output)
            }
        }
        navigationController.setViewControllers([controller], animated: true)

        log.debug("New window root is navigation controller with \(self.navigationController.viewControllers)")
        window.rootViewController = navigationController
    }
}
