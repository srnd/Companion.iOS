//
//  Constants.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import Disk

struct Constants {
    static let API_BASE = "https://app.codeday.vip/api"
    static let USER_REGISTRATION_FILE = "user.json"
    static let ANNOUNCEMENTS_FILE = "announcements.json"
    static let CHECKIN_INFO_FILE = "checkin.json"
    static let USER_REGISTRATION_DIRECTORY = Disk.Directory.applicationSupport
    static let APNS_DEVELOPMENT = true
}
