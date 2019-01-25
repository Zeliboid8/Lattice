	//
//  Switch.swift
//  Lattice
//
//  Created by Eli Zhang on 1/24/19.
//  Copyright © 2019 Eli Zhang. All rights reserved.
//

import UIKit

    
// Switch from guide at https://medium.com/@factoryhr/making-custom-uiswitch-part-1-cc3ab9c0b05b by Factory.hr
class Switch: UIControl {
    var onColor = Colors.blue
    var offColor = UIColor.lightGray
    var cornerRadius: CGFloat = 0.5
    var thumbTintColor = UIColor.white
    var thumbCornerRadius: CGFloat = 0.5
    var thumbSize = CGSize.zero
    var padding: CGFloat = 1
    var	isOn: Bool = false
    var animationDuration: Double = 0.5
    
    var thumbView = UIView(frame: CGRect.zero)
    var onPoint = CGPoint.zero
    var offPoint = CGPoint.zero
    var isAnimating = false
    
    func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onColor : self.offColor
            
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            
        }
        
    }
}
