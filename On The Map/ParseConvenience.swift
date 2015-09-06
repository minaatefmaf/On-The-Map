//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Mina Atef on 9/6/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension ParseClient {
    
    func getStudentLocations(completionHandler: (success: Bool, studentLocations: [StudentLocation]?, errorString: String?) -> Void) {
        
        // 1. Specify parameters, methods
        let parameters = [String: String]()
        let mutableMethod = ""
        
        // 2. Make the request
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(success: false, studentLocations: nil, errorString: error.description)
            } else {
                if let results = JSONResult.valueForKey(ParseClient.JSONResponseKeys.Results) as? [[String: AnyObject]] {
                    let studentsLocations = StudentLocation.studentsLocationsFromResults(results)
                    completionHandler(success: true, studentLocations: studentsLocations, errorString: nil)
                } else {
                    completionHandler(success: false, studentLocations: nil, errorString: "Unable to get students locations.")
                }
            }
        }
        
    }
    
}