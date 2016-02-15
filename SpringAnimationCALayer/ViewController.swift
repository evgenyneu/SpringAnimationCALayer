import UIKit

class ViewController: UIViewController, SliderControllerDelegate {
  @IBOutlet weak var controlsContainer: UIView!
  @IBOutlet weak var objectsContainer: UIView!
  @IBOutlet weak var graphView: GraphView!

  let objectSize: CGFloat = 50
  let objectMargin: CGFloat = 20

  var displayLinkTimer:CADisplayLink?
  var graphData = [GraphPoint]()

  private let controlsData = [
    ControlData(
      type: ControlType.duration,
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 3)
    ),
    ControlData(
      type: ControlType.damping,
      defaults: SliderDefaults(value: 0.1, minimumValue: 0.01, maximumValue: 0.3)
    ),
    ControlData(
      type: ControlType.initialVelocity,
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10)
    ),
    ControlData(
      type: ControlType.a,
      defaults: SliderDefaults(value: 10, minimumValue: 0.01, maximumValue: 30)
    ),
    ControlData(
      type: ControlType.b,
      defaults: SliderDefaults(value: 1.0, minimumValue: 0.01, maximumValue: 2)
    ),
    ControlData(
      type: ControlType.c,
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10)
    ),
    ControlData(
      type: ControlType.d,
      defaults: SliderDefaults(value: 1, minimumValue: 0.01, maximumValue: 10)
    )
  ]

  var uiViewBox: UIView!
  var caLayerBox: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    removeBackgroundColor()

    createUiViewBox()
    createCaLayerBox()

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

  private func createUiViewBox() {
    uiViewBox = UIView(frame: CGRect(origin: CGPoint(),
      size: CGSize(width: objectSize, height: objectSize)))
    uiViewBox.backgroundColor = UIColor.redColor()
    objectsContainer.addSubview(uiViewBox)
    createLabel(uiViewBox, text: "UIView")
  }

  private func createCaLayerBox() {
    caLayerBox = UIView(frame: CGRect(origin: CGPoint(x: objectSize + objectMargin, y: 0),
      size: CGSize(width: objectSize, height: objectSize)))
    caLayerBox.backgroundColor = UIColor.greenColor()
    objectsContainer.addSubview(caLayerBox)
    caLayerBox.layer.anchorPoint = CGPoint(x: 0, y: 0)
    resetcaLayerBoxPosition()
    createLabel(caLayerBox, text: "CALayer")
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

  private func resetcaLayerBoxPosition() {
    setcaLayerBoxPosition(0)
  }

  private func setcaLayerBoxPosition(yPosition: CGFloat) {
    caLayerBox.layer.position = CGPoint(x: objectSize + objectMargin, y: yPosition)
  }

  private func removeBackgroundColor() {
    objectsContainer.backgroundColor = nil
    controlsContainer.backgroundColor = nil
  }
  
  private func animate() {
    startDisplayLinkTimer()
    animateUiViewBox()
    animateCaLayerBox()
  }

  private func controlValue(type: ControlType) -> Float {
    if let found = (controlsData.filter { $0.type == type }.first) {
      if let sliderView = found.view {
        return sliderView.value
      }
    }

    return 0
  }

  private func animateUiViewBox() {
    uiViewBox.frame.origin = CGPoint(x: 0, y: 0)
    uiViewBox.layer.removeAllAnimations()
    
    let springVelocity = CGFloat(controlValue(ControlType.damping))
    let initialVelocity = CGFloat(controlValue(ControlType.initialVelocity))

    UIView.animateWithDuration(NSTimeInterval(controlValue(ControlType.duration)),
      delay: 0,
      usingSpringWithDamping: springVelocity,
      initialSpringVelocity: initialVelocity,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { [weak self] in
        let newCenterY = (self?.objectsContainer.bounds.height ?? 0) / 2
        self?.uiViewBox.frame.origin = CGPoint(x: 0, y: newCenterY)
      },
      completion: { [weak self] finished in
        if finished, let graphData = self?.graphData {
          self?.stopDisplayLinkTimer()
          self?.graphView.drawMotionGraphs(graphData)
        }
      })
  }

  private func animateCaLayerBox() {
    setcaLayerBoxPosition(objectsContainer.bounds.height / 2)

    caLayerBox.layer.removeAllAnimations()

    let params = SpringAnimationParameters(
      a: Double(controlValue(ControlType.a)),
      b: Double(controlValue(ControlType.b)),
      c: Double(controlValue(ControlType.c)),
      d: Double(controlValue(ControlType.d))
    )
    
    SpringAnimation.animate(caLayerBox.layer,
      keypath: "position.y",
      duration: CFTimeInterval(controlValue(ControlType.duration)),
      params: params,
      usingSpringWithDamping: Double(controlValue(ControlType.damping)),
      initialSpringVelocity: Double(controlValue(ControlType.initialVelocity)),
      fromValue: 0, toValue: Double(objectsContainer.bounds.height / 2), onFinished: nil)
  }

  @IBAction func onGoTapped(sender: AnyObject) {
    animate()
  }

  
  // MARK: - Record movement
  // --------------------------
  
  func onDisplayLinkTimerTicked(timer: CADisplayLink) {
    guard let uiViewBoxPresentationLayer = uiViewBox.layer.presentationLayer() else { return }
    guard let caLayerBoxPresentationLayer = caLayerBox.layer.presentationLayer() else { return }
    
    let uiViewY = uiViewBoxPresentationLayer.position.y
    let caLayerY = caLayerBoxPresentationLayer.position.y
    
    if !uiViewY.isFinite || !caLayerY.isFinite {
      return
    }
    
    graphData.append(
      GraphPoint(
        x: Double(timer.timestamp),
        uiViewY: Double(uiViewY),
        caLayerY: Double(caLayerY)
      )
    )
  }
  
  private func startDisplayLinkTimer() {
    stopDisplayLinkTimer()
    graphData = [GraphPoint]()
    let timer = CADisplayLink(target: self, selector: "onDisplayLinkTimerTicked:")
    self.displayLinkTimer = timer
    timer.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
  }
  
  private func stopDisplayLinkTimer() {
    if let currentDisplayLinkTimer = displayLinkTimer {
      currentDisplayLinkTimer.invalidate()
      displayLinkTimer = nil
    }    
  }
  
  // MARK: SliderControllerDelegate
  // --------------------------
  
  func sliderControllerDelegate_OnChangeEnded() {
    animate()
  }
}

