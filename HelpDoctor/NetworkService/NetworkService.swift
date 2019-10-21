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

var myToken: String? { 
    let getToken = Auth_Info.instance
    return getToken.token
}

enum TypeOfRequest: String {
    /*Регистрация*/
    case registrationMail = "/registration"
    case recoveryMail = "/recovery"
    case deleteMail = "/registration/del/" /* Temporary method */
    
    /* Получение токена*/
    case getToken = "/auth/login"
    
    /* Разлогиниться */
    case logout = "/auth/logout"
    
    case getRegions = "/profile/regions"
    case getListCities = "/profile/cities/"
    case getMedicalOrganization = "/profile/works/"
}

func getCurrentSession (typeOfContent: TypeOfRequest,requestParams: [String:String]) -> (URLSession,URLRequest) {
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    var urlConstructor = URLComponents()
    
    urlConstructor.scheme = "http"
    urlConstructor.host = "helpdoctor.tmweb.ru"
    urlConstructor.path = "/public/api" + typeOfContent.rawValue
    
    if typeOfContent == .deleteMail {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + requestParams["email"]!
    }
    
    if typeOfContent == .getListCities || typeOfContent == .getMedicalOrganization  {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + requestParams["region"]!
    }
 
    var request = URLRequest(url: urlConstructor.url!)
    
    switch typeOfContent {
    case .registrationMail,.recoveryMail,.getToken,.logout:
        
        
        let jsonData = serializationJSON(obj: requestParams)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if typeOfContent == .logout {
            request.setValue(myToken, forHTTPHeaderField: "X-Auth-Token")
        } else {
            request.httpBody = jsonData
        }
        
    default :
        break
    }
    return (session, request)
}

private func serializationJSON(obj: [String:String]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
}


func getData<T>(typeOfContent: TypeOfRequest,returning: T.Type, requestParams: [String:String], completionBlock: @escaping (T?) -> () ) -> () {
    
    let currentSession = getCurrentSession(typeOfContent: typeOfContent, requestParams: requestParams)
    let session = currentSession.0
    let request = currentSession.1
    var regMailDataResponse:T?//(Int?,String?)
    
    _ = session.dataTask(with: request) { (data: Data?,
        response: URLResponse?,
        error: Error?) in
        guard let data = data, error == nil else { return }
        
        DispatchQueue.global().async() {
            
            guard let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.allowFragments)
                else { return }
            
            switch typeOfContent {
            case .registrationMail,.recoveryMail,.deleteMail,.logout:
                guard let startPoint = json as? [String: AnyObject] else { return }
                regMailDataResponse = (parseJSON_RegMail(for: startPoint, response: response) as? T)
            case .getToken:
                guard let startPoint = json as? [String: AnyObject] else { return }
                regMailDataResponse = (parseJSON_getToken(for: startPoint, response: response) as? T)
            case .getRegions :
                guard let httpResponse = response as? HTTPURLResponse else {return}
                if httpResponse.statusCode != 200 {
                    regMailDataResponse = (([],500,"Данные недоступны") as? T)
                } else {
                    guard let startPoint = json as? [AnyObject] else { return }
                    regMailDataResponse = (parseJSON_getRegions(for: startPoint, response: response) as? T)
                }
            case .getListCities :
                guard let httpResponse = response as? HTTPURLResponse else {return}
                if httpResponse.statusCode != 200 {
                    regMailDataResponse = (([],500,"Данные недоступны") as? T)
                } else {
                    guard let startPoint = json as? [AnyObject] else { return }
                    regMailDataResponse = (parseJSON_getCities(for: startPoint, response: response) as? T)
                }
                
            case .getMedicalOrganization:
                guard let httpResponse = response as? HTTPURLResponse else {return}
                if httpResponse.statusCode != 200 {
                    regMailDataResponse = (([],500,"Данные недоступны") as? T)
                } else {
                    guard let startPoint = json as? [AnyObject] else { return }
                    regMailDataResponse = (parseJSON_getMedicalOrganization(for: startPoint, response: response) as? T)
                }
            }
            
            DispatchQueue.main.async {
                completionBlock(regMailDataResponse)
            }
        }
    }.resume()
}


func prepareRequestParams(email: String?, password: String?,token:String?) -> [String:String] {
    var requestParams: [String:String] = [:]
    
    if email != nil {
        requestParams["email"] = email
    }
    
    if password != nil {
        requestParams["password"] = password?.toBase64()
    }
    
    if token != nil {
        requestParams["X-Auth-Token"] = token
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
let getToken = Registration.init(email: "intellsystem@yandex.ru", password: "zNyF9Tts3r", token: nil)

getData(typeOfContent:.getToken,
        returning:(Int?,String?).self,
        requestParams: getToken.requestParams )
{ [weak self] result in
    let dispathGroup = DispatchGroup()
    getToken.responce = result
    
    dispathGroup.notify(queue: DispatchQueue.main) {
        DispatchQueue.main.async { [weak self]  in
            print("result= \(getToken.responce)")
        }
    }
}
*/

/* -------------- */

/*
 let logout = Registration.init(email: nil, password: nil, token: myToken )
 
 getData(typeOfContent:.logout,
         returning:(Int?,String?).self,
         requestParams: logout.requestParams )
 { [weak self] result in
     let dispathGroup = DispatchGroup()
     logout.responce = result
     
     dispathGroup.notify(queue: DispatchQueue.main) {
         DispatchQueue.main.async { [weak self]  in
             print("result=\(logout.responce)")
         }
     }
 }
 */

/* -------------- */

/*
    let getMedicalOrganization = Profile()
    
    getData(typeOfContent:.getMedicalOrganization,
            returning:([MedicalOrganization],Int?,String?).self,
            requestParams: ["region":"77"] )
    { [weak self] result in
        let dispathGroup = DispatchGroup()

        getMedicalOrganization.medicalOrganization = result?.0
        getMedicalOrganization.responce = (result?.1,result?.2)
        dispathGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async { [weak self]  in
                print("result=\(getMedicalOrganization.medicalOrganization)")
                print(getMedicalOrganization.responce)
                
            }
        }
    }
*/
