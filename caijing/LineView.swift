//
//  LineView.swift
//  caijing
//
//  Created by 马涛 on 14-9-22.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation

class LineView: UIView {
    override func drawRect(rect: CGRect) {
        self.backgroundColor = ColorHelper.UIColorFromRGB(0xf0f0f0)
        let width: CGFloat = CGRectGetWidth(rect)
        let step: CGFloat = 5.0
        var x: CGFloat = -step / 2
        var y: CGFloat
        var context = UIGraphicsGetCurrentContext()
        ColorHelper.UIColorFromRGB(0xfafafa).setFill()
        ColorHelper.UIColorFromRGB(0xfafafa).setStroke()
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, x, 0.0)
        for index in 1...65 {
            x += step
            y = (index % 2 == 1) ? step : 0.0
            CGContextAddLineToPoint(context, x, y)
        }
        CGContextAddLineToPoint(context, width, 0)
        CGContextAddLineToPoint(context, 0, 0)
        CGContextClosePath(context)
        CGContextDrawPath(context, kCGPathFillStroke)
    }
}