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
        // Populate the userData & uniqueKey with the data from the login scene
        userData = (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData
        uniqueKey = (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the rows and sections of the collection view.
        collectionView.reloadData()
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appDelegate.studentsLocations!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MapStringCollectionCell", forIndexPath: indexPath) as! MapStringCollectionCell
        let student = self.appDelegate.studentsLocations![indexPath.row]
        
        // Set the map string
        cell.mapStringLabel.text = student.mapString
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // Open the media url in safari
        let student = self.appDelegate.studentsLocations![indexPath.row]
        if let requestUrl = NSURL(string: student.mediaURL) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}