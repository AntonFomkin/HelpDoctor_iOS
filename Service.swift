//
//  Service.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 14/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation



enum TypeOfRequest: String {
    
    case registrationMail = "/registration"
    case recoveryMail = "/recovery"
    case deleteMail = "/registration/del/" /* Temporary method */
}

fileprivate func getCurrentSession (typeOfContent: TypeOfRequest,email: String) -> (URLSession,URLRequest) {
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    var urlConstructor = URLComponents()

    urlConstructor.scheme = "http"
    urlConstructor.host = "helpdoctor.tmweb.ru"
    urlConstructor.path = "/public/api" + typeOfContent.rawValue

    if typeOfContent == .deleteMail {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + email
    }

    var request = URLRequest(url: urlConstructor.url!)
    
    switch typeOfContent {
    case .registrationMail,.recoveryMail:
        
        let json: [String: String] = ["email": email]
        let jsonData = serializationJSON(obj: json)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
    
    default :
        break
    }

    return (session, request)
}

func serializationJSON(obj: [String:String]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
 }
 
//MARK: Регистрация Email, восстановление доступа
func getData_Registration(typeOfContent: TypeOfRequest, email: String, completionBlock: @escaping ( (Int?,String?) ) -> ()) {
    
    let currentSession = getCurrentSession(typeOfContent: typeOfContent, email: email)
    let session = currentSession.0
    let request = currentSession.1
    var regMailDataResponse: (Int?,String?)
    
    _ = session.dataTask(with: request) { (data: Data?,
        response: URLResponse?,
        error: Error?) in
        guard let data = data, error == nil else { return }
       
        
        DispatchQueue.global().async() {
            
            guard let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.allowFragments)
                else { return }
            
            guard let startPoint = json as? [String: AnyObject] else { return }
            
            switch typeOfContent {
                case .registrationMail,.recoveryMail,.deleteMail:
                    regMailDataResponse = parseJSON_RegMail(for: startPoint, response: response)
            }
        
            DispatchQueue.main.async {
                completionBlock(regMailDataResponse)
            }
        }
    }.resume()


}


func parseJSON_RegMail (for startPoint : [String: AnyObject]?, response: URLResponse?) -> (Int?,String?) {
   
    guard let status = startPoint?["status"] as? String,
          let httpResponse = response as? HTTPURLResponse
        
    else { return (nil,nil) }
    
    return (httpResponse.statusCode, status)
}

//MARK: Примеры вызова
/*
// Регистрация Email, Восстановление доступа и удаление - аналогично
let email = "ImTestHelpDoc@yandex.ru"
   getData_Registration(typeOfContent: .regMail, email: email ) { [weak self] statusRegistration in

     self?.resultRegMail = statusRegistration
     print(self?.resultRegMail.0 ?? "nil")
     print(self?.resultRegMail.1 ?? "nil")
   }
*/


