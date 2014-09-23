//
//  TitleView.swift
//  caijing
//
//  Created by 马涛 on 14-9-23.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class TitleView: UIView {
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        var label = UILabel(frame: CGRectMake(16, 16, 100, 25))
        label.text = title
        label.font = UIFont(name:"Heiti-SC", size: 14)
        label.textColor = UIColor.whiteColor()
        
        var iv = UIImageView(image: UIImage(named: "logo"))
        iv.frame = CGRectMake(2.5, 1.5, 33, 15)
        
        var cr = UIView(frame: CGRectMake(0, 0, 39, 19))
        cr.backgroundColor = UIColor.whiteColor()
        cr.layer.borderColor = UIColor.whiteColor().CGColor
        cr.layer.borderWidth = 1.5
        cr.layer.cornerRadius = 1.5
        
        cr.addSubview(iv)
        
        self.addSubview(cr)
        self.addSubview(label)
        
        cr.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["logo"] = cr
        viewsDict["title"] = label
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-2-[title]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[logo(19)]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[logo(39)]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-2-[logo]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[logo]-12-[title]", options: nil, metrics: nil,
                views: viewsDict))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        var context = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().setFill()
        CGContextFillRect(context, CGRectMake(45, 10, 2.5, 2.5))
    }
}