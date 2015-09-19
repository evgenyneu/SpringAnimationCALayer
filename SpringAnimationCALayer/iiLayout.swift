//
//  iiLayout.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 2/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class iiLayout {
  class func fullWidthInParent(view: UIView) {
    view.superview?.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "|[view]|", options: [], metrics: nil,
        views: ["view": view]))
  }

  class func stackVertically(viewPrevious: UIView, viewNext: UIView, margin: Int = 0) {
    viewPrevious.superview?.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[previous]-\(margin)-[next]", options: [], metrics: nil,
        views: ["previous": viewPrevious, "next": viewNext]))
  }

  class func alignTop(view: UIView, anotherView: UIView, margin:CGFloat = 0) {
    view.superview?.addConstraint(
      NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top,
        relatedBy: NSLayoutRelation.Equal, toItem: anotherView,
        attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin))
  }

  class func alignBottom(view: UIView, anotherView: UIView, margin:CGFloat = 0) {
    view.superview?.addConstraint(
      NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom,
        relatedBy: NSLayoutRelation.Equal, toItem: anotherView,
        attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin))
  }
}
