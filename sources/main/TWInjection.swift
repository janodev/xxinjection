import APIClient
import Coordinator
import Foundation
import Injection
import OAuth2
import os

/**
 A value object that configures the application to access Teamwork.com.
 */
public struct TWInjection {

    private let log = Logger(subsystem: "dev.jano", category: "app")

    public init() {}
    
    /// Injects dependencies to configure the application to access Teamwork.com.
    public func injectDependencies(configuration: OAuth2Configuration) {
        log.debug("Configuring for Teamwork")

        let store = OAuth2Store(account: "teamwork")
        let oauth2Client = createOAuth2Client(filename: "teamwork.plist")
        let teamworkAPI = createTeamworkAPI(store: store)
        let rootCoordinatorFactory = RootCoordinatorFactory(createRootCoordinator: { window in
            TWMainCoordinator(window: window)
        })

        DependencyContainer.register(configuration)
        DependencyContainer.register(log)
        DependencyContainer.register(oauth2Client)
        DependencyContainer.register(teamworkAPI)
        DependencyContainer.register(rootCoordinatorFactory)
        DependencyContainer.register(store)

        store.observeTokenChanges { accessToken in
            log.debug("Credentials changed.")
            let teamworkAPI: TWAPIClient? = createTeamworkAPI(store: store)
            DependencyContainer.register(teamworkAPI)
        }
    }

    /*
     Returns an instance of the OAuth2 client configured with the given file.
     - Parameter filename: Filename of a plist with the needed parameters.
     - Returns: The OAuth2 client or nil if the configuration file is invalid.
     */
    private func createOAuth2Client(filename: String) -> OAuth2Client? {
        guard let configuration = try? OAuth2Configuration.createFrom(filename: filename) else {
            log.error("🚨Missing or invalid configuration file: \(filename)")
            return nil
        }
        return TeamworkOAuth2Client(configuration: configuration)
    }

    /*
     Returns the Teamwork API client, or nil if there is no access token available.
     - Parameter store: Store containing the access token.
     - Returns The API client or nil.
     */
    private func createTeamworkAPI(store: OAuth2Store) -> TWAPIClient? {
        guard
            let accessTokenResponse = try? store.read(),
            let apiEndpoint = accessTokenResponse.additionalInfo["APIEndpoint"],
            let apiEndpointURL = URL(string: apiEndpoint)
        else {
            return nil
        }
        return TWAPIClient(
            baseURL: apiEndpointURL,
            delegate: HeaderInjectionDelegate(headers: [
                "Authorization": "Bearer \(accessTokenResponse.accessToken)"
            ])
        )
    }
}
