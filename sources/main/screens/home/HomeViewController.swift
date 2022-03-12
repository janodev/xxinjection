import APIClient
import AutoLayout
import Coordinator
import Injection
import Keychain
import Kit
import OAuth2
import os
import TumblrNPF
import UIKit

final class HomeViewController: UIViewController
{
    private let listController = HomeTableViewController()
//    private let listController = TableViewDiffableController(style: UITableView.Style.plain)

    @Dependency private var log: Logger
    @Dependency private var imageDownloader: ImageDownloader
    private let domain: HomeDomain

    var _output: ((HomeEvent) -> Void)?

    // MARK: - UIViewController

    init(domain: HomeDomain) {
        self.domain = domain
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output?(.viewDidAppear)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        false
    }

    // MARK: - Other

    private func setupUI() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))

        title = "Home"
        view.backgroundColor = .white

        listController.view.backgroundColor = .white
        addNestedController(listController)
        listController.view.al.pin()
    }

    // MARK: - Domain calls

    @objc
    private func logout() {
        output?(.logoutRequested)
    }

    func update(sections: [Section]) {
        listController.update(sections: sections)
    }
}
