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
    
    func getStudentLocations(_ completionHandler: @escaping (_ success: Bool, _ studentLocations: [StudentLocation]?, _ errorString: String?) -> Void) {
        
        // 1. Specify parameters, methods
        let parameters = [String: String]()
        let mutableMethod = ParseClient.Methods.StudentLocationPath
        
        // 2. Make the request
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String : AnyObject]) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(false, nil, error.localizedDescription)
            } else {
                if let results = JSONResult?.value(forKey: ParseClient.JSONResponseKeys.Results) as? [[String: AnyObject]] {
                    let studentsLocations = StudentLocation.studentsLocationsFromResults(results)
                    completionHandler(true, studentsLocations, nil)
                } else {
                    completionHandler(false, nil, "Unable to get students locations.")
                }
            }
        }
        
    }
    
    
    func postStudentLocation(_ userData: StudentLocation, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // 1. Specify parameters, method
        let parameters = [String: String]()
        let mutableMethod = ParseClient.Methods.StudentLocationPath
        let jsonBody: [String: AnyObject] = [
            ParseClient.JSONBodyKeys.UniqueKey: userData.uniqueKey as AnyObject,
            ParseClient.JSONBodyKeys.FirstName: userData.firstName as AnyObject,
            ParseClient.JSONBodyKeys.Lastname: userData.lastName as AnyObject,
            ParseClient.JSONBodyKeys.MapString: userData.mapString as AnyObject,
            ParseClient.JSONBodyKeys.MediaURL: userData.mediaURL as AnyObject,
            ParseClient.JSONBodyKeys.Latitude: userData.latitude as AnyObject,
            ParseClient.JSONBodyKeys.Longitude: userData.longitude as AnyObject,
        ]
        
        // 2. Make the request
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { JSONResult, error in
            
            // 3. Send the desired value(s) to completion handler
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                if let _ = JSONResult?.value(forKey: ParseClient.JSONResponseKeys.ObjectId) as? String {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, "Failed to Post Location.")
                }
            }
        }
        
    }
    
}
