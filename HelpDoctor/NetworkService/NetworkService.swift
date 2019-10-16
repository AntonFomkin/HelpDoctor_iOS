//
//  NetworkService.swift
//  HelpDoctor
//
//  Created by Anton Fomkin on 14/10/2019.
//  Copyright © 2019 Anton Fomkin. All rights reserved.
//

import Foundation

class Auth_Info {
    
    static let instance = Auth_Info()
    
    private init(){
        self.token = KeychainWrapper.standard.string(forKey: "myToken")
    }
    
    var token : String? = nil
}

enum TypeOfRequest: String {
    
    case registrationMail = "/registration"
    case recoveryMail = "/recovery"
    case deleteMail = "/registration/del/" /* Temporary method */
    case getToken = "/auth/login"
}

fileprivate func getCurrentSession (typeOfContent: TypeOfRequest,requestParams: [String:String]) -> (URLSession,URLRequest) {
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    var urlConstructor = URLComponents()
    
    urlConstructor.scheme = "http"
    urlConstructor.host = "helpdoctor.tmweb.ru"
    urlConstructor.path = "/public/api" + typeOfContent.rawValue
    
    if typeOfContent == .deleteMail {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + requestParams["email"]!
    }
    
    var request = URLRequest(url: urlConstructor.url!)
    
    switch typeOfContent {
    case .registrationMail,.recoveryMail,.getToken:
        
        
        let jsonData = serializationJSON(obj: requestParams)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
    default :
        break
    }
    
    return (session, request)
}

private func serializationJSON(obj: [String:String]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
}




//MARK: Регистрация Email, восстановление доступа, получение Token
func getData_Registration(typeOfContent: TypeOfRequest, requestParams: [String:String], completionBlock: @escaping ( (Int?,String?) ) -> ()) {
    
    let currentSession = getCurrentSession(typeOfContent: typeOfContent, requestParams: requestParams)
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
                
            case .getToken:
                regMailDataResponse = parseJSON_getToken(for: startPoint, response: response)
                
            }
            
            DispatchQueue.main.async {
                completionBlock(regMailDataResponse)
            }
        }
    }.resume()
}



func prepareRequestParams(email: String, password: String?) -> [String:String] {
    var requestParams: [String:String] = [:]
    requestParams["email"] = email
    
    if password != nil {
        requestParams["password"] = password?.toBase64()
    }
    
    return requestParams
}


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
}




//MARK: Примеры вызова
/*
 // Регистрация Email, Восстановление доступа и удаление - аналогично, password = nil
 // Получение токена - передаем password
 let email = "ImTestHelpDoc@yandex.ru"
 let password = "123456"
 getData_Registration(typeOfContent: .getToken,requestParams: prepareRequestParams(email: email, password: password) ) { [weak self] statusRegistration in
 self?.resultRegMail = statusRegistration
 print(self?.resultRegMail.0 ?? "nil")
 print(self?.resultRegMail.1 ?? "nil")
 }
 */


