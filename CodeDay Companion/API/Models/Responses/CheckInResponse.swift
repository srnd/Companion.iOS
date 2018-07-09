//
//  CheckInResponse.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/8/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

struct CheckInResponse : Codable {
    var ok: Bool
    var code: String?
    var error: String?
}
