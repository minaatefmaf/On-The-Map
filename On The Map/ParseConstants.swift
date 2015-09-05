//
//  ParseConstants.swift
//  On The Map
//
//  Created by Mina Atef on 9/6/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

extension ParseClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: Udacity Facebook App ID
        static let ParseAppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let BaseURL: String = "http://api.parse.com/1/classes/StudentLocation"
        static let BaseURLSecure: String = "https://api.parse.com/1/classes/StudentLocation"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Session
        static let ObjectId = "objectId"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let Lastname = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UdacityURL = "https://udacity.com"
        
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {

        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let Lastname = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        
    }

    
}