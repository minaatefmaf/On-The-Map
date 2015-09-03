//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Mina Atef on 9/1/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: Udacity Facebook App ID
        static let FacebookAppID: String = "365362206864879"
        
        // MARK: URLs
        static let BaseURL: String = "http://www.udacity.com/api/"
        static let BaseURLSecure: String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "session"
        
        // MARK: Public user data
        static let UserId = "users/{id}"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let SessionID = "session_id"

    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let Username = "username"
        static let Password = "password"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        static let Error = "error"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account - session
        static let Session = "session"
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        // Mark: User Data
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
    }
}

