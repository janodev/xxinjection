import Coordinator
import Injection
import os
import UIKit
import OAuth2

@MainActor
public final class TWHomeCoordinator: NSObject, NavigationCoordinating {

    @Dependency private var log: Logger
    @Dependency private var store: OAuth2Store

    private var window: UIWindow

    public init(parent: Coordinating, window: UIWindow) {
        self.children = []
        self.parent = parent
        self.window = window
    }

    // MARK: - NavigationCoordinator

    public let navigationController = UINavigationController()
    public var children: [Coordinating]
    public var parent: Coordinating?

    public func start() {
        log.debug("Starting...")
        let home = TWHomeViewController(parentCoordinator: self)
        navigationController.setViewControllers([home], animated: true)
        navigationController.delegate = self
        window.rootViewController = navigationController
        log.debug("Setting root to navigation controller with \(self.navigationController.viewControllers)")
    }
}
