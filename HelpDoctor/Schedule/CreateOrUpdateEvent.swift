//
//  CreateOrUpdateEvent.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 15.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

class CreateOrUpdateEvent{

    var events: ScheduleEvents
  /*
    var id: Int?
    var start_date: String
    var end_date: String
    var notify_date: String?
    var title: String?
    var description: String?
    var is_major: Bool?
    var event_place: String?
    var event_type: String
   */
    var jsonModel : [String:Any] = [:]
    var jsonData: Data?
    var responce: (Int?,String?)?
   
    init (events: ScheduleEvents) {
        self.events = events
            jsonModel = [:]
            jsonData = nil
            var dataUser: [String : Any] = [:]
            
        if self.events.id != nil {
                dataUser = ["id":events.id as Any, "start_date":events.start_date as Any, "end_date":events.end_date as Any, "notify_date":events.notify_date as Any, "title":events.title as Any, "description":events.description as Any, "is_major":events.is_major as Any, "event_place":events.event_place as Any, "event_type":events.event_type as Any
                ]
            } else {
                dataUser = ["start_date":events.start_date as Any, "end_date":events.end_date as Any, "notify_date":events.notify_date as Any, "title":events.title as Any, "description":events.description as Any, "is_major":events.is_major as Any, "event_place":events.event_place as Any, "event_type":events.event_type as Any
                ]
            }
        
            self.jsonModel = ["event": dataUser]
            self.jsonData = todoJSON(obj: jsonModel)
    }
    
   /*
    init (
        id: Int?,start_date: String, end_date: String,notify_date: String?,title: String?,
        description: String?, is_major: Bool?,event_place: String?,event_type: String)
    {
    
        self.id = id
        self.start_date = start_date
        self.end_date = end_date
        self.notify_date = notify_date
        self.title = title
        self.description = description
        self.is_major = is_major
        self.event_place = event_place
        self.event_type = event_type
        
        jsonModel = [:]
        jsonData = nil
        var dataUser: [String : Any] = [:]
        
        if id != nil {
            dataUser = ["id":id as Any, "start_date":start_date as Any, "end_date":end_date as Any, "notify_date":notify_date as Any, "title":title as Any, "description":description as Any, "is_major":is_major as Any, "event_place":event_place as Any, "event_type":event_type as Any
            ]
        } else {
            dataUser = ["start_date":start_date as Any, "end_date":end_date as Any, "notify_date":notify_date as Any, "title":title as Any, "description":description as Any, "is_major":is_major as Any, "event_place":event_place as Any, "event_type":event_type as Any
            ]
        }
    
        self.jsonModel = ["event": dataUser]
        self.jsonData = todoJSON(obj: jsonModel)
     /*
        let  json = try? JSONSerialization.jsonObject(with: jsonData!,
        options: JSONSerialization.ReadingOptions.allowFragments)
        print(json as Any)
      */
    }
 */
}
