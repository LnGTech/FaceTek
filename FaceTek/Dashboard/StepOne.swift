//
//  StepOne.swift
//  onboardingWithUIPageViewController
//
//  Created by Robert Chen on 8/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class StepOne : UIViewController {
    
    // the tofu
    @IBOutlet weak var imageView: UIImageView!
    
    // the tofu's center-x and the trash can's center-x
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!

    // the tofu's bottom and the trash can's bottom
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
     
    
}
}
