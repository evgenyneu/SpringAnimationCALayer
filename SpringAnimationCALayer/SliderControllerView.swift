//
//  SliderControllerView.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 2/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class SliderControllerView: UIView {
  private var type: ControlType!
  private var label: UILabel!
  private var slider: UISlider!
  private var delegate: SliderControllerDelegate!
  
  func setup(type: ControlType, defaults: SliderDefaults, delegate: SliderControllerDelegate) {
    self.type = type
    self.delegate = delegate
    
    translatesAutoresizingMaskIntoConstraints = false
    
    label = UILabel()
    configureLabel()
    
    slider = UISlider()
    
    configureSlider(slider)
    
    SliderDefaults.set(slider, defaults: defaults)
    SliderControllerView.updateSliderLabel(slider, label: label, caption: type.rawValue)
  }

  var value: Float {
    return slider.value
  }

  private func configureLabel() {
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)

    SliderControllerView.positionLabel(label, superview: self)
  }

  private class func positionLabel(label: UIView, superview: UIView) {
    iiLayout.alignTop(label, anotherView: superview)
    iiLayout.fullWidthInParent(label)
  }

  private func configureSlider(slider: UISlider) {
    slider.translatesAutoresizingMaskIntoConstraints = false
    addSubview(slider)

    slider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)

    slider.addTarget(self, action: "sliderChangeEnded:", forControlEvents: UIControlEvents.TouchUpInside)


    SliderControllerView.positionSlider(label, slider: slider, superview: self)
  }

  func sliderChanged(slider: UISlider) {
    SliderControllerView.updateSliderLabel(slider, label: label, caption: type.rawValue)
  }

  func sliderChangeEnded(slider: UISlider) {
    delegate.sliderControllerDelegate_OnChangeEnded()
  }

  private class func updateSliderLabel(slider: UISlider, label: UILabel, caption: String) {
    label.text = "\(caption): \(formatValue(slider.value))"
  }

  private class func positionSlider(caption: UIView, slider: UIView, superview: UIView) {
    iiLayout.fullWidthInParent(slider)
    iiLayout.stackVertically(caption, viewNext: slider, margin: 3)
    iiLayout.alignBottom(slider, anotherView: superview)
  }

  private class func formatValue(value: Float) -> String {
    return String(format: "%.3f", value)
  }
}
