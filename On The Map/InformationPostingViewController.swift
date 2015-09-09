//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/7/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewConroller: UIViewController {
    
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
        
    }
    
    func findOnMapFromLocation(addressString: String) {
        
        // If the location text field have some location
        
        
        // Get placemark for a given location (string)
        CLGeocoder().geocodeAddressString(addressString) {(placemarks, error) in
            
            // Grab the first placemark
            if let placemark = placemarks?[0] as? CLPlacemark {
                // Save the placemark in the global variable so other functions can access it
                self.placemark = placemark
                // Get the location on the map view
                self.getLocationOnMap()
                
            } else {
                println(error.description)
            }
            
        }
        
    }
    
    func getLocationOnMap() {
        
        let lat = CLLocationDegrees(self.placemark!.location.coordinate.latitude as Double)
        let long = CLLocationDegrees(self.placemark!.location.coordinate.longitude as Double)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let widerSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegionMake(coordinate, widerSpan)
        let widerRegion = MKCoordinateRegionMake(coordinate, span)
        
        // Call setRegion function twice for animating the zooming feature
        self.mapView.setRegion(widerRegion, animated: true)
        self.mapView.setRegion(region, animated: true)
        
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
        
        activityIndicator.hidden = false
        activityIndicator.stopAnimating()
        
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
}