import UIKit

struct ViewModel<Content>: Identifiable, Hashable
{
    let id: String
    let content: Content

    // MARK: -

    static func == (lhs: ViewModel<Content>, rhs: ViewModel<Content>) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
