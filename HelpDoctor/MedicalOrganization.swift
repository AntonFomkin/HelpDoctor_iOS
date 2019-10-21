//
//  MedicalOrganization.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 21/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

struct MedicalOrganization {
    let id: Int
    let oid: String?
    let nameShort: String?
    let regionId: Int?
    let regionName: String?
    let addrRegionName: String?
    let isFederalCity: String?
    let streetName: String?
    let prefixStreet: String?
    let house: String?
    let areaName: String?
    let prefixArea: String?
}
