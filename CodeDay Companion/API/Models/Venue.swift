//
//  Venue.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Venue : Codable {
    var name: String
    var address: VenueAddress
    var contact: VenueContact
    var fullAddress: String
    
    enum CodingKeys : String, CodingKey {
        case name
        case address
        case contact
        case fullAddress = "full_address"
    }
}
