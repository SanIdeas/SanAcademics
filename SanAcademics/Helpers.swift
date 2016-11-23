//
//  Helpers.swift
//  SanAcademics
//
//  Created by Alex Balladares Rojas on 21-11-16.
//  Copyright © 2016 SanIdeas. All rights reserved.
//
import UIKit

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
