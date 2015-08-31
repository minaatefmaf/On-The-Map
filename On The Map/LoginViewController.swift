//
//  LoginViewController.swift
//  On The Map
//
//  Created by Mina Atef on 8/30/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UI
        self.configureUI()
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
        userNameTextField.leftView = emailTextFieldPaddingView
        userNameTextField.leftViewMode = .Always
        userNameTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        userNameTextField.backgroundColor = UIColor(red: 0.973, green: 0.719, blue: 0.512, alpha:1.0)
        userNameTextField.textColor = UIColor(red: 0.977, green: 0.350, blue: 0.125, alpha: 1.0)
        userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        userNameTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
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

