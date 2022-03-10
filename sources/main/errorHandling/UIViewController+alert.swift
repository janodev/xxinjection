import UIKit

extension UIViewController
{
    func alert(_ error: FriendlyError) {
        present(error.alertController(),
                animated: true,
                completion: nil)
    }
}

private extension FriendlyError {
    func alertController() -> UIAlertController {
        switch self {
        case .localized(let error): return UIAlertController(error)
        case .unspecified(let error): return UIAlertController(error)
        }
    }
}

private extension UIAlertController
{
    convenience init(_ error: FriendlyError.Localized)
    {
        let title = error.errorDescription
        let message = "\(error.failureReason)\n\n\(error.recoverySuggestion)"
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let actionTitle = error.helpAnchor
        let action = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil)

        self.init(title: title,
                  message: message,
                  preferredStyle: .alert)

        addAction(action)
    }

    convenience init(_ error: FriendlyError.Unspecified)
    {
        self.init(title: localize(.errorUnspecifiedTitle),
                  message: error.localizedDescription,
                  preferredStyle: .alert)

        addAction(
            UIAlertAction(title: localize(.errorUnspecifiedHelpAnchor),
                          style: UIAlertAction.Style.default,
                          handler: nil)
        )
    }
}
