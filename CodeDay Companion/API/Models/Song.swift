//
//  Song.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct Song : Codable {
    var track: String
    var artist: String
    var album: Album
    var link: String
}
