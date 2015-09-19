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
  let objectMargin: CGFloat = 20

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
      defaults: SliderDefaults(value: 0.7, minimumValue: 0.01, maximumValue: 2)
    ),
    ControlData(
      type: ControlType.initialVelocity,
      defaults: SliderDefaults(value: 1.8, minimumValue: 0.01, maximumValue: 10.0)
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
      let control = SliderControllerView()
      data.view = control
      controlsContainer.addSubview(control)
      control.setup(data.type, defaults: data.defaults, delegate: self)
      ViewController.layoutControl(control, previous: previousControl)
      previousControl = control
    }
  }

  private class func layoutControl(control: UIView, previous: UIView?) {
    control.translatesAutoresizingMaskIntoConstraints = false

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
    objectOne.backgroundColor = UIColor.darkGrayColor()
    objectsContainer.addSubview(objectOne)
    createLabel(objectOne, text: "UIView")
  }

  private func createObjectTwo() {
    objectTwo = UIView(frame: CGRect(origin: CGPoint(x: objectSize + objectMargin, y: 0),
      size: CGSize(width: objectSize, height: objectSize)))
    objectTwo.backgroundColor = UIColor.darkGrayColor()
    objectsContainer.addSubview(objectTwo)
    objectTwo.layer.anchorPoint = CGPoint(x: 0, y: 0)
    resetObjectTwoPosition()
    createLabel(objectTwo, text: "CALayer")
  }
  
  private func createLabel(view: UIView, text: String) {
    let label1 = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 4), size: CGSize()))
    label1.text = text
    label1.font = UIFont.systemFontOfSize(11)
    label1.clipsToBounds = false
    label1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
    label1.layer.anchorPoint = CGPoint(x: 0, y: 0)
    view.addSubview(label1)
    label1.sizeToFit()
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
    guard let presentationLayer = objectOne.layer.presentationLayer() else { return }
    
    let positionY = presentationLayer.position.y

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
        print("x: \(point.x - firstTimestamp) y: \(point.y)")
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

    objectTwo.layer.removeAllAnimations()

    SpringAnimation.animate(objectTwo.layer,
      keypath: "position.y",
      duration: CFTimeInterval(controlValue(ControlType.duration)),
      usingSpringWithDamping: Double(controlValue(ControlType.damping)),
      initialSpringVelocity: Double(controlValue(ControlType.initialVelocity)),
      fromValue: 0, toValue: Double(objectsContainer.bounds.height / 2), onFinished: nil)
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

