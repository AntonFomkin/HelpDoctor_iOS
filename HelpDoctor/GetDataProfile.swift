//
//  GetDataProfile.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 03.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getDataFromProfile(for startPoint : [String:AnyObject]?, response: URLResponse?) -> ([String: [AnyObject]],Int?,String?)? {
    
    var profileKeyUser: [ProfileKeyUser] = []
    var profileKeyJob: [ProfileKeyJob] = []
    var profileKeySpec: [ProfileKeySpec] = []
    var profileKeyInterests: [ProfileKeyInterests] = []
    var dataProfile: [String:[AnyObject]] = [:]
    
    
    //let key = "general"
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([:],nil,nil) }
    
    guard var startPoint = startPoint else { return ([:],nil,nil) }
    
    let user = startPoint["user"] as! [String:Any]
    profileKeyUser.append(ProfileKeyUser(id: user["id"] as? Int, first_name: user["first_name"] as? String, last_name: user["last_name"] as? String, middle_name: user["middle_name"] as? String, email: user["email"] as? String, phone_number: user["phone_number"] as? String, city_id: user["city_id"] as? Int, cityName: user["cityName"] as? String, foto: user["foto"] as? String))
    
    dataProfile["user"] = profileKeyUser as [AnyObject]
    startPoint.removeValue(forKey: "user")
    
    for (key,_) in startPoint {
        
        let arrItems = startPoint[key] as! [AnyObject]
        
        for finalObj in arrItems {
            guard  let obj  = finalObj as? [String: Any] else  { return ([:],nil,nil) }
            
            if key == "interests" {
                profileKeyInterests.append(ProfileKeyInterests(interest_id: obj["interest_id"] as? Int, spec_code: obj["spec_code"] as? String, name: obj["name"] as? String))
            }
            
            if key == "job" {
                profileKeyJob.append(ProfileKeyJob(id: obj["id"] as? Int, job_oid: obj["job_oid"] as? String, is_main: obj["is_main"] as? Bool, nameShort: obj["nameShort"] as? String))
            }
            
            if key == "spec" {
                profileKeySpec.append(ProfileKeySpec(id: obj["id"] as? Int, spec_id: obj["spec_id"] as? Int, is_main: obj["is_main"] as? Bool, code: obj["code"] as? String,name: obj["name"] as? String))
            }
        }
        if key == "interests" { dataProfile[key] = profileKeyInterests as [AnyObject] }
        if key == "job" { dataProfile[key] = profileKeyJob as [AnyObject] }
        if key == "spec" { dataProfile[key] = profileKeySpec as [AnyObject] }
    }
    
    return (dataProfile,httpResponse.statusCode, nil)
}

