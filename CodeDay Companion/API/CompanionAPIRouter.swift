//
//  CompanionAPIRouter.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import Alamofire

enum CompanionAPIRouter : URLRequestConvertible {
    static let baseUrl = Constants.API_BASE
    
    case getTicketById(ticketId: String)
    case getTicketByEmail(email: String)
    case getEventAnnouncements(eventId: String)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self{
            case let .getTicketById(ticketId):
                return ("/ticket/\(ticketId)", [:])
            case let .getTicketByEmail(email):
                return ("/login", [ "email": email ])
            case let .getEventAnnouncements(eventId):
                return ("/announcements/\(eventId)", [:])
            }
        }()
        
        let url = try CompanionAPIRouter.baseUrl.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
