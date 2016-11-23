import UIKit

struct SliderDefaults {
  let value: Float
  let minimumValue: Float
  let maximumValue: Float

  static func set(_ slider: UISlider, defaults: SliderDefaults) {
    slider.minimumValue = defaults.minimumValue
    slider.maximumValue = defaults.maximumValue
    slider.value = defaults.value
  }
}
