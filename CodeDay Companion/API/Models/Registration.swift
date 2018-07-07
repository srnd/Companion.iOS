//
//  Registration.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Registration : Codable {
    enum RegistrationType : String, Codable {
        case student
        case volunteer
        case mentor
        case judge
        case teacher
        case sponsor
        case press
        case vip
    }
    
    // for some responses
    var ok: Bool

    var id: String
    var name: String
    var firstName: String
    var lastName: String
    var profileImage: String
    var type: RegistrationType
    var checkedInAt: Timestamp
    var hasAge: Bool
    var hasParent: Bool
    var hasWaiver: Bool
    var event: Event
    
    enum CodingKeys : String, CodingKey {
        case ok
        case id
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
        case checkedInAt = "checked_in_at"
        case type
        case hasAge = "has_age"
        case hasParent = "has_parent"
        case hasWaiver = "has_waiver"
        case event
    }
}
