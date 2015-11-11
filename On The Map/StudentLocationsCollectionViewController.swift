//
//  StudentLocationsCollectionViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/5/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class StudentLocationsCollectionViewController: UIViewController {
    
    // Varaibles to hold the user data & unique key
    var userData: UdacityUser!
    var uniqueKey: String!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to the reload notification
        subscribeToReloadNotifications()
        
        // Add the right bar buttons
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshStudentLocations")
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "openInformationPostingView")
        navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
        
        // Populate the userData & uniqueKey with the data from the login scene
        userData = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData
        uniqueKey = (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshStudentLocations() {
        // Notify the Map tab to reload the data
        NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification, object: self)
        
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    func openInformationPostingView() {
        
        // Prepare a URL to use on checking for network availability
        let url = NSURL(string: "https://www.google.com")!
        let data = NSData(contentsOfURL: url)
        
        // If there's a network connection available, open the information posting view controller
        if data != nil {
            // Open the information posting view
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewConroller") 
            presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    func displayError(errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(dismissAction)
            dispatch_async(dispatch_get_main_queue(), {
                // Display the Alert view controller
                self.presentViewController (alert, animated: true, completion: nil)
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if appDelegate.studentsLocations != nil {
            return appDelegate.studentsLocations!.count
        } else {
            return 0
        }
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MapStringCollectionCell", forIndexPath: indexPath) as! MapStringCollectionCell
        let student = appDelegate.studentsLocations![indexPath.row]
        
        // Set the map string
        cell.mapStringLabel.text = student.mapString
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // Open the media url in safari
        let student = appDelegate.studentsLocations![indexPath.row]
        if let requestUrl = NSURL(string: student.mediaURL) {
            if UIApplication.sharedApplication().canOpenURL(requestUrl) {
                UIApplication.sharedApplication().openURL(requestUrl)
            } else {
                displayError("Invalid Link")
            }
        }
        
        // Deselect the cell
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
    }
    
}

extension StudentLocationsCollectionViewController {
    
    func reloadCells() {
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    func subscribeToReloadNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCells", name: NSNotificationCenterKeys.DataIsReloadedSuccessfully, object: nil)
    }
    
    /* func unsubscribeToRefreshNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification, object: nil)
    } */
    
}
