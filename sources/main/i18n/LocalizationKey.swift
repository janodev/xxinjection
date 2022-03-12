import Foundation

enum LocalizationKey: String
{
    // unspecified error
    case errorUnspecifiedHelpAnchor = "error.unspecified.helpAnchor"
    case errorUnspecifiedMessage = "error.unspecified.message"
    case errorUnspecifiedTitle = "error.unspecified.title"

    // authorization error
    case errorAuthorizationErrorDescription = "error.authorization.errorDescription"
    case errorAuthorizationFailureReason = "error.authorization.failureReason"
    case errorAuthorizationHelpAnchor = "error.authorization.helpAnchor"
    case errorAuthorizationRecoverySuggestion = "error.authorization.recoverySuggestion"

    // insecure connection error
    case errorInsecureConnectionErrorDescription = "error.insecureConnection.errorDescription"
    case errorInsecureConnectionFailureReason = "error.insecureConnection.failureReason"
    case errorInsecureConnectionHelpAnchor = "error.insecureConnection.helpAnchor"
    case errorInsecureConnectionRecoverySuggestion = "error.insecureConnection.recoverySuggestion"

    // not found (404) error
    case errorNotFoundErrorDescription = "error.notFound.errorDescription"
    case errorNotFoundFailureReason = "error.notFound.failureReason"
    case errorNotFoundHelpAnchor = "error.notFound.helpAnchor"
    case errorNotFoundRecoverySuggestion = "error.notFound.recoverySuggestion"
}
