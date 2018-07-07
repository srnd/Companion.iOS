//
//  CompanionAPIError.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/7/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

class CompanionAPIError : Error {
    var reason: String
    
    init(reason: String) {
        self.reason = reason
    }
}
