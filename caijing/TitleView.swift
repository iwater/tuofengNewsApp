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
        label.text = "· " + title
        label.font = UIFont(name:"Heiti-SC", size: 14)
        label.textColor = UIColor.whiteColor()
        
        var iv = UIImageView(image: UIImage(named: "tf"))
        var cr = UIView(frame: CGRectMake(0, 0, 40, 21))
        cr.backgroundColor = UIColor.whiteColor()
        cr.layer.borderColor = UIColor.whiteColor().CGColor
        cr.layer.borderWidth = 2
        cr.layer.cornerRadius = 2
        iv.frame = CGRectMake(2, 2, 36, 17)
        cr.addSubview(iv)
        
        self.addSubview(cr)
        self.addSubview(label)
        
        //iv.setTranslatesAutoresizingMaskIntoConstraints(false)
        cr.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["logo"] = cr
        viewsDict["title"] = label
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[title]-|", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[logo(21)]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[logo(40)]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-2-[logo]", options: nil, metrics: nil, views: viewsDict))
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[logo]-[title]", options: nil, metrics: nil,
                views: viewsDict))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}