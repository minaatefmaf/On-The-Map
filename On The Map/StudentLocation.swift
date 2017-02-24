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
    
    /* Construct a StudentLocation from a dictionary */
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
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects */
    static func studentsLocationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        var studentsLocations = [StudentLocation]()
        
        for result in results {
            studentsLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentsLocations
    }

}
