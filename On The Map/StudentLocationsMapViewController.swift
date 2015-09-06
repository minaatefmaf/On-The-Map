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
        
        self.loadStudentLocations()
        while (UIApplication.sharedApplication().delegate as! AppDelegate).studentsLocations == nil {
            // Do nothing -> wait for the studentsLocations to be loaded.
        }
        
       /* let studentsLocations = (UIApplication.sharedApplication().delegate as! AppDelegate).studentsLocations
        
            for (number, StudentLocation) in enumerate(studentsLocations!) {
            println("\(number + 1): \(StudentLocation.firstName) \(StudentLocation.lastName)")
            println("latitude: \(StudentLocation.latitude), longitude: \(StudentLocation.longitude)")
            println("mapString: \(StudentLocation.mapString)")
            println("mediaURL: \(StudentLocation.mediaURL)")
            println("objectId: \(StudentLocation.objectId)")
            println("uniqueKey: \(StudentLocation.uniqueKey)")
            println("************************")
        } */
        
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadStudentLocations() {
        ParseClient.sharedInstance().getStudentLocations() { (success, StudentsLocations: [StudentLocation]?, errorString) in
            
            if success {
                if let StudentsLocations = StudentsLocations {
                    // Save the students locations to the app delegate
                    (UIApplication.sharedApplication().delegate as! AppDelegate).studentsLocations = StudentsLocations
                }
            } else {
                self.displayError(errorString)
            }
            
        }
    }
    
    func displayError(errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(dismissAction)
            dispatch_async(dispatch_get_main_queue(), {
                // Display the Alert view controller
                self.presentViewController (alert, animated: true, completion: nil)
            })
        }
    }
    
}
