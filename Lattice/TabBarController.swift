//
//  TabBarController.swift
//  Lattice
//
//  Created by Eli Zhang on 12/30/18.
//  Copyright © 2018 Eli Zhang. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .clear

        let swipingController = SwipingController()
        swipingController.tabBarItem.title = "Home"
        
        viewControllers = [swipingController]
    }
    
}
