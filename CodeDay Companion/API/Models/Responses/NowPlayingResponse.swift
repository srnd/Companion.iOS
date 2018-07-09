//
//  NowPlayingResponse.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct NowPlayingResponse : Codable {
    var spotifyLinked: Bool
    var nowPlaying: Song?
    
    enum CodingKeys : String, CodingKey {
        case spotifyLinked = "spotify_linked"
        case nowPlaying = "now_playing"
    }
}
