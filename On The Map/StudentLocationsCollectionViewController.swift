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
    private var userData: UdacityUser!
    private var uniqueKey: String!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // Add a refernce to the refresh button here to be able to disable it while loading new dada later
    var refreshButton: UIBarButtonItem! = nil

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout the collection view
        let space: CGFloat = 3.0
        let dimension = min((view.frame.size.width - (2 * space)) / 3.0,
                            (view.frame.size.height - (2 * space)) / 3.0)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Add observer to the reload mode being on notification
        subscribeToReloadModeStatusNotifications()
        
        // Add observer to the reload notification
        subscribeToReloadNotifications()
        
        // Add the right bar buttons
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationsCollectionViewController.refreshStudentLocations))
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
    
    deinit {
        // Remove the observer to the reload Mode being on notification
        unsubscribeToReloadModeStatusNotifications()
        
        // Remove the observer to the reload notification
        unsubscribeToReloadNotifications()
    }
    
    @IBAction private func logoutButton(_ sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        (UIApplication.shared.delegate as! AppDelegate).udacityUserData = nil
        (UIApplication.shared.delegate as! AppDelegate).userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    func refreshStudentLocations() {
        // Deactivate the refresh button
        refreshButton.isEnabled = false
        
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
    
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(dismissAction)
            DispatchQueue.main.async {
                // Display the Alert view controller
                self.present (alert, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !appDelegate.studentsLocations.isEmpty {
            return appDelegate.studentsLocations.count
        } else {
            return 0
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapStringCollectionCell", for: indexPath) as! MapStringCollectionCell
        let student = appDelegate.studentsLocations[indexPath.row]
        
        // Set the map string
        cell.mapStringLabel.text = student.mapString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:IndexPath)
    {
        // Open the media url in safari
        let student = appDelegate.studentsLocations[indexPath.row]
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
    
    func setLoadingModeOn() {
        // Animate the activity controllar
        activityIndicator.startAnimating()
    }
    
    func subscribeToReloadModeStatusNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StudentLocationsCollectionViewController.setLoadingModeOn), name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloading), object: nil)
    }
    
    func unsubscribeToReloadModeStatusNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloading), object: nil)
    }
    
    func reloadCells() {
        // Stop the activity indicator
        activityIndicator.stopAnimating()
        
        // Reload the cells of the collection view.
        collectionView.reloadData()
        
        // Activate the refresh button
        refreshButton.isEnabled = true
    }
    
    func subscribeToReloadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StudentLocationsCollectionViewController.reloadCells), name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: nil)
    }
    
    func unsubscribeToReloadNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: nil)
    }
    
}
