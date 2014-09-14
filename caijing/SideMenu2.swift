//
//  SideMenu2.swift
//  caijing
//
//  Created by 马涛 on 14-9-13.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import UIKit

@objc protocol SideMenuDelegate {
    func sideMenuDidSelectItemAtIndex(index:[String:String])
    optional func sideMenuWillOpen()
    optional func sideMenuWillClose()
}

class SideMenu2 : NSObject, MenuTableViewControllerDelegate {
    
    let menuWidth : CGFloat = 160.0
    let menuTableViewTopInset : CGFloat = 0 // if you use translusent navigation bar
    let sideMenuContainerView =  UIView()
    let sideMenuTableViewController = MenuTableViewController()
    var animator : UIDynamicAnimator!
    let sourceView : UIView!
    var delegate : SideMenuDelegate?
    var isMenuOpen : Bool = false
    
    init(sourceView: UIView, menuData:[[String:String]]) {
        super.init()
        self.sourceView = sourceView
        self.sideMenuTableViewController.tableData = menuData
        
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView:sourceView)
        // Add show gesture recognizer
        var showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        sourceView.addGestureRecognizer(showGestureRecognizer)
        
        // Add hide gesture recognizer
        var hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        sideMenuContainerView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    
    func setupMenuView() {
        
        // Configure side menu container
        sideMenuContainerView.frame = CGRectMake(-menuWidth-1.0, sourceView.frame.origin.y, menuWidth, sourceView.frame.size.height)
        sideMenuContainerView.backgroundColor = UIColor.whiteColor()
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false;
        sideMenuContainerView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        sideMenuContainerView.layer.shadowRadius = 1.0;
        sideMenuContainerView.layer.shadowOpacity = 0.125;
        sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).CGPath
        
        sourceView.addSubview(sideMenuContainerView)
        
        // Add blur view
        //var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        //visualEffectView.frame = sideMenuContainerView.bounds
        //sideMenuContainerView.addSubview(visualEffectView)
        
        // Configure side menu table view
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.tableView.frame = sideMenuContainerView.bounds
        sideMenuTableViewController.tableView.clipsToBounds = false
        sideMenuTableViewController.tableView.separatorStyle = .SingleLine
        sideMenuTableViewController.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        sideMenuTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideMenuTableViewController.tableView.scrollsToTop = false
        sideMenuTableViewController.tableView.contentInset = UIEdgeInsetsMake(menuTableViewTopInset, 0, 0, 0)
        
        sideMenuTableViewController.tableView.reloadData()
        
        sideMenuContainerView.addSubview(sideMenuTableViewController.tableView)
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) {
        
        if (gesture.direction == .Left) {
            toggleMenu(false)
            delegate?.sideMenuWillClose?()
        }
        else{
            toggleMenu(true)
            delegate?.sideMenuWillOpen?()
        }
    }
    
    func toggleMenu (shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isMenuOpen = shouldOpen
        let gravityDirectionX: CGFloat = (shouldOpen) ? 0.5 : -0.5;
        let pushMagnitude: CGFloat = (shouldOpen) ? 20.0 : -20.0;
        let boundaryPointX: CGFloat = (shouldOpen) ? menuWidth : -menuWidth-1.0;
        
        let gravityBehavior = UIGravityBehavior(items: [sideMenuContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0.0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [sideMenuContainerView])
        collisionBehavior.addBoundaryWithIdentifier("menuBoundary", fromPoint: CGPointMake(boundaryPointX, 20.0),
            toPoint: CGPointMake(boundaryPointX, sourceView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = pushMagnitude
        animator.addBehavior(pushBehavior)
        
        let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
        menuViewBehavior.elasticity = 0.3
        animator.addBehavior(menuViewBehavior)
    }
    
    func menuControllerDidSelectRow(indexPath:NSIndexPath) {
        delegate?.sideMenuDidSelectItemAtIndex(self.sideMenuTableViewController.tableData[indexPath.row])
    }
    
    func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
        else {
            toggleMenu(true)
        }
    }
}
