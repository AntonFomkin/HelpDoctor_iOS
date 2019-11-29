//
//  FindUsers.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 29.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

struct FindUsers {
    let first_name: String?
    let middle_name: String?
    let last_name: String?
    let email: String?
    let phone_number: String?
    let age_from: Int?
    let age_to: Int?
    let city_id: Int?
    let job_places: [String?]
    let specializations: [Int?]
    let scientific_interests: [Int?]
    let page: Int
    let limit: Int
}
