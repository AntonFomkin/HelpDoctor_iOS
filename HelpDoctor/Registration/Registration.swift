//
//  Registration.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 18/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation
import UIKit

final class Registration{

    var email: String
    var password: String?
    var requestParams: [String:String]
    var responce: (Int?,String?)?
 
    init(email: String,password: String?) {
        
        self.email = email
        self.password = password
        requestParams = prepareRequestParams(email: self.email, password: self.password)
    }

}


