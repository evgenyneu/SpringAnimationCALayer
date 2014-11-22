# Overview

This is a demo app for iOS. It animates CALayer with a spring animation which is similar to UIView's method `animateWithDuration(_:delay:usingSpringWithDamping:...)`.

## Usage

1. Copy `SpringAnimation.swift` file to your project.
1. Animate your CALayer's property by calling `SpringAnimation.animate` function.

For example:

```
SpringAnimation.animate(myCALayer,
  keypath: "position.y",
  duration: 2.0,
  usingSpringWithDamping: 0.7,
  initialSpringVelocity: 1.8,
  fromValue: 0,
  toValue: M_PI,
  onFinished: nil)
```

Currently animation looks similar to UIView's method.
But the `duration`, `usingSpringWithDamping` and `initialSpringVelocity` values
are different from UIView's arguments.

The goal of this project is to make this CALayer's animation work exactly like UIView's for the same arguments.