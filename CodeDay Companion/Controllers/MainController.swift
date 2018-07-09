//
//  MainController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit

class MainController : UITabBarController {
    private var reg: Registration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserStore.preCacheUser()
        
        reg = UserStore.getUserRegistration()
        
        if !Utils.isItCodeDay(), reg?.type != .volunteer {
            let arrayOfTabBarItems = self.tabBar.items

            if let barItems = arrayOfTabBarItems, barItems.count > 0 {
                let checkInItem = barItems[2]
                checkInItem.isEnabled = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(sync), name: .beginSync, object: nil)
        sync()
    }
    
    @objc private func sync() {
        // TODO: move this sync code somewhere else? idk how ios does things lol
        // but android has a really nice built-in sync adapter
        CompanionAPI.getRegistrationById(reg!.id) { newReg, error in
            if error == nil, newReg?.ok ?? false {
                UserStore.setUserRegistration(newReg!)
                // notify all listeners that sync has completed
                NotificationCenter.default.post(name: .syncFinished, object: nil)
            }
        }
    }
}
