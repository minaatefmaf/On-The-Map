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
        
        println("In the Map tab 😄")
        println(uniqueKey)
        println(userData.firstName)
        println(userData.lastName)
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
