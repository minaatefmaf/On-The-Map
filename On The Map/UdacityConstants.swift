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
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Session
        static let Session = "/session"
        
        // MARK: Public user data
        static let UserId = "/users/{id}"
        
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

