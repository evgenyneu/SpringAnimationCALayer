# Overview

This is a demo app for iOS written in Swift. It animates CALayer with a spring animation which is similar to UIView's method `animateWithDuration(_:delay:usingSpringWithDamping:...)`.

## Usage

1. Copy `SpringAnimation.swift` file to your project.
1. Animate your CALayer's property by calling `SpringAnimation.animate` function.

For example, let's rotate a layer around its X axis in perspective:

```
var transform = CATransform3DIdentity
transform.m34 = -1.0/100.0
myCALayer.transform = CATransform3DRotate(transform, CGFloat(M_PI), 1, 0, 0)

SpringAnimation.animate(myCALayer,
  keypath: "transform.rotation.x",
  duration: 2.0,
  usingSpringWithDamping: 0.7,
  initialSpringVelocity: 1.8,
  fromValue: 0,
  toValue: Double(M_PI),
  onFinished: nil)
```

Currently animation looks similar to UIView's method.
But the `duration`, `usingSpringWithDamping` and `initialSpringVelocity` values
are different from UIView's arguments.

## The Goal

The goal of this project is to make this CALayer's animation work **exactly** like UIView's for the same arguments.

> Help me, Finn and Jake. You're my only hope.

<img src='https://raw.githubusercontent.com/evgenyneu/SpringAnimationCALayer/master/graphics/calayer-animation-demo-swift.png' width='320' alt='Spring animation for CALayer in iOS with Swift'>
