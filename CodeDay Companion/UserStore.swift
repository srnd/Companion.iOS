//
//  UserStore.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import Disk

// TODO: Clean this up a lot. it is messy. bad.
class UserStore {
    private static var cachedUser: Registration?
    private static var cachedAnnouncements: [Announcement]?
    private static var cachedCheckInInfo: CheckInResponse?
    
    static func clearUserData() -> Bool {
        do {
            cachedUser = nil
            cachedAnnouncements = nil
            cachedCheckInInfo = nil
            try Disk.clear(Constants.USER_REGISTRATION_DIRECTORY)
            
            let sharedDefaults = UserDefaults(suiteName: "group.srnd.codeday")
            sharedDefaults?.set([ ], forKey: "sticker_regions")
            sharedDefaults?.synchronize()
            
            return true
        } catch {
            return false
        }
    }
    
    static func preCacheUser() {
        if cachedUser == nil {
            do {
                let reg = try Disk.retrieve(Constants.USER_REGISTRATION_FILE, from: Constants.USER_REGISTRATION_DIRECTORY, as: Registration.self)
                cachedUser = reg
            } catch {
                 // no big deal
            }
        }
    }
    
    static func getUserRegistration() -> Registration? {
        if cachedUser == nil {
            do {
                let reg = try Disk.retrieve(Constants.USER_REGISTRATION_FILE, from: Constants.USER_REGISTRATION_DIRECTORY, as: Registration.self)
                cachedUser = reg
                return reg
            } catch {
                // print("Error getting user info: \(error)")
                return nil
            }
        } else {
            return cachedUser
        }
    }
    
    static func setUserRegistration(_ reg: Registration) -> Bool {
        do {
            try Disk.save(reg, to: Constants.USER_REGISTRATION_DIRECTORY, as: Constants.USER_REGISTRATION_FILE)
            cachedUser = reg
            return true
        } catch {
            print("Error setting user info: \(error)")
            return false
        }
    }
    
    static func getAnnouncements() -> [Announcement] {
        if cachedAnnouncements == nil {
            do {
                let announcements = try Disk.retrieve(Constants.ANNOUNCEMENTS_FILE, from: Constants.USER_REGISTRATION_DIRECTORY, as: [Announcement].self)
                cachedAnnouncements = announcements
                return announcements
            } catch {
                return [ ]
            }
        } else {
            return cachedAnnouncements!
        }
    }
    
    static func setAnnouncements(_ announcements: [Announcement]) -> Bool {
        do {
            try Disk.save(announcements, to: Constants.USER_REGISTRATION_DIRECTORY, as: Constants.ANNOUNCEMENTS_FILE)
            cachedAnnouncements = announcements
            return true
        } catch {
            print("Error setting announcements: \(error)")
            return false
        }
    }
    
    static func getCheckInInfo() -> CheckInResponse? {
        if cachedCheckInInfo == nil {
            do {
                let info = try Disk.retrieve(Constants.CHECKIN_INFO_FILE, from: Constants.USER_REGISTRATION_DIRECTORY, as: CheckInResponse.self)
                cachedCheckInInfo = info
                return info
            } catch {
                return nil
            }
        } else {
            return cachedCheckInInfo!
        }
    }
    
    static func setCheckInInfo(_ info: CheckInResponse) -> Bool {
        do {
            try Disk.save(info, to: Constants.USER_REGISTRATION_DIRECTORY, as: Constants.CHECKIN_INFO_FILE)
            cachedCheckInInfo = info
            return true
        } catch {
            print("Error setting check-in info: \(error)")
            return false
        }
    }
}
