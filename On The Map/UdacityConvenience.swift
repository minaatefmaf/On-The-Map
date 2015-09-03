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
    
    func authenticateAndGetUserData(hostViewController: UIViewController, username: String, password: String, completionHandler: (success: Bool, uniqueKey: String?, userData: UdacityUser?, errorString: String?) -> Void) {
        
        // Chain completion handlers for each request so that they run one after the other
        self.postSession(username, password: password) { (success, key, errorString) in
            
            if success {
                completionHandler(success: true, uniqueKey: key, userData: nil, errorString: nil)
            } else {
                completionHandler(success: false, uniqueKey: nil, userData: nil, errorString: errorString)
            }
        }
    }
    
    func postSession(username: String, password: String, completionHandler: (success: Bool, key:String?, errorString: String?) -> Void) {
        
        // 1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [String: String]()
        var mutableMethod : String = Methods.Session
        let jsonBody: [String: [String: String]] = [ "udacity": [
            UdacityClient.JSONBodyKeys.Username: username,
            UdacityClient.JSONBodyKeys.Password: password
            ]
        ]
        
        // 2. Make the request
        let task = taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(success: false, key: nil, errorString: error.description)
            } else {
                if let resultsForSesion = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.Session) as? [String: AnyObject] {
                    if let resultsForAccount = JSONResult.valueForKey(UdacityClient.JSONResponseKeys.Account) as? [String: AnyObject] {
                        if resultsForAccount[UdacityClient.JSONResponseKeys.Registered] as! Int == 1 {
                            let key = resultsForAccount[UdacityClient.JSONResponseKeys.Key] as! String
                            completionHandler(success: true, key: key, errorString: nil)
                        }
                    }
                } else {
                    completionHandler(success: false, key: nil, errorString: "Invalid Email or Password.")
                }
            }
        }
    }
}