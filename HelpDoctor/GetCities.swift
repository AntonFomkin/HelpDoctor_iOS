//
//  GetCities.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 21/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getCities (for startPoint : [AnyObject]?, response: URLResponse?) -> ([Cities],Int?,String?)? {
    var arrCities: [Cities] = []
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([],nil,nil) }
    
    guard let startPoint = startPoint else { return ([],nil,nil) }
    
    for finalObj in startPoint {
        guard  let obj  = finalObj as? [String: Any] else  { return ([],nil,nil) }
        arrCities.append(Cities(id: obj["id"] as! Int, cityName: obj["cityName"] as? String))
    }    
    return (arrCities,httpResponse.statusCode, nil)
}
