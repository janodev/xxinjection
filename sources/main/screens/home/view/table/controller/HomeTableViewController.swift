import Injection
import os
import UIKit

/// A table view controller with a regular (non diffable) data source.
final class HomeTableViewController: AbstractHomeTableViewController, UITableViewDataSource
{
    // MARK: - Updates

    override func update(sections: [Section]) {
        super.update(sections: sections)
        tableView.reloadData()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.isEmpty ? 0 : sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        return dequeue(tableView: tableView, indexPath: indexPath, item: item)
    }
}
