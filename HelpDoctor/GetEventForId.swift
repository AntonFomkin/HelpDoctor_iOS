//
//  GetEventForId.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 16.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

func parseJSON_getEventForId(for startPoint : [String:Any]?, response: URLResponse?) -> ([ScheduleEvents],Int?,String?)? {
   
    var event: ScheduleEvents
    
    guard  let httpResponse = response as? HTTPURLResponse
        else { return ([],nil,nil) }
    
    guard let startPoint = startPoint else { return ([],nil,nil) }
    
    event = ScheduleEvents(id: startPoint["id"] as? Int, start_date: startPoint["start_date"] as! String, end_date: startPoint["end_date"] as! String, notify_date: startPoint["notify_date"] as? String, title: startPoint["title"] as? String, description: startPoint["description"] as? String, is_major: startPoint["is_major"] as? Bool, event_place: startPoint["event_place"] as? String, event_type: startPoint["event_type"] as! String)

    return ([event],httpResponse.statusCode, nil)
}
