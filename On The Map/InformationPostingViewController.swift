//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Mina Atef on 9/7/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class InformationPostingViewConroller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}