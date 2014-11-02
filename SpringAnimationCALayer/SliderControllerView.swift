//
//  SliderControllerView.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 2/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class SliderControllerView: UIView {
  let name: String!
  let caption: UILabel!

  init(name: String, defaults: SliderDefaults) {
    super.init()
    self.name = name

    caption = UILabel()
    configureLabel()

    let slider = UISlider()
//    configureSlider(slider)
  }

  private func configureLabel() {
    caption.setTranslatesAutoresizingMaskIntoConstraints(false)
    caption.text = name
    addSubview(caption)

    SliderControllerView.positionCaption(caption, superview: self)
  }

  private func configureSlider(slider: UISlider) {
    caption.setTranslatesAutoresizingMaskIntoConstraints(false)
    addSubview(slider)

    SliderControllerView.positionSlider(caption, slider: slider, superview: self)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private class func positionCaption(label: UIView, superview: UIView) {
    iiLayout.alignTop(label, anotherView: superview)
    iiLayout.fullWidthInParent(label)
  }

  private class func positionSlider(caption: UIView, slider: UIView, superview: UIView) {
    iiLayout.fullWidthInParent(slider)
    iiLayout.stackVertically(caption, viewNext: slider)
  }
}
