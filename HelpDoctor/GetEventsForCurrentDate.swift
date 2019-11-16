//
//  GetEventsForCurrentDate.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 15.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getEventsForCurrentDate(for startPoint : [AnyObject]?, response: URLResponse?) -> ([ScheduleEvents],Int?,String?)? {
    var arrEvents: [ScheduleEvents] = []
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([],nil,nil) }
    
    guard let startPoint = startPoint else { return ([],nil,nil) }
    
    for finalObj in startPoint {
        guard  let obj  = finalObj as? [String: Any] else  { return ([],nil,nil) }
        
        arrEvents.append(ScheduleEvents(id: obj["id"] as? Int, start_date: obj["start_date"] as! String, end_date: obj["end_date"] as! String, notify_date: obj["notify_date"] as? String, title: obj["title"] as? String, description: obj["description"] as? String, is_major: obj["is_major"] as? Bool, event_place: obj["event_place"] as? String, event_type: obj["event_type"] as! String))
  
    }
    return (arrEvents,httpResponse.statusCode, nil)
}


