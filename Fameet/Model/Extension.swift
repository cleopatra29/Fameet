//
//  Color.swift
//  FinalChallengeVessel
//
//  Created by Terretino on 13/02/19.
//  Copyright © 2019 Terretino. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let buttonColor = UIColor().colorFromHex("#FFDB59")
    static let highLightColor = UIColor().colorFromHex("#FFd635")
    static let datePickedViewColor = UIColor().colorFromHex("#F2F2F2")

    
    func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6 {
            return UIColor.black
        }
        var rgb: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                                          alpha: 1.0)
    }
}

extension UIView {
    func shappingButton() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func shapingView() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.5
        self.layer.shadowOffset = CGSize (width: 0, height: 1.5)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func animating(_ delayTime: Double) {
        UIView.animate(withDuration: 1, delay: delayTime, options: .beginFromCurrentState, animations: {
            self.alpha = 1
        }, completion: {
            (animate) in
        })
    }
    
    func animatingWithMovement(_ delayTime: Double) {
        UIView.animate(withDuration: 1, delay: delayTime, options: .beginFromCurrentState, animations: {
            self.center.x += 16
            self.alpha = 1
        }, completion: {
            (animate) in
        })
    }
    
    func animatingColoring(_ delayTime: Double, _ color: UIColor) {
        UIView.animate(withDuration: 0.25, delay: delayTime, options: .beginFromCurrentState, animations: {
            self.backgroundColor = color
        }, completion: {
            (animate) in
        })
    }
    
    func animatingDatePickedView(_ delayTime: Double) {
        UIView.animate(withDuration: 0.25, delay: delayTime, options: .beginFromCurrentState, animations: {
            self.center.x += 10
        }, completion: {
            (animate) in
        })
    }
}
