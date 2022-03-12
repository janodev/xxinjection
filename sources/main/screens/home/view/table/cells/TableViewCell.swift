import UIKit

typealias TableViewCellView = UIView & Configurable

final class TableViewCell<C: TableViewCellView>: UITableViewCell, Identifiable, Configurable
{
    private let cellView = C()

    // MARK: - Identifiable
    var id = UUID()

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurable

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor @escaping () -> Void) {
        cellView.configure(item, viewport: viewport, updateLayout: updateLayout)
    }

    // MARK: - Layout

    private func layout() {
        contentView.addSubview(cellView)
        if cellView is ManualLayout {
            return
        } else {
            cellView.al.pin()
        }
    }
}
