//
//  UdacityClient.swift
//  On The Map
//
//  Created by Mina Atef on 9/1/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // Shared session
    private var session: URLSession
    
    override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: - GET
    
    func taskForGETMethod(_ method: String, parameters: [String : AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let mutableParameters = parameters
        
        // 2/3. Build the URL and configure the request
        let request = URLRequest(url: udacityURLFromParameters(mutableParameters, withMethod: method))
        
        // 4. Make the request
        let task = session.dataTask(with: request , completionHandler: {data, response, downloadError in
            
            // GUARD: Was there an error?
            guard (downloadError == nil) else {
                completionHandler(nil, downloadError as NSError?)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: '\(response.statusCode)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: '\(response)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            // 5/6. Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
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
        let request = NSMutableURLRequest(url: udacityURLFromParameters(mutableParameters, withMethod: method))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request as URLRequest
            
            , completionHandler: {data, response, downloadError in
            
            // GUARD: Was there an error?
            guard (downloadError == nil) else {
                completionHandler(nil, downloadError as NSError?)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: '\(response.statusCode)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: '\(response)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }) 

        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    // MARK: - DELETE
    
    func taskForDELETEMethod(_ method: String, parameters: [String: AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // 1. Set the parameters
        let mutableParameters = parameters
        
        // 2/3. Build the URL and configure the request
        let request = NSMutableURLRequest(url: udacityURLFromParameters(mutableParameters, withMethod: method))

        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! as [HTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // 4. Make the request
        let task = session.dataTask(with: request as URLRequest
            , completionHandler: {data, response, downloadError in
            
            // GUARD: Was there an error?
            guard (downloadError == nil) else {
                completionHandler(nil, downloadError as NSError?)
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: '\(response.statusCode)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: '\(response)'"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // 5/6. Parse the data and use the data (happens in completion handler)
            UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }) 
        
        // 7. Start the request
        task.resume()
        
        return task
    }
    
    
    // MARK: - Helpers
    
    // Helper: Substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Helper: Given raw JSON, return a usable Foundation object
    private class func parseJSONWithCompletionHandler(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        // subset response data!
        let range = Range(5 ..< data.count)
        let newData = data.subdata(in: range)
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(parsedResult as AnyObject?, nil)
    }
    
    // Create a URL from parameters
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withMethod: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withMethod ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            // Make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            // Append it
            let queryItem = URLQueryItem(name: key, value: escapedValue)
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
