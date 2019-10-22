//
//  GetMedicalOrganization.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 21/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getMedicalOrganization (for startPoint : [AnyObject]?, response: URLResponse?) -> ([MedicalOrganization],Int?,String?)? {
    var arrMedicalOrg: [MedicalOrganization] = []
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([],nil,nil) }
    
    guard let startPoint = startPoint else { return ([],nil,nil) }
    
    for finalObj in startPoint { 
        guard  let obj  = finalObj as? [String: Any] else  { return ([],nil,nil) }
        
        arrMedicalOrg.append(MedicalOrganization(id: obj["id"] as! Int,
                                                 oid: obj["oid"] as? String,
                                                 nameShort: obj["nameShort"] as? String,
                                                 regionId: obj["regionId"] as? Int,
                                                 regionName: obj["regionName"] as? String,
                                                 addrRegionName: obj["addrRegionName"] as? String,
                                                 isFederalCity: obj["isFederalCity"] as? String,
                                                 streetName: obj["streetName"] as? String,
                                                 prefixStreet: obj["prefixStreet"] as? String,
                                                 house: obj["house"] as? String,
                                                 areaName: obj["areaName"] as? String,
                                                 prefixArea: obj["prefixArea"] as? String)
        )
    }
    return (arrMedicalOrg,httpResponse.statusCode, nil)
}
