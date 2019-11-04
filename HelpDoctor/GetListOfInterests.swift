//
//  GetListOfInterests.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 28.10.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getListOfInterests(for startPoint : [String:AnyObject]?, response: URLResponse?) -> ([String: [ListOfInterests]],Int?,String?)? {
    var arrListOfInterests: [ListOfInterests] = []
    var dictListOfInterests: [String:[ListOfInterests]] = [:]
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([:],nil,nil) }
    
    guard let startPoint = startPoint else { return ([:],nil,nil) }
    
    for (key,_) in startPoint {

        arrListOfInterests = []
        let arrItems = startPoint[key] as! [AnyObject]
        
        for finalObj in arrItems {
            guard  let obj  = finalObj as? [String: Any] else  { return ([:],nil,nil) }
            arrListOfInterests.append(ListOfInterests(id: obj["id"] as! Int, specializationCode: obj["specialization_code"] as? String, name: obj["name"] as? String))
        }
        dictListOfInterests[key] = arrListOfInterests
    }
    
    return (dictListOfInterests,httpResponse.statusCode, nil)
}
