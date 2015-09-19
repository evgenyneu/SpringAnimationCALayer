import UIKit

class ControlData {
  let type: ControlType
  let defaults: SliderDefaults
  var view: SliderControllerView? = nil

  init(type: ControlType, defaults: SliderDefaults) {
    self.type = type
    self.defaults = defaults
  }
}
