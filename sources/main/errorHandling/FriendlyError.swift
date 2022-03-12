import APIClient
import Foundation
import Injection
import Kit
import os
import UIKit

/// Human readable error.
enum FriendlyError
{
    struct Localized: LocalizedError {
        var errorDescription: String
        var failureReason: String
        var helpAnchor: String
        var recoverySuggestion: String
    }

    struct Unspecified: Error {
        var localizedDescription: String {
            localize(.errorUnspecifiedMessage)
        }
    }

    case localized(Localized)
    case unspecified(Unspecified)

    /**
     Maps errors from all layers to a user friendly error.

     Errors passed here are wrapping errors from any layer.
     Currently, only APIClientError and PersistenceError.

     Most errors are mapped to `FriendlyError.Unspecified` because they don’t
     lead the user to perform any specific action. For those that do, add here
     a translation to a friendly user error. Create your own if needed.
    */
    init(_ error: Error) {
        self = Self.map(error: error)
    }

    private static func map(error: Error) -> FriendlyError {

        switch error {

        case let apiError as APIClientError:

            if apiError.isAuthorizationError {
                return .localized(Self.authorizationError)

            } else if apiError.isNotFoundError {
                #if DEBUG
                (DependencyContainer.resolve() as Logger).error("""
                🚨 Hey, this is likely a expired cookie.
                - Open the proxy
                - Visit https://www.tumblr.com/explore/recommended-for-you
                - Copy the cookie in TumblrInjection.swift:77
                """)
                #endif
                return .localized(Self.notFoundError)

            } else if case APIClientError.SSLError = error {
                return .localized(Self.insecureConnectionError)
                
            } else {
                return .unspecified(Unspecified())
            }

        default:
            return .unspecified(Unspecified())
        }
    }
}

extension FriendlyError {

    /// The server returned a 401.
    static let authorizationError = Localized(
        errorDescription: localize(.errorAuthorizationErrorDescription),
        failureReason: localize(.errorAuthorizationFailureReason),
        helpAnchor: localize(.errorAuthorizationHelpAnchor),
        recoverySuggestion: localize(.errorAuthorizationRecoverySuggestion)
    )

    /// The server returned a 404.
    static let notFoundError = Localized(
        errorDescription: localize(.errorNotFoundErrorDescription),
        failureReason: localize(.errorNotFoundFailureReason),
        helpAnchor: localize(.errorNotFoundHelpAnchor),
        recoverySuggestion: localize(.errorNotFoundRecoverySuggestion)
    )

    /// SSL error connecting to the server.
    static let insecureConnectionError = Localized(
        errorDescription: localize(.errorInsecureConnectionErrorDescription),
        failureReason: localize(.errorInsecureConnectionFailureReason),
        helpAnchor: localize(.errorInsecureConnectionHelpAnchor),
        recoverySuggestion: localize(.errorInsecureConnectionRecoverySuggestion)
    )
}
