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

  var displayLinkTimer:CADisplayLink?
  var displayLinkTick = 0

  var graphData = [GraphPoint]()

  private let controlsData = [
    ControlData(
      type: ControlType.duration,
      defaults: SliderDefaults(value: 2, minimumValue: 0.01, maximumValue: 5.0)
    ),
    ControlData(
      type: ControlType.damping,
      defaults: SliderDefaults(value: 1.5, minimumValue: 0.01, maximumValue: 2)
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

  func onDisplayLinkTimerTicked(timer: CADisplayLink) {
    let positionY = objectOne.layer.presentationLayer().position.y

    graphData.append(
      GraphPoint(x:Double(timer.timestamp), y:Double(positionY))
    )

    displayLinkTick++
  }

  private func startDisplayLinkTimer() {
    stopDisplayLinkTimer()
    let timer = CADisplayLink(target: self, selector: "onDisplayLinkTimerTicked:")
    self.displayLinkTimer = timer
    timer.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
  }

  private func stopDisplayLinkTimer() {
    if let currentDisplayLinkTimer = displayLinkTimer {
      currentDisplayLinkTimer.invalidate()
      displayLinkTimer = nil
      displayLinkTick = 0

      var firstTimestamp: CFTimeInterval = 0
      if graphData.count > 0 {
        firstTimestamp = graphData[0].x
      }

      for point in graphData {
        println("x: \(point.x - firstTimestamp) y: \(point.y)")
      }

      graphData = [GraphPoint]()
    }
  }

  private func animate() {
    startDisplayLinkTimer()
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
      completion: { finished in
        self.stopDisplayLinkTimer()
      })
  }

  private func animateObjectTwo() {
    setObjectTwoPosition(objectsContainer.bounds.height / 2)

    let dampingMultiplier = Double(10)
    let velocityMultiplier = Double(10)

    let values = SpringAnimationValues.values(0, toValue: Double(objectsContainer.bounds.height / 2),
      damping: dampingMultiplier * Double(controlValue(ControlType.damping)),
      initialVelocity: velocityMultiplier * Double(controlValue(ControlType.initialVelocity)))

    let animation = CAKeyframeAnimation(keyPath: "position.y")
    animation.values = values
    animation.duration = CFTimeInterval(controlValue(ControlType.duration))
    objectTwo.layer.removeAllAnimations()
    objectTwo.layer.addAnimation(animation, forKey: "mySpringAnimation")
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

