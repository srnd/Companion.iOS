//
//  Announcement.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Announcement : Codable {
    struct AnnouncementLink : Codable {
        var url: String
        var text: String
    }
    
    var id: String
    var postedAt: Timestamp
    var body: String
    var urgency: Int
    var link: AnnouncementLink?
    var creator: User
    
    enum CodingKeys : String, CodingKey {
        case id
        case postedAt = "posted_at"
        case body
        case urgency
        case link
        case creator
    }
}
