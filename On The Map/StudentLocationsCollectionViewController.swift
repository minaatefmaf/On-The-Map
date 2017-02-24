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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to the reload notification
        subscribeToReloadNotifications()
        
        // Add the right bar buttons
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationsCollectionViewController.refreshStudentLocations))
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(StudentLocationsCollectionViewController.openInformationPostingView))
        navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
        
        // Populate the userData & uniqueKey with the data from the login scene
        userData = (UIApplication.shared.delegate as! AppDelegate).udacityUserData
        uniqueKey = (UIApplication.shared.delegate as! AppDelegate).userUniqueID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.shared.delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.shared.delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    func refreshStudentLocations() {
        // Notify the Map tab to reload the data
        NotificationCenter.default.post(name: Notification.Name(rawValue: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification), object: self)
        
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    func openInformationPostingView() {
        
        // Prepare a URL to use on checking for network availability
        let url = URL(string: "https://www.google.com")!
        let data = try? Data(contentsOf: url)
        
        // If there's a network connection available, open the information posting view controller
        if data != nil {
            // Open the information posting view
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewConroller") 
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(dismissAction)
            DispatchQueue.main.async(execute: {
                // Display the Alert view controller
                self.present (alert, animated: true, completion: nil)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if appDelegate.studentsLocations != nil {
            return appDelegate.studentsLocations!.count
        } else {
            return 0
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapStringCollectionCell", for: indexPath) as! MapStringCollectionCell
        let student = appDelegate.studentsLocations![indexPath.row]
        
        // Set the map string
        cell.mapStringLabel.text = student.mapString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:IndexPath)
    {
        // Open the media url in safari
        let student = appDelegate.studentsLocations![indexPath.row]
        if let requestUrl = URL(string: student.mediaURL) {
            if UIApplication.shared.canOpenURL(requestUrl) {
                UIApplication.shared.openURL(requestUrl)
            } else {
                displayError("Invalid Link")
            }
        }
        
        // Deselect the cell
        collectionView.deselectItem(at: indexPath, animated: false)
        
    }
    
}

extension StudentLocationsCollectionViewController {
    
    func reloadCells() {
        // Reload the cells of the collection view.
        collectionView.reloadData()
    }
    
    func subscribeToReloadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StudentLocationsCollectionViewController.reloadCells), name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: nil)
    }
    
    /* func unsubscribeToRefreshNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification, object: nil)
    } */
    
}
