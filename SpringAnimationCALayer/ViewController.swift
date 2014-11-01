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
  let objectMargin: CGFloat = 10

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

  // Damping multiplier
  @IBOutlet weak var dampingMultiplierContains: UIView!
  @IBOutlet weak var dampingMultiplierLabel: UILabel!
  @IBOutlet weak var dampingMultiplierSlider: UISlider!
  let dampingMultiplierSliderDefaults = SliderDefaults(value: 18, minimumValue: 15, maximumValue: 25)

  // Velocity multiplier
  @IBOutlet weak var velocityMultiplierContains: UIView!
  @IBOutlet weak var velocityMultiplierLabel: UILabel!
  @IBOutlet weak var velocityMultiplierSlider: UISlider!
  let velocityMultiplierSliderDefaults = SliderDefaults(value: 3.5, minimumValue: 2, maximumValue: 7)


  var objectOne: UIView!
  var objectTwo: UIView!


  override func viewDidLoad() {
    super.viewDidLoad()

    removeBackgroundColor()

    createObjectOne()
    createObjectTwo()

    // Duration
    SliderDefaults.set(durationSlider, defaults: durationSliderDefaults)
    onDurationSliderChanged(durationSlider)

    // Damping
    SliderDefaults.set(dampingSlider, defaults: dampingSliderDefaults)
    onDampingSliderChanged(dampingSlider)

    // Initial velocity
    SliderDefaults.set(initialVelocitySlider, defaults: initialVelocutySliderDefaults)
    onInitialVelocitySliderChanged(initialVelocitySlider)

    // Damping multiplier
    SliderDefaults.set(dampingMultiplierSlider, defaults: dampingMultiplierSliderDefaults)
    onDampingMultiplierSliderChanged(dampingMultiplierSlider)

    // Velocity multiplier
    SliderDefaults.set(velocityMultiplierSlider, defaults: velocityMultiplierSliderDefaults)
    onVelocityMultiplierSliderChanged(velocityMultiplierSlider)
  }

  private func createObjectOne() {
    objectOne = UIView(frame: CGRect(origin: CGPoint(),
      size: CGSize(width: objectSize, height: objectSize)))
    objectOne.backgroundColor = UIColor.blueColor()
    viewOneContainer.addSubview(objectOne)
  }

  private func createObjectTwo() {
    objectTwo = UIView(frame: CGRect(origin: CGPoint(x: objectSize + objectMargin, y: 0),
      size: CGSize(width: objectSize, height: objectSize)))
    objectTwo.backgroundColor = UIColor.blueColor()
    viewOneContainer.addSubview(objectTwo)
    objectTwo.layer.anchorPoint = CGPoint(x: 0, y: 0)
    resetObjectTwoPosition()
  }

  private func resetObjectTwoPosition() {
    setObjectTwoPosition(0)
  }

  private func setObjectTwoPosition(yPosition: CGFloat) {
    objectTwo.layer.position = CGPoint(x: objectSize + objectMargin, y: yPosition)
  }

  private func removeBackgroundColor() {
    controlsContainer.backgroundColor = nil
    viewOneContainer.backgroundColor = nil
    durationContainer.backgroundColor = nil
    dampingContainer.backgroundColor = nil
    initialVelocityContainer.backgroundColor = nil
    dampingMultiplierContains.backgroundColor = nil
    velocityMultiplierContains.backgroundColor = nil
  }

  private func animate() {
    animateObjectOne()
    animateObjectTwo()
  }

  private func animateObjectOne() {
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

  private func animateObjectTwo() {
    setObjectTwoPosition(viewOneContainer.bounds.height / 2)

    let dampingMultiplier = Double(dampingMultiplierSlider.value)
    let velocityMultiplier = Double(velocityMultiplierSlider.value)


    let values = springValues(0, toValue: Double(viewOneContainer.bounds.height / 2),
      damping: dampingMultiplier * Double(dampingSlider.value),
      initialVelocity: velocityMultiplier * Double(initialVelocitySlider.value))

    let animation = CAKeyframeAnimation(keyPath: "position.y")
    animation.values = values
    animation.duration = CFTimeInterval(durationSlider.value)
    objectTwo.layer.addAnimation(animation, forKey: "mySpringAnimation")
  }

  private func springValues(fromValue: Double, toValue: Double,
    damping: Double, initialVelocity: Double) -> [Double]{

    let numOfPoints = 100
    var values = [Double](count: numOfPoints, repeatedValue: 0.0)

    let distanceBetweenValues = toValue - fromValue

    for point in (0..<numOfPoints) {
      let x = Double(point) / Double(numOfPoints)
      let valueNormalized = springValueNormalized(x, damping: damping, initialVelocity: initialVelocity)

      let value = toValue - distanceBetweenValues * valueNormalized
      values[point] = value
    }

    return values
  }

  private func springValueNormalized(x: Double, damping: Double, initialVelocity: Double) -> Double {
    return pow(M_E, -damping * x) * cos(initialVelocity * x)
  }

  @IBAction func onGoTapped(sender: AnyObject) {
    animate()
  }

  @IBAction func onSliderChangeEnd(sender: AnyObject) {
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

  @IBAction func onDampingMultiplierSliderChanged(sender: AnyObject) {
    if let slider = sender as? UISlider {
      updateSliderLabel(slider, label: dampingMultiplierLabel, caption: "Damping multiplier")
    }
  }

  @IBAction func onVelocityMultiplierSliderChanged(sender: AnyObject) {
    if let slider = sender as? UISlider {
      updateSliderLabel(slider, label: velocityMultiplierLabel, caption: "Velocity multiplier")
    }
  }

  private func updateSliderLabel(slider: UISlider, label: UILabel, caption: String) {
    label.text = "\(caption): \(formatValue(slider.value))"
  }

  private func formatValue(value: Float) -> String {
    return String(format: "%.2f", value)
  }
}

