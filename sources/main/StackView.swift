import UIKit

public final class StackView: UIStackView
{
    private var color: UIColor?

    public override var backgroundColor: UIColor? {
        get { color }
        set {
            color = newValue
            setNeedsLayout()
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = backgroundColor?.cgColor
    }
}
