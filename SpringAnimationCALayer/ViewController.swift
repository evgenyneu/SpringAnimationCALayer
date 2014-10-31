//
//  ViewController.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 1/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var controlsContainer: UIView!
  @IBOutlet weak var viewOneContainer: UIView!

  let objectSize: CGFloat = 50

  // Duration
  @IBOutlet weak var durationContainer: UIView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var durationSlider: UISlider!
  let durationSliderDefaults = SliderDefaults(value: 2, minimumValue: 0.01, maximumValue: 5.0)

  // Damping
  @IBOutlet weak var dampingContainer: UIView!
  @IBOutlet weak var dampingLabel: UILabel!
  @IBOutlet weak var dampingSlider: UISlider!
  let dampingSliderDefaults = SliderDefaults(value: 0.3, minimumValue: 0.01, maximumValue: 5.0)

  // Initial velocity
  @IBOutlet weak var initialVelocityContainer: UIView!
  @IBOutlet weak var initialVelocityLabel: UILabel!
  @IBOutlet weak var initialVelocitySlider: UISlider!
  let initialVelocutySliderDefaults = SliderDefaults(value: 5.0, minimumValue: 0.01, maximumValue: 10.0)


  var objectOne: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    controlsContainer.backgroundColor = nil
    viewOneContainer.backgroundColor = nil
    durationContainer.backgroundColor = nil
    dampingContainer.backgroundColor = nil
    initialVelocityContainer.backgroundColor = nil

    objectOne = UIView(frame: CGRect(origin: CGPoint(),
      size: CGSize(width: objectSize, height: objectSize)))

    objectOne.backgroundColor = UIColor.blueColor()
    viewOneContainer.addSubview(objectOne)

    // Duration
    SliderDefaults.set(durationSlider, defaults: durationSliderDefaults)
    onDurationSliderChanged(durationSlider)

    // Damping
    SliderDefaults.set(dampingSlider, defaults: dampingSliderDefaults)
    onDampingSliderChanged(dampingSlider)

    // Initial velocity
    SliderDefaults.set(initialVelocitySlider, defaults: initialVelocutySliderDefaults)
    onInitialVelocitySliderChanged(initialVelocitySlider)
  }

  func animate() {
    objectOne.frame.origin = CGPoint(x: 0, y: 0)

    UIView.animateWithDuration(NSTimeInterval(durationSlider.value),
      delay: 0,
      usingSpringWithDamping: CGFloat(dampingSlider.value),
      initialSpringVelocity: CGFloat(initialVelocitySlider.value),
      options: nil,
      animations: {
        let newCenterY = self.viewOneContainer.bounds.height / 2
        self.objectOne.frame.origin = CGPoint(x: 0, y: newCenterY)
      },
      completion: nil)
  }

  @IBAction func onGoTapped(sender: AnyObject) {
    animate()
  }

  @IBAction func durationSliderChangeEnd(sender: AnyObject) {
    animate()
  }

  @IBAction func onDurationSliderChanged(sender: AnyObject) {
    if let slider = sender as? UISlider {
      updateSliderLabel(slider, label: durationLabel, caption: "Duration")
    }
  }

  @IBAction func onDampingSliderChanged(sender: AnyObject) {
    if let slider = sender as? UISlider {
      updateSliderLabel(slider, label: dampingLabel, caption: "Damping")
    }
  }

  @IBAction func onInitialVelocitySliderChanged(sender: AnyObject) {
    if let slider = sender as? UISlider {
      updateSliderLabel(slider, label: initialVelocityLabel, caption: "Initial velocity")
    }
  }


  func updateSliderLabel(slider: UISlider, label: UILabel, caption: String) {
    label.text = "\(caption): \(formatValue(slider.value))"
  }

  func formatValue(value: Float) -> String {
    return String(format: "%.2f", value)
  }
}

