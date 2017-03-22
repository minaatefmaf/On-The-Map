//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/7/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewConroller: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
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
    
    var tapRecognizer: UITapGestureRecognizer? = nil

    // Add a reference to the delegate
    let locationTextViewDelegate = LocationTextViewDelegate()
    
    // Should clear the initial value when a user clicks the textview for the first time.
    var firstEdit = true
    
    // Variable to hold the old annotation
    var oldAnnotation = MKPointAnnotation()
    
    // A variable to hold the location's lat & long of the user's entered location
    var placemark: CLPlacemark! = nil
    
    // Save the lat & long
    var placemarkLatitude: Double! = nil
    var placemarkLongitude: Double! = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign each textview to its proper delegate
        locationTextView.delegate = locationTextViewDelegate
        shareTextView.delegate = self
        
        // Configure the UI
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardDismissRecognizer()
    }

    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationOnTheMap(_ sender: UIButton) {
        // Check first if the users has entered a location
        if (locationTextView.text.isEmpty || locationTextView.text.isEqual("Enter Your Location Here")) {
            displayError("Must Enter a Location.")
        } else {
            let location = locationTextView.text
            findOnMapFromLocation(location!)
        }
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        // Check first if the users has entered a location
        if (shareTextView.text.isEmpty || shareTextView.text.isEqual("Enter a Link to Share Here")) {
            displayError("Must Enter a Link.")
            // Check if the link is a valid link
        } else if !UIApplication.shared.canOpenURL(URL(string: shareTextView.text)!) {
            displayError("Invalid Link.")
        } else {
            
            // Prepare the student data to be posted on the server
            prepareStudentData()
            
            // Post the location
            ParseClient.sharedInstance().postStudentLocation(appDelegate.studentData) { (success, errorString) in
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayError(errorString)
                }
            
            } 
        }
    }
    
    func prepareStudentData() {
        
        var userDataDictionary = [String: AnyObject]()
        userDataDictionary["objectId"] = "" as AnyObject? // We don't really need the actual value here
        userDataDictionary["uniqueKey"] = appDelegate.userUniqueID as AnyObject?
        userDataDictionary["firstName"] = appDelegate.udacityUserData.firstName as AnyObject?
        userDataDictionary["lastName"] = appDelegate.udacityUserData.lastName as AnyObject?
        userDataDictionary["mapString"] = locationTextView.text as AnyObject?
        userDataDictionary["mediaURL"] = shareTextView.text as AnyObject?
        userDataDictionary["latitude"] = placemarkLatitude as AnyObject?
        userDataDictionary["longitude"] = placemarkLongitude as AnyObject?
        
        appDelegate.studentData = StudentLocation(dictionary: userDataDictionary)
        
    }
    
    func findOnMapFromLocation(_ addressString: String) {
        
        // Start the activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // Get placemark for a given location (string)
        CLGeocoder().geocodeAddressString(addressString) {(placemarks, error) in
            
            
            // Grab the first placemark
            if let placemark = placemarks?[0] as CLPlacemark! {
                // Save the placemark in the global variable so other functions can access it
                self.placemark = placemark

                // Annotate the location
                self.annotateTheLocation()
                
                // Prepare the scene for the map view
                self.configureUIForSecondScene()
                
                // Get the location on the map view
                self.getLocationOnMap()
                
            } else {
                self.displayError("Could Not Geocode the String.")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
        }
        
    }
    
    func annotateTheLocation() {
        
        // Remove the previous annotaion
        mapView.removeAnnotation(oldAnnotation)
        
        let first = appDelegate.udacityUserData.firstName
        let last = appDelegate.udacityUserData.lastName
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = getTheCoordinate()
        annotation.title = "\(first) \(last)"
        // Update the pin's subtitle only when the user starts entering a link to share.
        if(!firstEdit) {
            annotation.subtitle = shareTextView.text
        }
        
        // Save the annotation to be able to remove it on updating the map.
        oldAnnotation = annotation
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotation(annotation)

    }
    
    func getLocationOnMap() {
        
        let coordinate = getTheCoordinate()
        
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let widerSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(coordinate, span)
        let widerRegion = MKCoordinateRegionMake(coordinate, widerSpan)
        
        // Call setRegion function twice for animating the zooming feature
        mapView.setRegion(widerRegion, animated: true)
        mapView.setRegion(region, animated: true)
        
    }
    
    func getTheCoordinate() -> CLLocationCoordinate2D {
    
    placemarkLatitude = CLLocationDegrees(placemark!.location!.coordinate.latitude as Double)
    placemarkLongitude = CLLocationDegrees(placemark!.location!.coordinate.longitude as Double)
    let coordinate = CLLocationCoordinate2D(latitude: placemarkLatitude, longitude: placemarkLongitude)
    
    return coordinate
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
    // It opens the system browser to the URL specified in the annotationViews subtitle property. */
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            if UIApplication.shared.canOpenURL(URL(string: annotationView.annotation!.subtitle!!)!) {
                UIApplication.shared.openURL(URL(string: annotationView.annotation!.subtitle!!)!)
            } else {
                displayError("Invalid Link")
            }
        }
    }
    
    func displayError(_ errorString: String?) {
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
    
    
    // MARK: - UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        // Should clear the initial value when a user clicks the textview for the first time.
        if firstEdit {
            textView.text = ""
            
            // The user can continue editing the text he entered so far!
            firstEdit = false
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var newText = textView.text as NSString
        newText = newText.replacingCharacters(in: range, with: text) as NSString
        
        // resignFirstResponder() if return is pressed
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        // Annotate the pin with the new link
        annotateTheLocation()
        
        return true
    }
    
    
    // MARK: - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - UI Configurations
    
    func configureUI() {
        
        // Prepare the elements that will appear first & hide the others
        labelsSubview.isHidden = false
        locationTextView.isHidden = false
        findButonSubview.isHidden = false
        cancelButton.isHidden = false
        shareTextView.isHidden = true
        mapView.isHidden = true
        activityIndicator.isHidden = true
        submitButtonSubview.isHidden = true
        submitButton.isHidden = true
        
        // Configure the buttons
        findOnTheMapButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        findOnTheMapButton.backgroundColor = UIColor.white
        findOnTheMapButton.setTitleColor (UIColor(red: 0.064, green:0.396, blue:0.736, alpha: 1.0), for: UIControlState())
        findOnTheMapButton.layer.masksToBounds = true
        findOnTheMapButton.layer.cornerRadius = 10.0
        
        submitButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor (UIColor(red: 0.064, green:0.396, blue:0.736, alpha: 1.0), for: UIControlState())
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 10.0
        
        // Prepare the map view
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        // Configure tap recognizer 
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationPostingViewConroller.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    
    
    func configureUIForSecondScene() {
        
        // Prepare the elements that will appear first & hide the others
        labelsSubview.isHidden = true
        locationTextView.isHidden = true
        findButonSubview.isHidden = true
        shareTextView.isHidden = false
        mapView.isHidden = false
        submitButtonSubview.isHidden = false
        submitButton.isHidden = false
        
        // Start the activity indicator
        activityIndicator.isHidden = false
        activityIndicator.stopAnimating()
        
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
    }
    
}
