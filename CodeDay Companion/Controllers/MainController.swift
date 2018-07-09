//
//  MainController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

class MainController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UserStore.preCacheUser()
        
        if !Utils.isItCodeDay() {
            let arrayOfTabBarItems = self.tabBar.items

            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                let checkInItem = barItems[2]
                checkInItem.isEnabled = false
            }
        }
    }
}
