//
//  ScheduleCoursesTabBarViewController.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 21-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//

import UIKit

class ScheduleCoursesTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Animate transitions
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView: UIView = viewController.view
        
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve)
        return true
    }
}
