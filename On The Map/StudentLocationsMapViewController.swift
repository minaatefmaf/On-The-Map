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
    var userData: UdacityUser!
    var uniqueKey: String!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the right bar buttons
        var refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshStudentLocations")
        var pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "openInformationPostingView")
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
        
        // Make sure the black view & the activity indicators are on
        blackView.hidden = false
        activityIndicator.startAnimating()

        // Populate the userData & uniqueKey with the data from the login scene
        userData = appDelegate.udacityUserData
        uniqueKey = appDelegate.userUniqueID
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.loadStudentLocations()
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        // Clear the user data saved in the app delegate
        self.appDelegate.udacityUserData = nil
        self.appDelegate.userUniqueID = nil
        
        UdacityClient.sharedInstance().deleteSession()
        
        // Dismiss the view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshStudentLocations() {
        
    }
    
    func openInformationPostingView() {

    }
    
    func loadStudentLocations() {
        
        // Switch the black view & the activity indicators on.
        blackView.hidden = true
        activityIndicator.stopAnimating()
        
        ParseClient.sharedInstance().getStudentLocations() { (success, StudentsLocations: [StudentLocation]?, errorString) in
            
            if success {
                if let StudentsLocations = StudentsLocations {
                    // Save the students locations to the app delegate
                    self.appDelegate.studentsLocations = StudentsLocations
                }
            } else {
                self.displayError(errorString)
            }
            
        }

        while self.appDelegate.studentsLocations == nil {
            // Do nothing -> just make sure that the studentsLocations was successfully loaded.
        }
        
        let locations = appDelegate.studentsLocations!
        // Create MKPointAnnotation for each dictionary in "locations".
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in locations {
            
            // The latitude and longitude are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
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
    
    
    // MARK: - MKMapViewDelegate
    
    // Create a view with a "right callout accessory view".
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    /* This delegate method is implemented to respond to taps. It opens the system browser
    to the URL specified in the annotationViews subtitle property. */
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: annotationView.annotation.subtitle!)!) {
                UIApplication.sharedApplication().openURL(NSURL(string: annotationView.annotation.subtitle!)!)
            } else {
                self.displayError("Invalid Link")
            }
        }
    }
    
    /* This delegate method is implemented to shutdown the black view & the activity indicator when the map finish rendering the view. */
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
       
        // Shutdown the black view & the activity indicator.
        blackView.hidden = true
        activityIndicator.stopAnimating()
        
    }
    
}
