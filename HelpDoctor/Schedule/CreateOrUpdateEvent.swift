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
}
