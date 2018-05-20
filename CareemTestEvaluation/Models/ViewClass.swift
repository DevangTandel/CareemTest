//
//  Viewclass.swift
//
//  Created by Silver Shark on 22/03/17.
//  Copyright © 2017 Devang Tandel. All rights reserved.
//

import Foundation
import  UIKit

/// This extesion adds some useful functions to UIView
public extension UIView {
    
    public func shakeView() {
        
        let shake: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(-5.0, 0.0, 0.0)), NSValue(caTransform3D: CATransform3DMakeTranslation(5.0, 0.0, 0.0))]
        shake.autoreverses = true
        shake.repeatCount = 2.0
        shake.duration = 0.07
        
        self.layer.add(shake, forKey:"shake")
    }
    
    public func createBordersWithColor(color: UIColor, radius: CGFloat, width: CGFloat) {
        
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
    }
    
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.borderColor = nil
    }
    
    public func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width:0.0, height:0.0)
    }
    
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    public func createCornerRadiusWithShadowWithColor(cornerRadius: CGFloat, offset: CGSize, opacity: Float, radius: CGFloat, color : UIColor) {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
