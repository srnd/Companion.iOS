//
//  MainController.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import UserNotifications

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
    
    override func viewDidAppear(_ animated: Bool) {
        let shouldPrompt = !((UserDefaults.standard.object(forKey: "promptedNotifications") as? Bool) ?? false)
        
        UNUserNotificationCenter.current().getNotificationSettings() { settings in
            if settings.alertSetting == .notSupported, shouldPrompt {
                let alert = UIAlertController(title: "Get important notifications?", message: "During CodeDay, we can notify you of announcements from organizers as well as upcoming activities. Do you want to enable these?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "No, thanks", style: .default) { action in
                    UserDefaults.standard.set(true, forKey: "promptedNotifications")
                })
                
                alert.addAction(UIAlertAction(title: "Sure!", style: .cancel) { action in
                    UNUserNotificationCenter.current().requestAuthorization(options: [ .alert, .sound, .badge ]) { granted, error in
                        guard granted else { return }
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                })
                
                self.selectedViewController?.present(alert, animated: true, completion: nil)
            }
        }
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
