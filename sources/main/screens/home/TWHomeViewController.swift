import AutoLayout
import Coordinator
import Injection
import Kit
import OAuth2
import os
import UIKit

enum TWError: Error {
    case expectedNonEmptyResponse
    var localizedDescription: String {
        switch self {
        case .expectedNonEmptyResponse: return "Expected a non empty response"
        }
    }
}

final class TWHomeViewController: UIViewController
{
    @Dependency var log: Logger
    @Dependency var apiClient: TWAPIClient
    @Dependency var store: OAuth2Store

    private let textView = UITextView()
    private let parentCoordinator: Coordinating

    init(parentCoordinator: Coordinating) {
        self.parentCoordinator = parentCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestProtectedResource()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        false
    }

    private func setupUI() {
        view.addSubview(textView)
        textView.al.pinToSafeArea()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        title = "Home"
    }

    @objc
    private func logout() throws {
        try store.write(nil)
        parentCoordinator.finish()
    }

    private func requestProtectedResource() {
        textView.text = "Loading protected resource..."
        SafeTask { [textView] in
            var text = ""
            do {
                let profileResponse: ProfileResponse = try await apiClient.me()
                text = String(describing: profileResponse)
            } catch {
                text = "Error: \(error)"
            }
            await MainActor.run { [text] in
                textView.text = text
            }
        }
    }
}

