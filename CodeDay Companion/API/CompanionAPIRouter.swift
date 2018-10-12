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
    case checkIn(ticketId: String)
    case getNowPlaying(eventId: String)
    case getRegionsAttended(ticketId: String)
    case associateApns(ticketId: String, apnsToken: String, dev: Bool)
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self{
            case let .getTicketById(ticketId):
                return ("/ticket/\(ticketId)", [:])
            case let .getTicketByEmail(email):
                return ("/login", [ "email": email ])
            case let .getEventAnnouncements(eventId):
                return ("/announcements/\(eventId)", [:])
            case let .checkIn(ticketId):
                return ("/checkin/\(ticketId)", [:])
            case let .getNowPlaying(eventId):
                return ("/nowplaying/\(eventId)", [:])
            case let .getRegionsAttended(ticketId):
                return ("/regions_attended/\(ticketId)", [:])
            case let .associateApns(ticketId, apnsToken, dev):
                return ("/associate", [
                    "id": ticketId,
                    "token": apnsToken,
                    "ios": "true",
                    "dev": dev
                ])
            }
        }()
        
        let url = try CompanionAPIRouter.baseUrl.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}
