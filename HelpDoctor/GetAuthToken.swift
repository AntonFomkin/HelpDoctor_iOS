//
//  GetAuthToken.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 16/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getToken (for startPoint : [String: AnyObject]?, response: URLResponse?) -> (Int?,String?)? {
    
    guard let status = startPoint?["status"] as? String,
        let token = startPoint?["X-Auth-Token"] as? String,
        let httpResponse = response as? HTTPURLResponse
        else { return (nil,nil) }
    
    let auth = Auth_Info.instance
    auth.token = token
    KeychainWrapper.standard.set(token, forKey: "myToken")
    
    return (httpResponse.statusCode, status)
}
