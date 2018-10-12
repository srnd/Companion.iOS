//
//  CompanionAPI.swift
//  CodeDay Companion
//
//  Created by TJ Horner on 7/6/18.
//  Copyright © 2018 srnd.org. All rights reserved.
//

import Alamofire

class CompanionAPI {
    private static func decodeResponse<T : Codable>(_ dump: T.Type, res: DataResponse<String>) throws -> T? {
        if let resp = res.result.value {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: resp.data(using: .utf8)!) as T?
        } else {
            throw CompanionAPIError(reason: "Could not decode API response.")
        }
    }
    
    static func getRegistrationById(_ ticketId: String, completion: @escaping (Registration?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.getTicketById(ticketId: ticketId)).responseString { response in
            do {
                completion(try decodeResponse(Registration.self, res: response), nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func getRegistrationByEmail(_ email: String, completion: @escaping (Registration?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.getTicketByEmail(email: email)).responseString { response in
            do {
                completion(try decodeResponse(EmailLoginResponse.self, res: response)?.registration, nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func getAnnouncementsForEvent(_ eventId: String, completion: @escaping ([Announcement]?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.getEventAnnouncements(eventId: eventId)).responseString { response in
            do {
                completion(try decodeResponse([Announcement].self, res: response), nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func checkInTicketId(_ ticketId: String, completion: @escaping (CheckInResponse?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.checkIn(ticketId: ticketId)).responseString { response in
            do {
                completion(try decodeResponse(CheckInResponse.self, res: response), nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func getNowPlaying(_ eventId: String, completion: @escaping (NowPlayingResponse?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.getNowPlaying(eventId: eventId)).responseString { response in
            do {
                completion(try decodeResponse(NowPlayingResponse.self, res: response), nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func getRegionsAttended(_ ticketId: String, completion: @escaping ([String]?, Error?) -> Void) {
        Alamofire.request(CompanionAPIRouter.getRegionsAttended(ticketId: ticketId)).responseString { response in
            do {
                completion(try decodeResponse([String].self, res: response), nil)
            } catch {
                print("Companion API error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    static func associateApns(ticketId: String, apnsToken: String, dev: Bool) {
        Alamofire.request(CompanionAPIRouter.associateApns(ticketId: ticketId, apnsToken: apnsToken, dev: dev)).responseString { response in
            print(response)
        }
    }
}
