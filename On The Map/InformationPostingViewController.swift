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
    @IBOutlet weak var findOnTheMapButton: CustomButton!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UI
        self.configureUI()
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        findOnTheMapButton.layer.cornerRadius = customButtonCornerRadius
        
        submitButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        submitButton.backgroundColor = UIColor.whiteColor()
        submitButton.setTitleColor (UIColor(red: 0.064, green:0.396, blue:0.736, alpha: 1.0), forState: .Normal)
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = customButtonCornerRadius
        
    }
    
}