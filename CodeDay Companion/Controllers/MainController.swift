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
    }
}
