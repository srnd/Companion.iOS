//
//  Timestamp.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import SwiftDate

// This object represents a Laravel JSON-encoded date.
// Thanks, Laravel.
struct Timestamp : Codable {
    var date: String
    var timezoneType: Int
    var timezone: String
    
    enum CodingKeys : String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
    
    func toDate() -> DateInRegion {
        return self.date.toDate("yyyy-MM-dd HH:mm:ss.000000")!
    }
}
