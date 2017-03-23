//
//  StudentLocationsTableViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/5/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Varaibles to hold the user data & unique key
    private var userData: UdacityUser!
    private var uniqueKey: String!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to the reload notification
        subscribeToReloadNotifications()
        
        // Add the right bar buttons
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationsTableViewController.refreshStudentLocations))
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(StudentLocationsTableViewController.openInformationPostingView))
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
        
        // Populate the userData & uniqueKey with the data from the login scene
        userData = (UIApplication.shared.delegate as! AppDelegate).udacityUserData
        uniqueKey = (UIApplication.shared.delegate as! AppDelegate).userUniqueID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the rows and sections of the table view.
        tableView.reloadData()
    }
    
    deinit {
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
        // Notify the Map tab to reload the data
        NotificationCenter.default.post(name: Notification.Name(rawValue: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification), object: self)
        
        // Reload the rows and sections of the table view.
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !appDelegate.studentsLocations.isEmpty {
            return appDelegate.studentsLocations.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableCell")! as UITableViewCell
        
        // Set the name and the image
        let student = appDelegate.studentsLocations[indexPath.row]
        
        // If the full name is empty, set it to a default value
        var fullName = ""
        if student.firstName.isEmpty && student.lastName.isEmpty {
            fullName = "No Name"
        } else {
            fullName = "\(student.firstName) \(student.lastName)"
        }
        // If the mediaURL is an empty string, set it to a default value
        var mediaURL = student.mediaURL
        if student.mediaURL.isEmpty {
            mediaURL = "No Media URL"
        }
        
        // Set the values to the cell's labels
        cell.textLabel?.text = fullName
        cell.detailTextLabel?.text = mediaURL
       // cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open the media url in safari
        let student = appDelegate.studentsLocations[indexPath.row]
        if let requestUrl = URL(string: student.mediaURL) {
            if UIApplication.shared.canOpenURL(requestUrl) {
                UIApplication.shared.openURL(requestUrl)
            } else {
                displayError("Invalid Link")
            }
        } else {
            displayError("Invalid Link")
        }
        
        // Deselect the cell
        tableView.deselectRow(at: indexPath, animated: false)
        
    }

}

extension StudentLocationsTableViewController {
    
    func reloadCells() {
        // Reload the rows and sections of the table view.
        tableView.reloadData()
    }
    
    func subscribeToReloadNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StudentLocationsTableViewController.reloadCells), name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: nil)
    }
    
    func unsubscribeToReloadNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: nil)
    }
    
}
