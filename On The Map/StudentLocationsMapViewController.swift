//
//  StudentLocationsMapViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/5/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    // Varaibles to hold the user data & unique key
    private var userData: UdacityUser!
    private var uniqueKey: String!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // Add a refernce to the refresh button here to be able to disable it while loading new dada later
    private var refreshButton: UIBarButtonItem! = nil
    
    // Variable to hold the old annotations
    private var oldAnnotations = [MKPointAnnotation]()
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var blackView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the right bar buttons
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(StudentLocationsMapViewController.refreshStudentLocations))
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(StudentLocationsMapViewController.openInformationPostingView))
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
        
        // Add observer to the refresh notification
        subscribeToRefreshNotifications()
        
        // Make sure the black view & the activity indicators are on
        blackView.isHidden = false
        activityIndicator.startAnimating()

        // Populate the userData & uniqueKey with the data from the login scene
        userData = appDelegate.udacityUserData
        uniqueKey = appDelegate.userUniqueID
        
        // load the students locations
        loadStudentLocations()
        
    }
    
    deinit {
        // Remove the observer to the refresh notification
        unsubscribeToRefreshNotifications()
    }
    
    @IBAction private func logoutButton(_ sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        appDelegate.udacityUserData = nil
        appDelegate.userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    func refreshStudentLocations() {
        // Start loading the new data
        loadStudentLocations()
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
    
    func loadStudentLocations() {
        // Deactivate the refresh button
        refreshButton.isEnabled = false
        
        // Notify the other tabs that new data is being reloaded
        self.notifyOtherTabsToSetloadingModeOn()
        
        // Remove the previous annotaions
        mapView.removeAnnotations(oldAnnotations)

        // Switch the black view & the activity indicators on
        blackView.isHidden = false
        activityIndicator.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations() { (success, StudentsLocations: [StudentLocation]?, errorString) in
            
            if success {
                if let StudentsLocations = StudentsLocations {
                    // Save the students locations to the app delegate
                    self.appDelegate.studentsLocations = StudentsLocations
                    
                    // Notify the other tabs to reload their ceels
                    DispatchQueue.main.async {
                        self.notifyOtherTabsToReloadCells()
                        
                        // Annotate the map view with the locations
                        self.annotateTheMapWithLocations()
                        
                        // Activate the refresh button
                        self.refreshButton.isEnabled = true
                    }
                }
            } else {
                // Display an alert with the error for the user
                self.displayError(errorString)
                // Shutdown the black view & the activity indicator
                DispatchQueue.main.async {
                self.blackView.isHidden = true
                self.activityIndicator.stopAnimating()
                }
                
            }
            
        }
        
        
    }
    
    private func notifyOtherTabsToSetloadingModeOn() {
        // Notify the Table and the Collection tabs to reload their cells
        NotificationCenter.default.post(name: Notification.Name(rawValue: NSNotificationCenterKeys.DataIsReloading), object: self)
    }
    
    private func notifyOtherTabsToReloadCells() {
        // Notify the Table and the Collection tabs to reload their cells
        NotificationCenter.default.post(name: Notification.Name(rawValue: NSNotificationCenterKeys.DataIsReloadedSuccessfully), object: self)
    }
    
    private func annotateTheMapWithLocations() {
        
        let locations = appDelegate.studentsLocations
        // Create MKPointAnnotation for each dictionary in "locations".
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in locations {
            
            // The latitude and longitude are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // Save the annotations to be able to remove it on updating the map.
        oldAnnotations = annotations
           
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
           
        // Shutdown the black view & the activity indicator.
        blackView.isHidden = true
        activityIndicator.stopAnimating()
        
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
    
    
    // MARK: - MKMapViewDelegate
    
    // Create a view with a "right callout accessory view".
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps.
    // It opens the system browser to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            if UIApplication.shared.canOpenURL(URL(string: annotationView.annotation!.subtitle!!)!) {
                UIApplication.shared.openURL(URL(string: annotationView.annotation!.subtitle!!)!)
            } else {
                displayError("Invalid Link")
            }
        }
    }

    
}

extension StudentLocationsMapViewController {
    
    func subscribeToRefreshNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StudentLocationsMapViewController.loadStudentLocations), name: NSNotification.Name(rawValue: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification), object: nil)
    }
    
   func unsubscribeToRefreshNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotificationCenterKeys.RefreshButtonIsRealeasedNotification), object: nil)
    }

}
