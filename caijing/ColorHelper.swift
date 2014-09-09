//
//  ColorHelper.swift
//  caijing
//
//  Created by 马涛 on 14-9-7.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper {
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}