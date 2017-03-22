//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mina Atef on 8/30/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the textfields to  delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Configure the UI
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide (and stop animating) the activity indicator
        activityIndicator.isHidden = true
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        
        addKeyboardDismissRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // So email and password fields are empty again on logging out
        emailTextField.text = ""
        passwordTextField.text = ""
        
        removeKeyboardDismissRecognizer()
    }

    @IBAction func loginButtonTouch(_ sender: BorderedButton) {
        // Dismiss the keyboard of it's still active
        view.endEditing(true)
        
        // Attempt login only if there's an e-mail & a password
        if !(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            
            // Show the activity indicator to let the user know that the data is being processed
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().authenticateAndGetUserData(self, username: emailTextField.text!, password: passwordTextField.text!) { (success, uniqueKey: String?, userData: UdacityUser?, errorString) in

                if success {
                    if let uniqueKey = uniqueKey,
                        let userData = userData {
                            self.completeLogin(uniqueKey, userData: userData)
                    }
                } else {
                    var newErrorString = errorString
                    // If the status code == 403: status text: "Forbidden", description: "Client does not have access rights to the content so server is rejecting to give proper response."
                    if ((newErrorString?.contains("403")) != nil) {
                        newErrorString = "Invalid Email or Password."
                    }
                    self.displayError(newErrorString)
                }
                
            }

        } else {
            self.displayError("Empty Email or Password.")
        }
    }
    
    func completeLogin(_ uniqueKey: String, userData: UdacityUser) {
        
        // Save the user data & its unique id to the app delegate
        (UIApplication.shared.delegate as! AppDelegate).udacityUserData = userData
        (UIApplication.shared.delegate as! AppDelegate).userUniqueID = uniqueKey
        
         DispatchQueue.main.async {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "StudentsLocationsTabbedBar") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }

    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            // Prepare the Alert view controller with the error message to display
            let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(dismissAction)
            DispatchQueue.main.async {
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                // Display the Alert view controller
                self.present (alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpForUdacity(_ sender: UIButton) {
        // Open a link to the udacity page in safari
        if let requestUrl = URL(string: UdacityClient.Constants.SignUpURL) {
            UIApplication.shared.openURL(requestUrl)
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        // Configure background gradient
        self.view.backgroundColor = UIColor.clear
        let colorTop = UIColor(red: 0.977, green: 0.586, blue: 0.125, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.977, green: 0.430, blue: 0.125, alpha: 1.0).cgColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Configure email textfield
        let emailTextFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .always
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        emailTextField.backgroundColor = UIColor(red: 0.973, green: 0.719, blue: 0.512, alpha:1.0)
        emailTextField.textColor = UIColor(red: 0.977, green: 0.350, blue: 0.125, alpha: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // Configure password textfield
        let passwordTextFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        passwordTextField.backgroundColor = UIColor(red: 0.973, green: 0.719, blue: 0.512, alpha:1.0)
        passwordTextField.textColor = UIColor(red: 0.977, green: 0.350, blue: 0.125, alpha: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // Configure login button
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 0.922, green:0.234, blue:0.082, alpha: 1.0)
        loginButton.backingColor = UIColor(red: 0.922, green:0.352, blue:0.082, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.922, green:0.352, blue:0.082, alpha: 1.0)
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = borderedButtonCornerRadius
        
        // Configure tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
}

