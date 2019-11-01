//
//  Registration.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 18/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

final class Registration {
    
    var email: String?
    var password: String?
    var token: String?
    var requestParams: [String:String]
    var responce: (Int?,String?)?
    
    init(email: String?,password: String?, token:String?) {
        
        self.email = email
        self.password = password
        self.token = token
        requestParams = prepareRequestParams(email: self.email, password: self.password, token: self.token)
    }

}


