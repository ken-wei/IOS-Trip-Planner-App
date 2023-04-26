//
//  CustomTabBarController.swift
//  Trip Planner
//
//  Created by Ken Wei Ooi on 26/08/2020.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //        print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // Update the model controller using Dependency Injection Pattern depends on which tabbar has been selected
        if let vc = viewController.childViewControllers[0] as? HomeViewController {
            let previousVC = tabBarController.childViewControllers[1].childViewControllers[0] as! PlanController
            if previousVC.modelController == nil {
                return
            }
            vc.modelController = previousVC.modelController
        } else if let vc = viewController.childViewControllers[0] as? PlanController {
            let previousVC = tabBarController.childViewControllers[0].childViewControllers[0] as! HomeViewController
            vc.modelController = previousVC.modelController
        }
        
    }
}
