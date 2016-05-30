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
    caLayerBox.backgroundColor = UIColor.blueColor()
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

    UIView.animateWithDuration(NSTimeInterval(controlValue(ControlType.duration)),
      delay: 0,
      usingSpringWithDamping: CGFloat(controlValue(ControlType.damping)),
      initialSpringVelocity: CGFloat(controlValue(ControlType.initialVelocity)),
      options: UIViewAnimationOptions.BeginFromCurrentState,
      animations: { [weak self] in
        let newCenterY = (self?.objectsContainer.bounds.height ?? 0) / 2
        self?.uiViewBox.frame.origin = CGPoint(x: 0, y: newCenterY)
      },
      completion: { [weak self] finished in
        if finished, let graphData = self?.graphData {
          self?.stopDisplayLinkTimer()
          self?.graphView.drawMotionGraphs(graphData);
        }
      })
  }

  private func animateCaLayerBox() {
    setcaLayerBoxPosition(objectsContainer.bounds.height / 2)

    caLayerBox.layer.removeAllAnimations()

    SpringAnimation.animate(caLayerBox.layer,
      keypath: "position.y",
      duration: CFTimeInterval(controlValue(ControlType.duration)),
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
    let timer = CADisplayLink(target: self, selector: #selector(ViewController.onDisplayLinkTimerTicked(_:)))
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

