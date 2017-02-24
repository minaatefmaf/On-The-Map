//
//  BorderedButton.swift
//  On The Map
//
//  Created by Mina Atef on 8/31/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

// Constants for styling and configuration
let borderedButtonHeight: CGFloat = 44.0
let borderedButtonCornerRadius: CGFloat = 4.0
let phoneBorderedButtonExtraPadding : CGFloat = 14.0

class BorderedButton: UIButton {
    
    // MARK: - Properties
    
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    
    // MARK: - Setters
    
    fileprivate func setBackingColor(_ backingColor: UIColor) -> Void {
        if (self.backingColor != nil) {
            self.backingColor = backingColor;
            self.backgroundColor = backingColor;
        }
    }
    
    fileprivate func setHighlightedBackingColor(_ highlightedBackingColor: UIColor) -> Void {
        self.highlightedBackingColor = highlightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: - Tracking
    
    override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with withEvent: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTracking(with event: UIEvent?) {
        backgroundColor = backingColor
    }
    
}
