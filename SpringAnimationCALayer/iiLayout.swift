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
        "|[view]|", options: nil, metrics: nil,
        views: ["view": view]))
  }

  class func stackVertically(viewPrevious: UIView, viewNext: UIView) {
    viewPrevious.superview?.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[previous][next]", options: nil, metrics: nil,
        views: ["previous": viewPrevious, "next": viewNext]))
  }

  class func alignTop(view: UIView, anotherView: UIView) {
    view.superview?.addConstraint(
      NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top,
        relatedBy: NSLayoutRelation.Equal, toItem: anotherView,
        attribute: NSLayoutAttribute.Top, multiplier: 0, constant: 0))
  }
}
