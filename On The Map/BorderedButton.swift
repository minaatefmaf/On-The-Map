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
    
    private func setBackingColor(backingColor: UIColor) -> Void {
        if (self.backingColor != nil) {
            self.backingColor = backingColor;
            self.backgroundColor = backingColor;
        }
    }
    
    private func setHighlightedBackingColor(highlightedBackingColor: UIColor) -> Void {
        self.highlightedBackingColor = highlightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: - Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent: UIEvent) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
    
}