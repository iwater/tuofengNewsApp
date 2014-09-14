//
//  sideMenu.swift
//  caijing
//
//  Created by 马涛 on 14-9-13.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

let ANIMATION_DURATION = 0.3

protocol SideViewDelegate {
    func buttonPressed(sender: UIButton, id: Int)
}

class SideMenu: UIView {
    
    var isVisible = false
    var delegate: SideViewDelegate?
    var topView: UIView?
    
    //private let dimView = UIVisualEffectView (effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    private let dimView = UIView()
    
    var buttons = [UIButton]()
    
    override init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    init(view: UIView) {
        super.init(frame: CGRect(x: -60, y: 20, width: 60, height: view.frame.size.height-40))
        
        println(self.frame.size.height)
        backgroundColor = UIColor.wetAsphalt()
        
        for i in 0...7 {
            let tempButton = UIButton()
            let yWert = CGFloat(Float(i)*50.0*1.25+21.0)
            tempButton.frame = CGRectMake(5, yWert, 50, 50)
            tempButton.backgroundColor = UIColor.belizeHole()
            tempButton.tag = i+1
            tempButton.addTarget(self, action: "buttonIsPressed:", forControlEvents: .TouchUpInside)
            addSubview(tempButton)
            buttons.append(tempButton)
        }
        
        dimView.backgroundColor = UIColor.blackColor()
        dimView.frame = view.bounds
        /*
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = view.bounds
        effectView.alpha = 0.8
        effectView.backgroundColor = UIColor.blackColor()
        
        view.addSubview(effectView)*/
        
        topView = view
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(scrollingView: UIScrollView!) {
        frame.origin.y = scrollingView.contentOffset.y + 20
    }
    
    func animateMe() {
        let completion: (Bool) -> Void = { finished in
            self.dimView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
        
        if isVisible {
            UIView.animateWithDuration(ANIMATION_DURATION, animations: {
                self.frame.origin.x = -60
                self.dimView.alpha = 0
                }, completion: completion)

        }
        else {
            dimView.alpha = 0
            topView!.addSubview(dimView)
            topView!.addSubview(self)
            UIView.animateWithDuration(ANIMATION_DURATION, animations: {
                self.frame.origin.x = 0
                self.dimView.alpha = 0.8
            })
        }
        isVisible = !isVisible
    }
    
    func buttonIsPressed(sender: UIButton) {
        // TO DO
        delegate?.buttonPressed(sender, id: sender.tag)
        
    }
    
}

extension UIColor {
    class func wetAsphalt() -> UIColor {
        return UIColor(red: 52/255.0, green: 73/255.0, blue: 94/255.0, alpha: 0.7)
    }
    class func belizeHole() -> UIColor {
        return UIColor(red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1)
    }
}