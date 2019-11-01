//
//  GetMedicalSpecialization.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 23.10.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getMedicalSpecialization (for startPoint : [AnyObject]?, response: URLResponse?) -> ([MedicalSpecialization],Int?,String?)? {
    var arrMedicalSpec: [MedicalSpecialization] = []
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([],nil,nil) }
    
    guard let startPoint = startPoint else { return ([],nil,nil) }
    
    for finalObj in startPoint {
        guard  let obj  = finalObj as? [String: Any] else  { return ([],nil,nil) }
        
        arrMedicalSpec.append(MedicalSpecialization(id: obj["id"] as! Int,
                                                    code: obj["code"] as? String,
                                                    name: obj["name"] as? String,
                                                    parent_id: obj["parent_id"] as? Int)

        )
    }
    return (arrMedicalSpec,httpResponse.statusCode, nil)
}
