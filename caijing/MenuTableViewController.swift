//
//  MenuTableViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-13.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(indexPath:NSIndexPath)
}

class MenuTableViewController: UITableViewController {
    
    var delegate : MenuTableViewControllerDelegate?
    var tableData : [[String:String]] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib:UINib = UINib(nibName: "MenuCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "MenuCell")
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as? MenuCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "MenuCell") as? MenuCell
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        /*var content : NSMutableAttributedString!
        content = NSMutableAttributedString(string:tableData[indexPath.row]["text"]!, attributes: [
            NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size: 14)
            ])
        
        content.addAttributes([
            NSFontAttributeName: UIFont(name:"icomoon", size:14),
            //NSExpansionAttributeName: 0.3,
            //NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))*/
        
        cell!.icon?.text = tableData[indexPath.row]["icon"]
        cell!.title?.text = tableData[indexPath.row]["title"]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuControllerDidSelectRow(indexPath)
    }
}
