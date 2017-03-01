//
//  ParseClient.swift
//  On The Map
//
//  Created by Mina Atef on 9/6/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // Shared session
    var session: URLSession
    
    override init() {
        session = URLSession.shared
        super.init()
    }

    // MARK: - GET
    
    func taskForGETMethod(_ method: String, parameters: [String : AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let mutableParameters = parameters
        
        // 2/3. Build the URL and configure the request
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // 4. Make the request
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            
            /* GUARD: Was there an error? */
            guard (downloadError == nil) else {
                completionHandler(result: nil, error: downloadError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: '\(response.statusCode)'"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: '\(response)'"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                }
                return
            }
        
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }) 
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    
    func taskForPOSTMethod(_ method: String, parameters: [String: AnyObject], jsonBody: [String:AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let mutableParameters = parameters
        
        // 2/3. Build the URL and configure the request
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            
            /* GUARD: Was there an error? */
            guard (downloadError == nil) else {
                completionHandler(result: nil, error: downloadError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: '\(response.statusCode)'"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: '\(response)'"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }) 
        // 7. Start the request
        task.resume()
        
        return task
    }

    
    // MARK: - Helpers

    // Helper: Given raw JSON, return a usable Foundation object
    class func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        
        let parsedResult: Any?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(nil, error)
        } else {
            completionHandler(parsedResult as AnyObject?, nil)
        }
    }
    
    // Helper function: Given a dictionary of parameters, convert to a string for a url
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }


    // MARK: - Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
