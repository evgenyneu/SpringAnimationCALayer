//
//  ViewController.swift
//  SpringAnimationCALayer
//
//  Created by Evgenii Neumerzhitckii on 1/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var viewOneContainer: UIView!

  let objectSize: CGFloat = 50

  override func viewDidLoad() {
    super.viewDidLoad()


    let objectOne = UIView(frame: CGRect(origin: CGPoint(),
      size: CGSize(width: objectSize, height: objectSize)))

    objectOne.backgroundColor = UIColor.blueColor()
    viewOneContainer.addSubview(objectOne)

    UIView.animateWithDuration(2,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 1,
      options: nil,
      animations: {
        let newCenterX = self.viewOneContainer.bounds.width / 2
        objectOne.center = CGPoint(x: newCenterX, y: objectOne.center.y)
      },
      completion: nil)
  }




}

