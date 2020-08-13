//
//  OnboardingPager.swift
//  onboardingWithUIPageViewController
//
//  Created by Robert Chen on 8/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class OnboardingPager : UIPageViewController {
    
    override func viewDidLoad() {
        // Set the dataSource and delegate in code.  
        // I can't figure out how to do this in the Storyboard!
        dataSource = self
        delegate = self
        // this sets the background color of the built-in paging dots
        view.backgroundColor = UIColor.darkGray
        
        // This is the starting point.  Start with step zero.
        setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
    }
    
    func getStepZero() -> StepZero {
        return storyboard!.instantiateViewController(withIdentifier: "StepZero") as! StepZero
    }
    
    func getStepOne() -> StepOne {
        return storyboard!.instantiateViewController(withIdentifier: "StepOne") as! StepOne
    }
    
    func getStepTwo() -> StepTwo {
        return storyboard!.instantiateViewController(withIdentifier: "StepTwo") as! StepTwo
    }
    
    func getStepThree() -> StepThree {
        return storyboard!.instantiateViewController(withIdentifier: "StepThree") as! StepThree
    }
    
}

// MARK: - UIPageViewControllerDataSource methods

extension OnboardingPager : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        
        if viewController.isKind(of: StepThree.self) {
            // 2 -> 1
            return getStepTwo()
        }
        
        
         else if viewController.isKind(of: StepTwo.self) {
            // 2 -> 1
            return getStepOne()
        } else if viewController.isKind(of: StepOne.self) {
            // 1 -> 0
            return getStepZero()
        } else {
            // 0 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: StepZero.self) {
            // 0 -> 1
            return getStepOne()
        } else if viewController.isKind(of: StepOne.self) {
            // 1 -> 2
            return getStepTwo()
        }
        
        else if viewController.isKind(of: StepTwo.self) {
            
            return getStepThree()
        }
        
        
        else {
            // 2 -> end of the road
            return nil
        }
    }
    
    // Enables pagination dots
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    // This only gets called once, when setViewControllers is called
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

// MARK: - UIPageViewControllerDelegate methods

extension UIViewController : UIPageViewControllerDelegate {
    
}
