//
//  RegisterRepository.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/04.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import NaverThirdPartyLogin
import GoogleSignIn

#if canImport(FoundationNetworking)
import FoundationNetworking
import UIKit
//import XCTest
#endif

///wraps up database, networking, and data source handling logic for registering account
class LoginRepository {
    
    private var semaphore = DispatchSemaphore (value: 0)
    
    private let apiKey = "f330b07acf479c98b184db47a4d2608b" //for Naver
    
    private let baseAPIURL = "https://kream-waffle.cf/accounts" //server
    
    private let userDefaults = UserDefaults.standard
    
    init() {}
    
    //-MARK: User Defaults (called when app is first opened and closed)
    
    ///save current user when ending app
    func saveUser(user: User) {
        userDefaults.set(try? PropertyListEncoder().encode(user), forKey: "savedUser")
    }
    
    ///get saved user if there is one
    func getUser()->User?{
    if let storedObject: Data = UserDefaults.standard.object(forKey: "savedUser") as? Data {
                    return try? PropertyListDecoder().decode(User.self, from: storedObject)
        }
    return nil
    }
    
    ///remove saved user when logging out
    func logOutUser(){
        userDefaults.removeObject(forKey: "savedUser")
        //GIDSignIn.sharedInstance()?.signOut()
        //NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
    }
       
    //-MARK: Login account with custom server
    func loginAccount(email: String, password: String, completion: @escaping (Result<UserResponse, LoginError>) -> ()){
        
        let URLString = "\(baseAPIURL)/login/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("url error")
            return
        }
        
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let parameters = [
            "email": email,
            "password": password,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    let results : UserResponse = try JSONDecoder().decode(UserResponse.self, from: data!)
                    self.saveUser(user: results.user)
                    print("LoginRepository: User is", results.user)
                    completion(.success(results))
                }catch{
                    print(error)
                    completion(.failure(.unknownError))
                }
                
            case .failure(let error):
                let json = String(data: response.data!, encoding: String.Encoding.utf8)
                let loginError = checkErrorMessage(String(describing: json))
                completion(.failure(loginError))
                print(error)
            }
        }
    }
    
    ///with Naver's access token, get user info from custom server
    func loginWithSocial(socialToken: String, socialType: Social ,completion: @escaping (Result<UserResponse, LoginError>) -> ()){
        
        var URLString = ""
        switch (socialType){
        case .Naver:
            URLString = "\(baseAPIURL)/social/naver?token=\(socialToken)"
        case .Google:
            URLString = "\(baseAPIURL)/social/google?token=\(socialToken)"
        }
        
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    let results : UserResponse = try JSONDecoder().decode(UserResponse.self, from: data!)
                    self.saveUser(user: results.user)
                    print("[Log] Login Repository: Logeed in with ", socialType, results.user)
                    completion(.success(results))
                }catch{
                    completion(.failure(.unknownError))
                    //let json = String(data: response.data!, encoding: String.Encoding.utf8)
                    //print(String(describing: json))
                    print("[Log] LoginRepo: Error is \(error)")
                }
                
            case .failure(let error):
                //let json = String(data: response.data!, encoding: String.Encoding.utf8)
                //let loginError = checkErrorMessage(String(describing: json))
                completion(.failure(.unknownError))
                print(error)
            }
            
        }
    }
          
    ///custom registeration
    func registerAccount(with email: String, password: String, shoe_size: Int, completion: @escaping (Result<Bool, LoginError>) -> ()){
        let URLString = "\(baseAPIURL)/registration/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let parameters = [
            "email": email,
            "password1": password,
            "password2": password,
            "shoe_size": shoe_size,
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    print("[Log] Login Repository: ", data)
                    completion(.success(true))
                }catch{
                    completion(.failure(.signupError))
                }
            case .failure(let error):
                //TODO 에러 종류 바꾸기
                completion(.failure(.signupError))
                print(error)
            }
        }
    }
    
    func requestFollow(token: String, user_id: Int, onNetworkFailure: @escaping ()->()) {
        //request follow using user_id
        let urlStr = "https://kream-waffle.cf/styles/profiles/\(user_id)/follow/"
        
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlStr, method: .patch, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    debugPrint(response)
                    return
                case .failure:
                    debugPrint(response)
                    onNetworkFailure()
                }
            }
    }
}
