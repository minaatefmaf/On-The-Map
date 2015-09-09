//
//  LocationTextViewDelegate.swift
//  On The Map
//
//  Created by Mina Atef on 9/9/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class LocationTextViewDelegate: NSObject, UITextViewDelegate {
    
    // Should clear the initial value "TOP" when a user clicks the textfield for the first time.
    var firstEdit = true
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        // Should clear the initial value when a user clicks the textview for the first time.
        if firstEdit {
            textView.text = ""
            
            // The user can continue editing the text he entered so far!
            firstEdit = false
        }
        
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var newText = textView.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: text)
        
        // resignFirstResponder() if return is pressed
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}