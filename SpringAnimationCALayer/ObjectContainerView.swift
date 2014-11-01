//
//  ObjectContainerView.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 1/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ObjectContainerView: UIView {

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)

    let context = UIGraphicsGetCurrentContext()

    CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
    CGContextSetLineWidth(context, 1)
    CGContextMoveToPoint(context, 0, bounds.midY)
    CGContextAddLineToPoint(context, bounds.width, bounds.midY)

    CGContextStrokePath(context)
  }
}
