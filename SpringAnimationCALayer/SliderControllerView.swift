import UIKit

class SliderControllerView: UIView {
  fileprivate var type: ControlType!
  fileprivate var label: UILabel!
  fileprivate var slider: UISlider!
  fileprivate weak var delegate: SliderControllerDelegate?
  
  func setup(_ type: ControlType, defaults: SliderDefaults, delegate: SliderControllerDelegate) {
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

  fileprivate func configureLabel() {
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)

    SliderControllerView.positionLabel(label, superview: self)
  }

  fileprivate class func positionLabel(_ label: UIView, superview: UIView) {
    iiLayout.alignTop(label, anotherView: superview)
    iiLayout.fullWidthInParent(label)
  }

  fileprivate func configureSlider(_ slider: UISlider) {
    slider.translatesAutoresizingMaskIntoConstraints = false
    addSubview(slider)

    slider.addTarget(self, action: #selector(SliderControllerView.sliderChanged(_:)), for: UIControlEvents.valueChanged)

    slider.addTarget(self, action: #selector(SliderControllerView.sliderChangeEnded(_:)), for: UIControlEvents.touchUpInside)


    SliderControllerView.positionSlider(label, slider: slider, superview: self)
  }

  func sliderChanged(_ slider: UISlider) {
    SliderControllerView.updateSliderLabel(slider, label: label, caption: type.rawValue)
  }

  func sliderChangeEnded(_ slider: UISlider) {
    delegate?.sliderControllerDelegate_OnChangeEnded()
  }

  fileprivate class func updateSliderLabel(_ slider: UISlider, label: UILabel, caption: String) {
    label.text = "\(caption): \(formatValue(slider.value))"
  }

  fileprivate class func positionSlider(_ caption: UIView, slider: UIView, superview: UIView) {
    iiLayout.fullWidthInParent(slider)
    iiLayout.stackVertically(caption, viewNext: slider, margin: 3)
    iiLayout.alignBottom(slider, anotherView: superview)
  }

  fileprivate class func formatValue(_ value: Float) -> String {
    return String(format: "%.3f", value)
  }
}
