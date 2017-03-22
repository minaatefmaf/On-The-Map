//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Mina Atef on 9/1/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension UdacityClient {
    
    // MARK: - Authentication
    
    /* Steps:
        1. POSTing (Creating) a Session
        2. GETting Public User Data
    */
    
    func authenticateAndGetUserData(_ hostViewController: UIViewController, username: String, password: String, completionHandler: @escaping (_ success: Bool, _ uniqueKey: String?, _ userData: UdacityUser?, _ errorString: String?) -> Void) {
        
        // Chain completion handlers for each request so that they run one after the other
        
        // 1. POSTing (Creating) a Session
        postSession(username, password: password) { (success, uniqueKey, errorString) in
            
            if success {
                // 2. GETting Public User Data
                self.getPublicUserData(uniqueKey) { (success, uniqueKey, userData, errorString) in
                    
                    if success {
                        completionHandler(true, uniqueKey, userData, nil)
                    } else {
                        completionHandler(false, uniqueKey, nil, errorString)
                    }
                    
                }
            } else {
                completionHandler(false, nil, nil, errorString)
            }
        }
    }
    
    func postSession(_ username: String, password: String, completionHandler: @escaping (_ success: Bool, _ uniqueKey:String?, _ errorString: String?) -> Void) {
        
        // 1. Specify parameters, method
        let parameters = [String: String]()
        let mutableMethod : String = Methods.Session
        let jsonBody: [String: [String: String]] = [ "udacity": [
            UdacityClient.JSONBodyKeys.Username: username,
            UdacityClient.JSONBodyKeys.Password: password
            ]
        ]
        
        // 2. Make the request
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String : AnyObject], jsonBody: jsonBody as [String : AnyObject]) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(false, nil, error.localizedDescription)
            } else {
                if let _ = JSONResult?.value(forKey: UdacityClient.JSONResponseKeys.Session) as? [String: AnyObject] {
                    if let resultsForAccount = JSONResult?.value(forKey: UdacityClient.JSONResponseKeys.Account) as? [String: AnyObject] {
                        if resultsForAccount[UdacityClient.JSONResponseKeys.Registered] as! Bool == true {
                            let key = resultsForAccount[UdacityClient.JSONResponseKeys.Key] as! String
                            completionHandler(true, key, nil)
                        }
                    }
                } else {
                    completionHandler(false, nil, "Invalid Email or Password.")
                }
            }
        }
        
    }
    
    func getPublicUserData(_ uniqueKey: String?, completionHandler:@escaping (_ success: Bool, _ uniqueKey: String?, _ userData: UdacityUser?, _ errorString: String?) -> Void) {
        
        // 1. Specify parameters, method (if has {key})
        let parameters = [String: String]()
        var mutableMethod: String = Methods.UserId
        mutableMethod = UdacityClient.subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(uniqueKey!))!
        
        // 2. Make the request
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String : AnyObject]) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(false, uniqueKey, nil, error.localizedDescription)
            } else {
                if let resultsForUser = JSONResult?.value(forKey: UdacityClient.JSONResponseKeys.User) as? [String: AnyObject] {
                    if let resultsForFirstName = resultsForUser[UdacityClient.JSONResponseKeys.FirstName] as? String,
                    let resultsForAccountLastName = resultsForUser[UdacityClient.JSONResponseKeys.LastName] as? String {
                        let userData = UdacityUser(firstName: resultsForFirstName, lastName: resultsForAccountLastName)
                        completionHandler(true, uniqueKey, userData, nil)
                        }
                } else {
                    completionHandler(false, uniqueKey, nil, "Unable to get user data.")
                }
            }
        }
        
    }
    
    func deleteSession() {
        
        // 1. Specify parameters, method
        let parameters = [String: String]()
        let mutableMethod : String = Methods.Session
        
        // 2. Make the request
        let _ = taskForDELETEMethod(mutableMethod, parameters: parameters as [String : AnyObject]) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let _ = JSONResult?.value(forKey: UdacityClient.JSONResponseKeys.Session) as? [String: AnyObject] {
                   /* println("****************************")
                    println("Deleting the session")
                    println(resultsForSesion)
                    println("****************************") */
                } else {
                   // println("Unable to delete the session.")
                }
            }
        }

    }
    
}
