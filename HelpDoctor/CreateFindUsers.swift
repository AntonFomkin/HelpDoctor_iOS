//
//  CreateFindUsers.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 29.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

class CreateFindUsers{
    
    var findData: FindUsers
    var findedData: [ResultFindedUsers]? = []
    var jsonModel: Any
    var jsonData: Data?
    var responce: (Int?,String?)?
    
    
    
    init (findData: FindUsers) {
        
        self.findData = findData
        jsonData = nil
        var dataForRequest: [String : Any] = [:]
        
        dataForRequest = ["first_name": findData.first_name as Any,
                          "middle_name": findData.middle_name as Any,
                          "last_name": findData.last_name as Any,
                          "email": findData.email as Any,
                          "phone_number": findData.phone_number as Any,
                          "age_from": findData.age_from as Any,
                          "age_to": findData.age_to as Any,
                          "city_id": findData.city_id as Any,
                          "job_places": findData.job_places as AnyObject,
                          "specializations": findData.specializations as AnyObject,
                          "scientific_interests": findData.scientific_interests as AnyObject,
                          "page": findData.page as Any,
                          "limit": findData.limit as Any]
        
        
        self.jsonModel = dataForRequest
        self.jsonData = todoJSONAny(obj: jsonModel)
    }
    
    init(page: Int, limit: Int) {
        
        self.findData = FindUsers(first_name: nil, middle_name: nil, last_name: nil, email: nil, phone_number: nil, age_from: nil, age_to: nil, city_id: nil, job_places: [], specializations: [], scientific_interests: [], page: page, limit: limit)
        jsonData = nil
        var dataForRequest: [String : Any] = [:]
        
        dataForRequest = ["first_name": findData.first_name as Any,
                          "middle_name": findData.middle_name as Any,
                          "last_name": findData.last_name as Any,
                          "email": findData.email as Any,
                          "phone_number": findData.phone_number as Any,
                          "age_from": findData.age_from as Any,
                          "age_to": findData.age_to as Any,
                          "city_id": findData.city_id as Any,
                          "job_places": findData.job_places as AnyObject,
                          "specializations": findData.specializations as AnyObject,
                          "scientific_interests": findData.scientific_interests as AnyObject,
                          "page": findData.page as Any,
                          "limit": findData.limit as Any]
        
        
        self.jsonModel = dataForRequest
        self.jsonData = todoJSONAny(obj: jsonModel)
    }
}
