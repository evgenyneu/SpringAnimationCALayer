import UIKit

class SpringAnimation {
  // Animates layer with spring effect.
  class func animate(layer: CALayer,
    keypath: String,
    duration: CFTimeInterval,
    params: SpringAnimationParameters,
    usingSpringWithDamping: Double,
    initialSpringVelocity: Double,
    fromValue: Double,
    toValue: Double,
    onFinished: (()->())?) {

    CATransaction.begin()
    CATransaction.setCompletionBlock(onFinished)

    let animation = create(keypath, duration: duration,
      params: params,
      usingSpringWithDamping: usingSpringWithDamping,
      initialSpringVelocity: initialSpringVelocity,
      fromValue: fromValue, toValue: toValue)

    layer.addAnimation(animation, forKey: keypath + " spring animation")
    CATransaction.commit()
  }

  // Creates CAKeyframeAnimation object
  class func create(keypath: String,
    duration: CFTimeInterval,
    params: SpringAnimationParameters,
    usingSpringWithDamping: Double,
    initialSpringVelocity: Double,
    fromValue: Double,
    toValue: Double) -> CAKeyframeAnimation {

    let values = animationValues(fromValue, toValue: toValue,
      params: params,
      usingSpringWithDamping: usingSpringWithDamping,
      initialSpringVelocity: initialSpringVelocity)

    let animation = CAKeyframeAnimation(keyPath: keypath)
    animation.values = values
    animation.duration = duration

    return animation
  }

  class func animationValues(fromValue: Double, toValue: Double,
    params: SpringAnimationParameters,
    usingSpringWithDamping: Double, initialSpringVelocity: Double) -> [Double]{

    let numOfPoints = 500
    var values = [Double](count: numOfPoints, repeatedValue: 0.0)

    let distanceBetweenValues = toValue - fromValue

    for point in (0..<numOfPoints) {
      let x = Double(point) / Double(numOfPoints)
      let valueNormalized = animationValuesNormalized(x,
        params: params,
        usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity)

      let value = toValue - distanceBetweenValues * valueNormalized
      values[point] = value
    }

    return values
  }

  private class func animationValuesNormalized(x: Double,
    params: SpringAnimationParameters,
    usingSpringWithDamping: Double,
    initialSpringVelocity: Double) -> Double {
      
    return pow(params.b, -usingSpringWithDamping * params.a * x) * cos(sqrt(pow(usingSpringWithDamping, -2) - 1 ) * x)
  }
}
