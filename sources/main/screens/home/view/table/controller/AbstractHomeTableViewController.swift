import Injection
import Kit
import os
@preconcurrency import UIKit

/**
 A table view controller minus the data source.

 **Usage**

 Subclass this to provide a regular or diffable data source implementation.
 To plug your dataSource you’ll have to edit the following:

 - Edit `viewDidLoad()` to set `tableView.dataSource`.
 - Edit `update(sections:)` to refresh the table using the snapshot API or `tableView.reloadData()`.

 **Features**

 - Register and deque home cells.
 - UITableViewDataSourcePrefetching
 - Cache estimated height using `didEndDisplaying` and `estimatedHeightForRowAt`.

 */
class AbstractHomeTableViewController: UIViewController, UITableViewDataSourcePrefetching, UITableViewDelegate {

    @Dependency var log: Logger
    @Dependency var imageDownloader: ImageDownloader

    var sections = [Section]()
    let tableView = UITableView()

    // MARK: - Initialization
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        registerCells(on: tableView)
    }

    // MARK: - UIViewController

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }

    // MARK: - Updates

    func update(sections: [Section]) {
        self.sections = sections
        resetHeightCache()
    }

    // MARK: - Register and deque cells

    private func registerCells(on tableView: UITableView) {
        [
            "audio": TableViewCell<AudioContentView>.self,
            "header": TableViewCell<HeaderView>.self,
            "image": TableViewCell<ImageContentView>.self,
            "link": TableViewCell<LinkContentView>.self,
            "notes": TableViewCell<NoteBarView>.self,
            "paywall": TableViewCell<PaywallContentView>.self,
            "rows": TableViewCell<RowsLayoutView>.self,
            "tags": TableViewCell<TextContentView>.self,
            "text": TableViewCell<TextContentView>.self,
            "video": TableViewCell<VideoContentView>.self
        ].forEach { key, type in
            tableView.register(type, forCellReuseIdentifier: key)
        }
    }

    func dequeue(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell
    {
        @MainActor func dequeue<T: Configurable>(type: TableViewCell<T>.Type, id: String) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? TableViewCell<T> else {
                (DependencyContainer.resolve() as Logger).error("Wrong cell dequeued for \(id)")
                return UITableViewCell()
            }
            let updateLayout = {
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    self.log.debug("Table layout updated.")
                }
            }
            cell.configure(item, viewport: tableView.bounds.size, updateLayout: updateLayout)
            return cell
        }

        switch item {
        case .audio: return dequeue(type: TableViewCell<AudioContentView>.self, id: "audio")
        case .header: return dequeue(type: TableViewCell<HeaderView>.self, id: "header")
        case .image: return dequeue(type: TableViewCell<ImageContentView>.self, id: "image")
        case .link: return dequeue(type: TableViewCell<LinkContentView>.self, id: "link")
        case .notes: return dequeue(type: TableViewCell<NoteBarView>.self, id: "notes")
        case .paywall: return dequeue(type: TableViewCell<PaywallContentView>.self, id: "paywall")
        case .rows: return dequeue(type: TableViewCell<RowsLayoutView>.self, id: "rows")
        case .tags: return dequeue(type: TableViewCell<TextContentView>.self, id: "tags")
        case .text: return dequeue(type: TableViewCell<TextContentView>.self, id: "text")
        case .video: return dequeue(type: TableViewCell<VideoContentView>.self, id: "video")
        }
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        Task {
            for index in indexPaths {
                switch sections[index.section].items[index.row] {
                case .image(let image):
                    if let url = image.content.media.first?.url {
                        _ = try? await imageDownloader.image(from: url)
                    }
                default: ()
                }
            }
        }
    }

    // MARK: - UITableViewDelegate

    private var cacheHeight = [IndexPath: CGFloat]()

    func resetHeightCache() {
        cacheHeight = [IndexPath: CGFloat]() /* reset calculated cell heights */
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        switch item {
        case .image:
            return ImageContentView.height(item: item, viewport: tableView.frame.size)
        case .rows:
            return RowsLayoutView.height(item: item, viewport: tableView.frame.size)
        default:
            return cacheHeight[indexPath] ?? UITableView.automaticDimension
        }
    }

//    // Using estimation allows you to defer some of the cost of geometry calculation from load time to scrolling time.
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        let item = sections[indexPath.section].items[indexPath.row]
//        if case .image = item {
//            return ImageContentView.heightForItem(item: item, viewport: tableView.frame.size)
//        }
//        return cacheHeight[indexPath] ?? UITableView.automaticDimension
//    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cacheHeight[indexPath] = cell.bounds.size.height
    }
}
