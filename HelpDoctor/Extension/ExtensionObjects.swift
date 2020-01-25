//
//  ExtensionObjects.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 24.01.2020.
//  Copyright © 2020 Anton Fomkin. All rights reserved.
//

import UIKit

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func base64ToImage() -> UIImage? {
        return UIImage(data: Data(base64Encoded: self, options: .ignoreUnknownCharacters)!)
    }
}

extension UIImage {
    
    func toBase64String() -> String? {
        return String(utf8String: (self.pngData()! as Data).base64EncodedString(options: .lineLength64Characters))
    }
}


