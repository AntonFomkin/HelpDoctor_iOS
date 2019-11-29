//
//  ResultFindedUsers.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 29.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

struct ResultFindedUsers {
    let user: ProfileKeyUser
    let job_places: [ProfileKeyJob]?
    let specializations: [ProfileKeySpec]?
}
