//
//  Utils.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import UIKit
import SwiftDate

class Utils {
    static func loadingAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
    static func isItCodeDay() -> Bool {
        if let reg = UserStore.getUserRegistration() {
            let rightNow = DateInRegion()
            let start = DateInRegion(Date(timeIntervalSince1970: reg.event.startsAt))
            let end = DateInRegion(Date(timeIntervalSince1970: reg.event.endsAt))
            
            return rightNow.isInRange(date: start, and: end)
        } else {
            return false
        }
    }
    
    static func daysUntilCodeDay() -> Int64 {
        if let reg = UserStore.getUserRegistration() {
            let rightNow = DateInRegion()
            let start = DateInRegion(Date(timeIntervalSince1970: reg.event.startsAt))
            
            return rightNow.getInterval(toDate: start, component: .day)
        } else {
            return -1
        }
    }
}
