//
//  ScheduleEvents.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 15.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

struct ScheduleEvents {
    let id: Int?
    let start_date: String
    let end_date: String
    let notify_date: String?
    let title: String?
    let description: String?
    let is_major: Bool?
    let event_place: String?
    let event_type: String
}
