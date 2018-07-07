//
//  Event.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Event : Codable {
    var id: String
    var region: String
    var name: String
    var schedule: Dictionary<String, [Activity]>
    var startsAt: Int
    var endsAt: Int
    var venue: Venue?
    
    enum CodingKeys : String, CodingKey {
        case id
        case region
        case name
        case schedule
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
}
