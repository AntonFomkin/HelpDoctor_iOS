//
//  RegistrationMail.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 16/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSONPublicMethod(for startPoint : [String: AnyObject]?, response: URLResponse?) -> (Int?,String?)? {
    
    guard let status = startPoint?["status"] as? String,
        let httpResponse = response as? HTTPURLResponse
        
        else { return (nil,nil) }
    
    return (httpResponse.statusCode, status)
}
