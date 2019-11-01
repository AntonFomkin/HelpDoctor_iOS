//
//  UpdateProfileInterest.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 01.11.2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

class UpdateProfileKeyInterest {
    var arrayInterest: [Int] = []
    var jsonData: Data?
    var responce: (Int?,String?)?
    
    init (arrayInterest: [Int]) {
        
        self.arrayInterest = arrayInterest
        jsonData = nil
        
        let jsonModel = ["interests": self.arrayInterest]
        self.jsonData = todoJSON(obj: jsonModel)
    }
}
