import UIKit

class iiLayout {
  class func fullWidthInParent(_ view: UIView) {
    view.superview?.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "|[view]|", options: [], metrics: nil,
        views: ["view": view]))
  }

  class func stackVertically(_ viewPrevious: UIView, viewNext: UIView, margin: Int = 0) {
    viewPrevious.superview?.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:[previous]-\(margin)-[next]", options: [], metrics: nil,
        views: ["previous": viewPrevious, "next": viewNext]))
  }

  class func alignTop(_ view: UIView, anotherView: UIView, margin:CGFloat = 0) {
    view.superview?.addConstraint(
      NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top,
        relatedBy: NSLayoutRelation.equal, toItem: anotherView,
        attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin))
  }

  class func alignBottom(_ view: UIView, anotherView: UIView, margin:CGFloat = 0) {
    view.superview?.addConstraint(
      NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom,
        relatedBy: NSLayoutRelation.equal, toItem: anotherView,
        attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: margin))
  }
}
