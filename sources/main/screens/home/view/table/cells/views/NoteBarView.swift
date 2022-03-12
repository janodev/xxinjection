import os
import UIKit

final class NoteBarView: UIView, Configurable
{
    private let noteLabel = UILabel()
    private let iconShare = NoteBarView.createButton(systemName: "square.and.arrow.up") { _ in print("Share") }
    private let iconComment = NoteBarView.createButton(systemName: "message") { _ in print("Comment") }
    private let iconReblog = NoteBarView.createButton(systemName: "repeat") { _ in print("Reblog") }
    private let iconTrash = NoteBarView.createButton(systemName: "trash") { _ in print("Trash") }
    private let iconWrite = NoteBarView.createButton(systemName: "pencil") { _ in print("Write") }

    private static func createButton(systemName: String, action: @escaping (UIAction) -> Void) -> UIButton {
        UIButton(
            configuration: .plain(),
            primaryAction: UIAction(handler: action)
        ).configure {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: systemName)
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
            config.buttonSize = .small
            $0.configuration = config
        }
    }

    private let log = Logger(subsystem: "dev.jano", category: "NoteBarViewCell")

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        layout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }

    private func layout()
    {
        backgroundColor = .white
        let views = [
            "iconComment": iconComment,
            "iconReblog": iconReblog,
            "iconShare": iconShare,
            "iconTrash": iconTrash,
            "iconWrite": iconWrite,
            "noteLabel": noteLabel
        ]
        views.values.forEach {
            addSubview($0)
            $0.al.centerY()
        }
        al.applyVFL([
            "H:|-12-[noteLabel]-(>=16)-[iconShare][iconComment][iconReblog][iconTrash][iconWrite]-6-|"
        ], views: views)
        heightAnchor.constraint(equalToConstant: 44).configure {
            $0.priority = .defaultHigh
            $0.isActive = true
        }
    }

    func configure(_ item: Item, viewport: CGSize, updateLayout: @MainActor () -> Void) {
        guard case .notes(let notes) = item else {
            log.error("🚨Wrong item type!, expected .notes(Int), got \(String(describing: item))")
            return
        }
        configure(notes: notes)
    }
    
    func configure(notes: ViewModel<Int>) {
        noteLabel.text = "\(notes.content) Notes"
    }
}
