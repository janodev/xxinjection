import UIKit

public extension UIViewController
{
    /// Add nested view controller to the given controller.
    func addNestedController(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Remove nested view controller from parent.
    func removeFromParentController() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
