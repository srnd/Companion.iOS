//
//  VenueAddress.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct VenueAddress : Codable {
    var lineOne: String
    var lineTwo: String
    var city: String
    var state: String
    var postal: String
    var country: String
    
    enum CodingKeys : String, CodingKey {
        case lineOne = "line_1"
        case lineTwo = "line_2"
        case city
        case state
        case postal
        case country
    }
}
