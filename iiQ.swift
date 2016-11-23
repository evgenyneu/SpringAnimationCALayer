import UIKit

class iiQ {
  class func async(_ block: @escaping ()->()) {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: block)
  }

  class func main(_ block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
  }

  class func runAfterDelay(_ delaySeconds: Double, block: @escaping ()->()) {
    let time = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: block)
  }
}
