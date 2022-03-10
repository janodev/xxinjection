import Injection
import os
import UIKit

/// A table view controller with a diffable data source.
final class HomeDiffableTableViewController: AbstractHomeTableViewController
{
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> =
        UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item in
            self.dequeue(tableView: tableView, indexPath: indexPath, item: item)
        }

    override func update(sections: [Section])
    {
        let duplicateKeys = Set(Dictionary(grouping: sections, by: \.id).filter { $1.count > 1 }.keys)
        precondition(duplicateKeys.isEmpty)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        dataSource.defaultRowAnimation = .middle
    }
}
