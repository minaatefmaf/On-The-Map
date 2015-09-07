//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mina Atef on 8/30/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UI
        self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide (and stop animating) the activity indicator
        activityIndicator.hidden = true
        if self.activityIndicator.isAnimating() {
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // So email and password fields are empty again on logging out
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }

    @IBAction func loginButtonTouch(sender: BorderedButton) {
        // Attempt login only if there's an e-mail & a password
        if !(emailTextField.text.isEmpty || passwordTextField.text.isEmpty) {
            
            // Show the activity indicator to let the user know htat the data is being processed
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().authenticateAndGetUserData(self, username: emailTextField.text!, password: passwordTextField.text!) { (success, uniqueKey: String?, userData: UdacityUser?, errorString) in

                if success {
                    if let uniqueKey = uniqueKey,
                        let userData = userData {
                            self.completeLogin(uniqueKey, userData: userData)
                    }
                } else {
                    self.displayError(errorString)
                }
                
            }

        } else {
            self.displayError("Empty Email or Password.")
        }
    }
    
    func completeLogin(uniqueKey: String, userData: UdacityUser) {
        
        // Save the user data & its unique id to the app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).udacityUserData = userData
        (UIApplication.sharedApplication().delegate as! AppDelegate).userUniqueID = uniqueKey
        
         dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("StudentsLocationsTabbedBar") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })

    }
    
    func displayError(errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(dismissAction)
            dispatch_async(dispatch_get_main_queue(), {
                if self.activityIndicator.isAnimating(){
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                }
                // Display the Alert view controller
                self.presentViewController (alert, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func signUpForUdacity(sender: UIButton) {
        // Open a link to the udacity page in safari
        if let requestUrl = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    func configureUI() {
        // Configure background gradient
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.977, green: 0.586, blue: 0.125, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.977, green: 0.430, blue: 0.125, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        // Configure email textfield
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        emailTextField.backgroundColor = UIColor(red: 0.973, green: 0.719, blue: 0.512, alpha:1.0)
        emailTextField.textColor = UIColor(red: 0.977, green: 0.350, blue: 0.125, alpha: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // Configure password textfield
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        passwordTextField.backgroundColor = UIColor(red: 0.973, green: 0.719, blue: 0.512, alpha:1.0)
        passwordTextField.textColor = UIColor(red: 0.977, green: 0.350, blue: 0.125, alpha: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // Configure login button
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 0.922, green:0.234, blue:0.082, alpha: 1.0)
        loginButton.backingColor = UIColor(red: 0.922, green:0.352, blue:0.082, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.922, green:0.352, blue:0.082, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = borderedButtonCornerRadius
        
    }
}

