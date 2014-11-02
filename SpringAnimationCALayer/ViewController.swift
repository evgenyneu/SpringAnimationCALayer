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
      type: ControlType.duration,
      defaults: SliderDefaults(value: 3, minimumValue: 0.01, maximumValue: 5.0)
    ),
    ControlData(
      type: ControlType.damping,
      defaults: SliderDefaults(value: 0.1, minimumValue: 0.01, maximumValue: 0.6)
    ),
    ControlData(
      type: ControlType.initialVelocity,
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10.0)
    )
  ]

  var objectOne: UIView!
  var objectTwo: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    removeBackgroundColor()

    createObjectOne()
    createObjectTwo()

    createControls()
  }

  private func createControls() {
    var previousControl:SliderControllerView? = nil

    for data in controlsData {
      let control = SliderControllerView(type: data.type, defaults: data.defaults, delegate: self)
      data.view = control
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
  }

  private func animate() {
    animateObjectOne()
    animateObjectTwo()
  }

  private func controlValue(type: ControlType) -> Float {
    if let found = (controlsData.filter { $0.type == type }.first) {
      if let sliderView = found.view {
        return sliderView.value
      }
    }

    return 0
  }

  private func animateObjectOne() {
    objectOne.frame.origin = CGPoint(x: 0, y: 0)
    objectOne.layer.removeAllAnimations()

    UIView.animateWithDuration(NSTimeInterval(controlValue(ControlType.duration)),
      delay: 0,
      usingSpringWithDamping: CGFloat(controlValue(ControlType.damping)),
      initialSpringVelocity: CGFloat(controlValue(ControlType.initialVelocity)),
      options: UIViewAnimationOptions.BeginFromCurrentState,
      animations: {
        let newCenterY = self.objectsContainer.bounds.height / 2
        self.objectOne.frame.origin = CGPoint(x: 0, y: newCenterY)
      },
      completion: nil)
  }

  private func animateObjectTwo() {
    setObjectTwoPosition(objectsContainer.bounds.height / 2)

    let dampingMultiplier = Double(10)
    let velocityMultiplier = Double(10)

    let values = springValues(0, toValue: Double(objectsContainer.bounds.height / 2),
      damping: dampingMultiplier * Double(controlValue(ControlType.damping)),
      initialVelocity: velocityMultiplier * Double(controlValue(ControlType.initialVelocity)))

    let animation = CAKeyframeAnimation(keyPath: "position.y")
    animation.values = values
    animation.duration = CFTimeInterval(controlValue(ControlType.duration))
    objectTwo.layer.removeAllAnimations()
    objectTwo.layer.addAnimation(animation, forKey: "mySpringAnimation")
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
    return pow(M_E, -damping * x) * cos(initialVelocity * x)
  }

  @IBAction func onGoTapped(sender: AnyObject) {
    animate()
  }

  // SliderControllerDelegate
  // --------------------------

  func sliderControllerDelegate_OnChangeEnded() {
    animate()
  }
}

