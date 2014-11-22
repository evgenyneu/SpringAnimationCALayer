//
//  SpringAnimationValues.swift
//
//  Returns array of values for CAKeyframeAnimation to achieve spring animation effect
//
//  Created by Evgenii Neumerzhitckii on 22/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation

class SpringAnimationValues {
  class func values(fromValue: Double, toValue: Double,
    damping: Double, initialVelocity: Double) -> [Double]{

      let numOfPoints = 500
      var values = [Double](count: numOfPoints, repeatedValue: 0.0)

      let distanceBetweenValues = toValue - fromValue

      for point in (0..<numOfPoints) {
        let x = Double(point) / Double(numOfPoints)
        let valueNormalized = valuesNormalized(x, damping: damping, initialVelocity: initialVelocity)

        let value = toValue - distanceBetweenValues * valueNormalized
        values[point] = value
      }

      return values
  }

  private class func valuesNormalized(x: Double, damping: Double, initialVelocity: Double) -> Double {
    return pow(M_E, -damping * x) * cos(initialVelocity * x)
  }
}
