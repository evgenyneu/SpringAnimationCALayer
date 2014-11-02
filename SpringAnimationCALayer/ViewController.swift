//
//  ViewController.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 1/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SliderControllerDelegate {
  @IBOutlet weak var controlsContainer: UIView!
  @IBOutlet weak var objectsContainer: UIView!

  let objectSize: CGFloat = 50
  let objectMargin: CGFloat = 10

  private let controlsData = [
    ControlData(
      name: "Duration",
      defaults: SliderDefaults(value: 3, minimumValue: 0.01, maximumValue: 5.0)
    ),
    ControlData(
      name: "Damping",
      defaults: SliderDefaults(value: 0.1, minimumValue: 0.01, maximumValue: 0.6)
    ),
    ControlData(
      name: "Initial velocity",
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10.0)
    )
  ]

//  // Duration
//  @IBOutlet weak var durationContainer: UIView!
//  @IBOutlet weak var durationLabel: UILabel!
//  @IBOutlet weak var durationSlider: UISlider!
//  let durationSliderDefaults = SliderDefaults(value: 3, minimumValue: 0.01, maximumValue: 5.0)
//
//  // Damping
//  @IBOutlet weak var dampingContainer: UIView!
//  @IBOutlet weak var dampingLabel: UILabel!
//  @IBOutlet weak var dampingSlider: UISlider!
//  let dampingSliderDefaults = SliderDefaults(value: 0.1, minimumValue: 0.01, maximumValue: 0.6)
//
//  // Initial velocity
//  @IBOutlet weak var initialVelocityContainer: UIView!
//  @IBOutlet weak var initialVelocityLabel: UILabel!
//  @IBOutlet weak var initialVelocitySlider: UISlider!
//  let initialVelocutySliderDefaults = SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10.0)
//
//  // Damping multiplier
//  @IBOutlet weak var dampingMultiplierContains: UIView!
//  @IBOutlet weak var dampingMultiplierLabel: UILabel!
//  @IBOutlet weak var dampingMultiplierSlider: UISlider!
//  let dampingMultiplierSliderDefaults = SliderDefaults(value: 9.5, minimumValue: 9.4, maximumValue: 9.6)
//
//  // Velocity multiplier
//  @IBOutlet weak var velocityMultiplierContains: UIView!
//  @IBOutlet weak var velocityMultiplierLabel: UILabel!
//  @IBOutlet weak var velocityMultiplierSlider: UISlider!
//  let velocityMultiplierSliderDefaults = SliderDefaults(value: 9.2, minimumValue: 7, maximumValue: 12)
//
//  // A
//  @IBOutlet weak var aMultiplierContains: UIView!
//  @IBOutlet weak var aMultiplierLabel: UILabel!
//  @IBOutlet weak var aMultiplierSlider: UISlider!
//  let aMultiplierSliderDefaults = SliderDefaults(value: 10, minimumValue: 5, maximumValue: 100)


  var objectOne: UIView!
  var objectTwo: UIView!


  override func viewDidLoad() {
    super.viewDidLoad()

    removeBackgroundColor()

    createObjectOne()
    createObjectTwo()

    createControls()

    // Duration
//    SliderDefaults.set(durationSlider, defaults: durationSliderDefaults)
//    onDurationSliderChanged(durationSlider)
//
//    // Damping
//    SliderDefaults.set(dampingSlider, defaults: dampingSliderDefaults)
//    onDampingSliderChanged(dampingSlider)
//
//    // Initial velocity
//    SliderDefaults.set(initialVelocitySlider, defaults: initialVelocutySliderDefaults)
//    onInitialVelocitySliderChanged(initialVelocitySlider)
//
//    // Damping multiplier
//    SliderDefaults.set(dampingMultiplierSlider, defaults: dampingMultiplierSliderDefaults)
//    onDampingMultiplierSliderChanged(dampingMultiplierSlider)
//
//    // Velocity multiplier
//    SliderDefaults.set(velocityMultiplierSlider, defaults: velocityMultiplierSliderDefaults)
//    onVelocityMultiplierSliderChanged(velocityMultiplierSlider)
//
//    // A
//    SliderDefaults.set(aMultiplierSlider, defaults: aMultiplierSliderDefaults)
//    onAMultiplierSliderChanged(aMultiplierSlider)
  }

  private func createControls() {
    var previousControl:SliderControllerView? = nil

    for data in controlsData {
      let control = SliderControllerView(name: data.name, defaults: data.defaults, delegate: self)
      controlsContainer.addSubview(control)
      ViewController.layoutControl(control, previous: previousControl)
      previousControl = control
    }
  }

  private class func layoutControl(control: UIView, previous: UIView?) {
    control.setTranslatesAutoresizingMaskIntoConstraints(false)

    if let currentPrevious = previous {
      iiLayout.stackVertically(currentPrevious, viewNext: control, margin: 15)
    } else {
      if let currentSuperview = control.superview {
        iiLayout.alignTop(control, anotherView: currentSuperview)
      }
    }

    iiLayout.fullWidthInParent(control)

  }

  private func createObjectOne() {
    objectOne = UIView(frame: CGRect(origin: CGPoint(),
      size: CGSize(width: objectSize, height: objectSize)))
    objectOne.backgroundColor = UIColor.grayColor()
    objectsContainer.addSubview(objectOne)
  }

  private func createObjectTwo() {
    objectTwo = UIView(frame: CGRect(origin: CGPoint(x: objectSize + objectMargin, y: 0),
      size: CGSize(width: objectSize, height: objectSize)))
    objectTwo.backgroundColor = UIColor.grayColor()
    objectsContainer.addSubview(objectTwo)
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
    objectsContainer.backgroundColor = nil

    controlsContainer.backgroundColor = nil
//    durationContainer.backgroundColor = nil
//    dampingContainer.backgroundColor = nil
//    initialVelocityContainer.backgroundColor = nil
//    dampingMultiplierContains.backgroundColor = nil
//    velocityMultiplierContains.backgroundColor = nil
//    aMultiplierContains.backgroundColor = nil
  }

  private func animate() {
    animateObjectOne()
    animateObjectTwo()
  }

  private func animateObjectOne() {
    objectOne.frame.origin = CGPoint(x: 0, y: 0)
    objectOne.layer.removeAllAnimations()

//    UIView.animateWithDuration(NSTimeInterval(durationSlider.value),
//      delay: 0,
//      usingSpringWithDamping: CGFloat(dampingSlider.value),
//      initialSpringVelocity: CGFloat(initialVelocitySlider.value),
//      options: UIViewAnimationOptions.BeginFromCurrentState,
//      animations: {
//        let newCenterY = self.objectsContainer.bounds.height / 2
//        self.objectOne.frame.origin = CGPoint(x: 0, y: newCenterY)
//      },
//      completion: nil)
//
//    println("Initial velocity \(CGFloat(initialVelocitySlider.value))")
  }

  private func animateObjectTwo() {
    setObjectTwoPosition(objectsContainer.bounds.height / 2)

//    let dampingMultiplier = Double(dampingMultiplierSlider.value)
//    let velocityMultiplier = Double(velocityMultiplierSlider.value)
//
//    let values = springValues(0, toValue: Double(objectsContainer.bounds.height / 2),
//      damping: dampingMultiplier * Double(dampingSlider.value),
//      initialVelocity: velocityMultiplier * Double(initialVelocitySlider.value))
//
//    let animation = CAKeyframeAnimation(keyPath: "position.y")
//    animation.values = values
//    animation.duration = CFTimeInterval(durationSlider.value)
//    objectTwo.layer.removeAllAnimations()
//    objectTwo.layer.addAnimation(animation, forKey: "mySpringAnimation")
  }

  private func springValues(fromValue: Double, toValue: Double,
    damping: Double, initialVelocity: Double) -> [Double]{

    let numOfPoints = 1000
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

//    let A = Double(aMultiplierSlider.value)
//    return pow(M_E, -2.6 * pow(damping, 0.1) * x) * cos(A * pow(initialVelocity,0.1) * x / damping)
    return 0
  }

  @IBAction func onGoTapped(sender: AnyObject) {
    animate()
  }

  @IBAction func onSliderChangeEnd(sender: AnyObject) {
    animate()
  }

//  @IBAction func onDurationSliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: durationLabel, caption: "Duration")
//    }
//  }
//
//  @IBAction func onDampingSliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: dampingLabel, caption: "Damping")
//    }
//  }
//
//  @IBAction func onInitialVelocitySliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: initialVelocityLabel, caption: "Initial velocity")
//    }
//  }
//
//  @IBAction func onDampingMultiplierSliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: dampingMultiplierLabel, caption: "Damping multiplier")
//    }
//  }
//
//  @IBAction func onVelocityMultiplierSliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: velocityMultiplierLabel, caption: "Velocity multiplier")
//    }
//  }
//
//  @IBAction func onAMultiplierSliderChanged(sender: AnyObject) {
//    if let slider = sender as? UISlider {
//      updateSliderLabel(slider, label: aMultiplierLabel, caption: "A")
//    }
//  }

  private func updateSliderLabel(slider: UISlider, label: UILabel, caption: String) {
    label.text = "\(caption): \(formatValue(slider.value))"
  }

  private func formatValue(value: Float) -> String {
    return String(format: "%.3f", value)
  }

  // SliderControllerDelegate
  // --------------------------

  func sliderControllerDelegate_OnChangeEnded() {
    animate()
  }
}

