//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/7/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewConroller: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var labelsSubview: UIView!
    @IBOutlet weak var findButonSubview: UIView!
    @IBOutlet weak var submitButtonSubview: UIView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var shareTextView: UITextView!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // A variable to hold the location's lat & long of the user's entered location
    var placemark: CLPlacemark! = nil
    
    // Save the lat & long
    var placemarkLatitude: Double! = nil
    var placemarkLongitude: Double! = nil
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UI
        self.configureUI()
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findLocationOnTheMap(sender: UIButton) {
        findOnMapFromLocation("Cairo, Egypt")
    }
    
    @IBAction func submit(sender: UIButton) {
        // Prepare the student data to be posted on the server
        prepareStudentData()
        
        // Post the location
        ParseClient.sharedInstance().postStudentLocation(appDelegate.studentData){ (success, errorString) in
            
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError(errorString)
            }
            
        }
    }
    
    func prepareStudentData() {
        
        var userDataDictionary = [String: AnyObject]()
        userDataDictionary["objectId"] = "" // We don't really need the actual value here
        userDataDictionary["uniqueKey"] = appDelegate.userUniqueID
        userDataDictionary["firstName"] = appDelegate.udacityUserData.firstName
        userDataDictionary["lastName"] = appDelegate.udacityUserData.lastName
        userDataDictionary["mapString"] = "Cairo, Egypt"
        userDataDictionary["mediaURL"] = "https://www.linkedin.com/in/minaatefmaf"
        userDataDictionary["latitude"] = self.placemarkLatitude
        userDataDictionary["longitude"] = self.placemarkLongitude
        
        appDelegate.studentData = StudentLocation(dictionary: userDataDictionary)
        
    }
    
    func findOnMapFromLocation(addressString: String) {
        
        // If the location text field have some location
        
        // Start the activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        // Get placemark for a given location (string)
        CLGeocoder().geocodeAddressString(addressString) {(placemarks, error) in
            
            // Grab the first placemark
            if let placemark = placemarks?[0] as? CLPlacemark {
                // Save the placemark in the global variable so other functions can access it
                self.placemark = placemark

                // Annotate the location
                self.annotateTheLocation()
                
                // Prepare the scene for the map view
                self.configureUIForSecondScene()
                
                // Get the location on the map view
                self.getLocationOnMap()
                
            } else {
                println(error.description)
            }
            
        }
        
    }
    
    func annotateTheLocation() {
        
        // let first = appDelegate.udacityUserData.firstName
        let first = "Mina"
        // let last = appDelegate.udacityUserData.lastName
        let last = "Atef"
        let mediaURL = "https://www.linkedin.com/in/minaatefmaf"
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        var annotation = MKPointAnnotation()
        annotation.coordinate = getTheCoordinate()
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotation(annotation)

    }
    
    func getLocationOnMap() {
        
        let coordinate = getTheCoordinate()
        
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let widerSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(coordinate, span)
        let widerRegion = MKCoordinateRegionMake(coordinate, widerSpan)
        
        // Call setRegion function twice for animating the zooming feature
        self.mapView.setRegion(widerRegion, animated: true)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func getTheCoordinate() -> CLLocationCoordinate2D {
    
    self.placemarkLatitude = CLLocationDegrees(self.placemark!.location.coordinate.latitude as Double)
    self.placemarkLongitude = CLLocationDegrees(self.placemark!.location.coordinate.longitude as Double)
    let coordinate = CLLocationCoordinate2D(latitude: self.placemarkLatitude, longitude: self.placemarkLongitude)
    
    return coordinate
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
    
    func configureUI() {
        
        // Prepare the elements that will appear first & hide the others
        labelsSubview.hidden = false
        locationTextView.hidden = false
        findButonSubview.hidden = false
        cancelButton.hidden = false
        shareTextView.hidden = true
        mapView.hidden = true
        activityIndicator.hidden = true
        submitButtonSubview.hidden = true
        submitButton.hidden = true
        
        // Configure the buttons
        findOnTheMapButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        findOnTheMapButton.backgroundColor = UIColor.whiteColor()
        findOnTheMapButton.setTitleColor (UIColor(red: 0.064, green:0.396, blue:0.736, alpha: 1.0), forState: .Normal)
        findOnTheMapButton.layer.masksToBounds = true
        findOnTheMapButton.layer.cornerRadius = 10.0
        
        submitButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        submitButton.backgroundColor = UIColor.whiteColor()
        submitButton.setTitleColor (UIColor(red: 0.064, green:0.396, blue:0.736, alpha: 1.0), forState: .Normal)
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10.0
        
        // Prepare the map view
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        
    }
    
    
    func configureUIForSecondScene() {
        
        // Prepare the elements that will appear first & hide the others
        labelsSubview.hidden = true
        locationTextView.hidden = true
        findButonSubview.hidden = true
        shareTextView.hidden = false
        mapView.hidden = false
        submitButtonSubview.hidden = false
        submitButton.hidden = false
        
        // Start the activity indicator
        self.activityIndicator.hidden = false
        self.activityIndicator.stopAnimating()
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
}