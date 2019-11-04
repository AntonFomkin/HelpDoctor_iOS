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
    case getMedicalSpecialization = "/profile/specializations"
    case getListOfInterests = "/profile/sc_interests/"
    case getListOfInterestsExtOne = "/profile/sc_interests_speccode1/"
    case getListOfInterestsExtTwo = "/profile/sc_interests_speccode2/"
    case checkProfile = "/profile/check"
    case updateProfile = "/profile/update"
    case getDataFromProfile = "/profile/get"
}

func getCurrentSession (typeOfContent: TypeOfRequest,requestParams: [String:Any]) -> (URLSession,URLRequest) {
    
    let configuration = URLSessionConfiguration.default
    let session =  URLSession(configuration: configuration)
    var urlConstructor = URLComponents()
    
    urlConstructor.scheme = "http"
    urlConstructor.host = "helpdoctor.tmweb.ru"
    urlConstructor.path = "/public/api" + typeOfContent.rawValue
    
    if typeOfContent == .deleteMail {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + (requestParams["email"] as! String)
    }
    
    if typeOfContent == .getListCities || typeOfContent == .getMedicalOrganization  {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + (requestParams["region"] as! String)
    }
    
    if typeOfContent == .getListOfInterestsExtOne || typeOfContent == .getListOfInterestsExtTwo   {
        urlConstructor.path = "/public/api" + typeOfContent.rawValue + (requestParams["spec_code"] as! String)
    }
    var request = URLRequest(url: urlConstructor.url!)
    
    switch typeOfContent {
    case .registrationMail,.recoveryMail,.getToken,.logout,.checkProfile, .getDataFromProfile:
        
        let jsonData = serializationJSON(obj: requestParams as! [String : String])
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if typeOfContent == .logout || typeOfContent == .checkProfile || typeOfContent == .getDataFromProfile {
            request.setValue(myToken, forHTTPHeaderField: "X-Auth-Token")
        } else {
            request.httpBody = jsonData
        }
    case .updateProfile:
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(myToken, forHTTPHeaderField: "X-Auth-Token")
        request.httpBody = requestParams["json"] as? Data
    default :
        break
    }
    return (session, request)
}

private func serializationJSON(obj: [String:String]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
}


func getData<T>(typeOfContent: TypeOfRequest,returning: T.Type, requestParams: [String:Any], completionBlock: @escaping (T?) -> () ) -> () {
    
    let currentSession = getCurrentSession(typeOfContent: typeOfContent, requestParams: requestParams)
    let session = currentSession.0
    let request = currentSession.1
    var replyReturn:T?
    
    _ = session.dataTask(with: request) { (data: Data?,
        response: URLResponse?,
        error: Error?) in
        guard let data = data, error == nil else { return }
        
        DispatchQueue.global().async() {
            
            guard let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.allowFragments)
                else { return }
            
            guard let httpResponse = response as? HTTPURLResponse else {return}
            let responceTrueResult = responceCode(code: httpResponse.statusCode)
            
            
            switch typeOfContent {
            case .registrationMail,.recoveryMail,.deleteMail,.logout,.checkProfile,.updateProfile:
                guard let startPoint = json as? [String: AnyObject] else { return }
                replyReturn = (parseJSONPublicMethod(for: startPoint, response: response) as? T)
            case .getToken:
                guard let startPoint = json as? [String: AnyObject] else { return }
                replyReturn = (parseJSON_getToken(for: startPoint, response: response) as? T)
            case .getRegions :
                
                if responceTrueResult {
                    guard let startPoint = json as? [AnyObject] else { return }
                    replyReturn = (parseJSON_getRegions(for: startPoint, response: response) as? T)
                } else {
                    replyReturn = (([],500,"Данные недоступны") as? T)
                }
            case .getListCities :
                
                if responceTrueResult {
                    guard let startPoint = json as? [AnyObject] else { return }
                    replyReturn = (parseJSON_getCities(for: startPoint, response: response) as? T)
                } else {
                    replyReturn = (([],500,"Данные недоступны") as? T)
                }
                
            case .getMedicalOrganization:
                
                if responceTrueResult {
                    guard let startPoint = json as? [AnyObject] else { return }
                    replyReturn = (parseJSON_getMedicalOrganization(for: startPoint, response: response) as? T)
                } else {
                    replyReturn = (([],500,"Данные недоступны") as? T)
                }
            case .getMedicalSpecialization:
                
                if responceTrueResult {
                    guard let startPoint = json as? [AnyObject] else { return }
                    replyReturn = (parseJSON_getMedicalSpecialization(for: startPoint, response: response) as? T)
                } else {
                    replyReturn = (([],500,"Данные недоступны") as? T)
                }
            case .getListOfInterests, .getListOfInterestsExtOne,.getListOfInterestsExtTwo:
                
                if responceTrueResult {
                    guard let startPoint = json as? [String:AnyObject] else { return }
                    replyReturn = (parseJSON_getListOfInterests(for: startPoint, response: response) as? T)
                } else {
                    replyReturn = (([],500,"Данные недоступны") as? T)
                }
                
                case .getDataFromProfile:
                    
                    if responceTrueResult {
                        guard let startPoint = json as? [String:AnyObject] else { return }
                        replyReturn = (parseJSON_getDataFromProfile(for: startPoint, response: response) as? T)
                    } else {
                        replyReturn = (([],500,"Данные недоступны") as? T)
                    }
                
            }
            
            DispatchQueue.main.async {
                completionBlock(replyReturn)
            }
        }
    }.resume()
}

func responceCode(code: Int) -> Bool {
    if code == 200 {
        return true
    } else {
        return false
    }
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

func todoJSON(obj: [String:Any]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
}

func todoJSON_Array(obj: [String:[Any]]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: obj)
}

//MARK: Примеры вызова
/*
 let getToken = Registration.init(email: "test@yandex.ru", password: "zNyF9Tts3r", token: nil)
 
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

/* -------------- */

/*
 let getListOfInterest = Profile()
 
 getData(typeOfContent:.getListOfInterestsExtTwo,
 returning:([String:[ListOfInterests]],Int?,String?).self,
 requestParams: ["spec_code":"040100/040101"] )
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 getListOfInterest.listOfInterests = result?.0
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 
 print("ListOfInterest = \(getListOfInterest.listOfInterests!)")
 }
 }
 }
 */

/* -------------- */

/*
 let getCities = Profile()
 
 getData(typeOfContent:.getListCities,
 returning:([Cities],Int?,String?).self,
 requestParams: ["region":"77"] )
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 getCities.cities = result?.0
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("Cities= \(getCities.cities!)")
 }
 }
 }
 */

/* -------------- */

/*
 let checkProfile = Registration.init(email: nil, password: nil, token: myToken )
 
 getData(typeOfContent:.checkProfile,
 returning:(Int?,String?).self,
 requestParams: checkProfile.requestParams )
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 checkProfile.responce = result
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("result=\(checkProfile.responce)")
 }
 }
 }
 */

/* --------API 12---------- */

/*
 let updateProfile = UpdateProfileKeyUser(first_name: "Антон", last_name: "Иванов", middle_name: nil, phone_number: "1234567", city_id: 77, foto: "zxcvbnm")
 
 getData(typeOfContent:.updateProfile,
 returning:(Int?,String?).self,
 requestParams: ["json":updateProfile.jsonData as Any] )
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 updateProfile.responce = result
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("updateProfile = \(updateProfile.responce)")
 }
 }
 }
 
 */
/*
 let a: Int? = nil
 let job1 : [String:Any] = ["id": a, "job_oid": "qwert", "is_main": true]
 let job2 : [String:Any] = ["id": a, "job_oid": "qwert1", "is_main": false]
 
 var arr : [Dictionary<String,Any>] = []
 arr.append(job1)
 arr.append(job2)
 
 
 let updateProfile = UpdateProfileKeyJob(arrayJob: arr)
 
 getData(typeOfContent:.updateProfile,
 returning:(Int?,String?).self,
 requestParams: ["json":updateProfile.jsonData as Any])
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 updateProfile.responce = result
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("updateProfile = \(updateProfile.responce)")
 }
 }
 }
 */
/*
 let a: Int? = nil
 let spec1 : [String:Any] = ["id": a, "spec_id": 9, "is_main": true]
 let spec2 : [String:Any] = ["id": a, "spec_id": 10, "is_main": false]
 
 var arr : [Dictionary<String,Any>] = []
 arr.append(spec1)
 arr.append(spec2)
 
 
 let updateProfile = UpdateProfileKeySpec(arraySpec: arr)
 
 getData(typeOfContent:.updateProfile,
 returning:(Int?,String?).self,
 requestParams: ["json":updateProfile.jsonData as Any])
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 updateProfile.responce = result
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("updateProfile = \(updateProfile.responce)")
 }
 }
 }
 */

/*
 var arr : [Int] = [1,2,3,4,5,6,7]
 
 
 let updateProfile = UpdateProfileKeyInterest(arrayInterest: arr)
 
 getData(typeOfContent:.updateProfile,
 returning:(Int?,String?).self,
 requestParams: ["json":updateProfile.jsonData as Any])
 { [weak self] result in
 let dispathGroup = DispatchGroup()
 
 updateProfile.responce = result
 
 dispathGroup.notify(queue: DispatchQueue.main) {
 DispatchQueue.main.async { [weak self]  in
 print("updateProfile = \(updateProfile.responce)")
 }
 }
 }
 */

/* --------API 13-------------*/

/*
    let getDataProfile = Profile()
    
    getData(typeOfContent:.getDataFromProfile,
            returning:([String:[AnyObject]],Int?,String?).self,
            requestParams: [:] )
    { [weak self] result in
        let dispathGroup = DispatchGroup()

        getDataProfile.dataFromProfile = result?.0
        
        dispathGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async { [weak self]  in
                print("getDataProfile = \(getDataProfile.dataFromProfile!)")
            }
        }
    }
 
 */
