//
//  StudentLocation.swift
//  On The Map
//
//  Created by Mina Atef on 9/6/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

struct StudentLocation {
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    // Construct a StudentLocation from a dictionary
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func studentsLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        var studentsLocations = [StudentLocation]()
        
        for result in results {
            // Add the result to the studentsLocations array if it is a valid one (contains all of the parameters)
            if isValid(dictionary: result) {
                studentsLocations.append(StudentLocation(dictionary: result))
            }
        }
        
        return studentsLocations
    }
    
    private static func isValid(dictionary: [String : AnyObject]) -> Bool {
        // Return true if the result contains all of the parameters
        if let _ = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.LastName] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.MapString] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String,
            let _ = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double,
            let _ = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        { return true }
        
        return false
    }
    
}
