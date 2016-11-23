import UIKit

class ObjectContainerView: UIView {

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let context = UIGraphicsGetCurrentContext()

    context?.setStrokeColor(UIColor.gray.cgColor)
    context?.setLineWidth(1)
    context?.move(to: CGPoint(x: 0, y: bounds.midY))
    context?.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))

    context?.strokePath()
  }
}
