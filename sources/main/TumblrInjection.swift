import APIClient
import Coordinator
import CoreDataStack
import Foundation
import Injection
import Kit
import OAuth2
import os
import TumblrNPFPersistence

/**
 A value object that configures the application to access Tumblr.
 */
public struct TumblrInjection {

    private let log = Logger(subsystem: "dev.jano", category: "app")

    public init() {}

    /// Injects dependencies to configure the application to access Teamwork.com.
    public func injectDependencies(configuration: OAuth2Configuration) {
        log.debug("Configuring for Tumblr")

        DependencyContainer.register(log)
        DependencyContainer.register(configuration)
        let rootCoordinatorFactory = RootCoordinatorFactory(createRootCoordinator: { window in
            MainCoordinator(window: window)
        })

        let oauth2Client = OAuth2Client(configuration: configuration)
        let oAuth2Store = OAuth2Store(account: "tumblr")
        let delegate = authorizationDelegate(tokenResponse: try? oAuth2Store.read())
        let tumblrAPI = TumblrAPI(delegate: delegate)

        let persistence = PersistentContainer(name: "DataModel", inMemory: false, bundle: BundleReference.bundle)

        DependencyContainer.register(persistence)
        DependencyContainer.register(ImageDownloader.shared)
        DependencyContainer.register(oAuth2Store)
        DependencyContainer.register(oauth2Client)
        DependencyContainer.register(tumblrAPI)
        DependencyContainer.register(rootCoordinatorFactory)

        // reset
        // persistence.wipeSQLDatabase()
        // URLSession.shared.configuration.httpCookieStorage?.removeCookies(since: Date(timeIntervalSince1970: 0))

        // Load persistence store
        persistence.loadPersistentStores { desc, error in
            log.debug("Initialized persistent store: \(desc)")
            guard let error = error else { return }
            fatalError("Error loading persistent stores: \(String(describing: error))")
        }

        // observe changes in authentication state
        oAuth2Store.observeTokenChanges { accessToken in
            log.debug("Credentials changed.")
            let delegate = self.authorizationDelegate(tokenResponse: accessToken)
            (DependencyContainer.resolve() as TumblrAPI).delegate = delegate
        }
    }

    private func createConfiguration(filename: String) -> OAuth2Configuration? {
        guard let configuration = try? OAuth2Configuration.createFrom(filename: filename) else {
            log.error("🚨Missing or invalid configuration file: \(filename)")
            return nil
        }
        return configuration
    }

    private func authorizationDelegate(tokenResponse: AccessTokenResponse?) -> HeaderInjectionDelegate?
    {
        tokenResponse.flatMap {
            HeaderInjectionDelegate(headers: [
                "Authorization": "Bearer \($0.accessToken)",
                // swiftlint:disable:next line_length
                "Cookie": "palette=trueBlue; tz=Europe%2FMadrid; euconsent-v2-noniab=AAVE; __ATA_tuuid=6c872845-9208-475c-a4a5-74f55fb74827; euconsent=BOOoLX0OOoLX0AOPoGENAT-AAAAJ9CMAfQqQQoTB8nRlVABaIhoAgQAQ; redpop=1; euconsent-v2=CPPHc-qPPHepFECABAENBzCgAPLAAHLAAKiQIUtf_X__bX9n-_79__t0eY1f9_r3v-QzjhfNt-8F2L_W_L0X_2E7NF36pq4KuR4ku3bBIQNtHMnUTUmxaolVrzHsakWcpyNKJ7LkmnsZe2dYGHtPn9lT-ZKZ7_7___f73z___9_-39z3_9X___d_____-_____9____________9_______-CFIBJhqXkAXZljgybRpVCiBGFYSFQCgAooBhaIrABgcFOysAj1BCwAQmoCMCIEGIKMGAQACCQBIREBIAWCARAEQCAAEAKEBCAAiYBBYAWBgEAAoBoWIEUAQgSEGRwVHKYEBUi0UEtlYAlBVsaYQBlvgRQKP6KjARrNECwMhIWDmOAJAS8WSBgAAA; language=%2Cen_US; pfu=325042232; tmgioct=61ff029dd202690662382190; pfg=a72ba9c1df8b3bcd3289b994cb66cd6fb502dac1acbb5fa4b48d5f585e12689b%23%7B%22eu_resident%22%3A1%2C%22gdpr_is_acceptable_age%22%3A1%2C%22gdpr_consent_core%22%3A1%2C%22gdpr_consent_first_party_ads%22%3A1%2C%22gdpr_consent_search_history%22%3A1%2C%22exp%22%3A1677518360%2C%22vc%22%3A%22%22%7D%235843211891; logged_in=1; sid=aBWiENWB6lExEDXno911j77fXZ7rHy12BaWaLAQXnoP4ZaDqbJ.ajjnjgdSjJOLmLvU1nmfZXNRBeEMttNvyNb6WIyIBWD89BV4Dm; search-displayMode=2"
            ])
        }
    }
}
