//
//  Activity.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Activity : Codable {
    enum ActivityType : String, Codable {
        case workshop
        case speech
        case event
    }
    
    var time: Float
    var title: String
    var type: ActivityType
    var url: String?
    var description: String?
    var timestamp: Timestamp
    var hour: String
    var day: String
}
