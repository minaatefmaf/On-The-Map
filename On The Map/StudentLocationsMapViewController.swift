//
//  StudentLocationsMapViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/5/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class StudentLocationsMapViewController: UIViewController {
    
    // Varaibles to hold the user data & unique key
    var userData: UdacityUser!
    var uniqueKey: String!
    
    override func viewDidLoad() {
        // Populate the userData & uniqueKey with the data from the login scene
        userData = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData
        uniqueKey = (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID
        
        // ---- Get & Print the students data
        ParseClient.sharedInstance().getStudentLocations() { (success, StudentsLocations: [StudentLocation]?, errorString) in
            
            if success {
                if let StudentsLocations = StudentsLocations {
                    for (number, StudentLocation) in enumerate(StudentsLocations) {
                        println("\(number + 1): \(StudentLocation.firstName) \(StudentLocation.lastName)")
                        println("latitude: \(StudentLocation.latitude), longitude: \(StudentLocation.longitude)")
                        println("mapString: \(StudentLocation.mapString)")
                        println("mediaURL: \(StudentLocation.mediaURL)")
                        println("objectId: \(StudentLocation.objectId)")
                        println("uniqueKey: \(StudentLocation.uniqueKey)")
                        println("************************")
                    }
                } else {
                    println("Map - get locations - success - else")
                }
            } else {
                println(errorString)
            }
            
        }
        
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
