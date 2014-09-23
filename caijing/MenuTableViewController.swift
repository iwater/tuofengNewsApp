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

class MenuTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableData : [[String:String]] = [["icon": "\u{E603}", "title": "财经导航", "key": "links"], ["icon": "\u{E600}", "title": "首页", "key": "home"], ["icon": "\u{E602}", "title": "媒体热门", "key": "by_portals"], ["icon": "\u{E601}", "title": "热评资讯", "key": "by_social"], ["icon": "\u{E604}", "title": "滚动新闻", "key": "latest"], ["icon": "\u{E604}", "title": "新股", "key": "ipo"], ["icon": "\u{E604}", "title": "港股", "key": "hk"], ["icon": "\u{E604}", "title": "基金", "key": "fund"], ["icon": "\u{E604}", "title": "期货", "key": "futures"], ["icon": "\u{E604}", "title": "外汇", "key": "forex"]]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let nib:UINib = UINib(nibName: "MenuCell", bundle: nil)
        //tableView.registerNib(nib, forCellReuseIdentifier: "MenuCell")
        //let cell2 = tableView.dequeueReusableCellWithIdentifier("MenuCell") as MenuCell
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell2") as MenuCell2
        //println(cell2)
        //let cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as HomeItemCell
        
        cell.icon?.text = tableData[indexPath.row]["icon"]
        cell.title?.text = tableData[indexPath.row]["title"]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("home") as HomeViewController
        vc.type = self.tableData[indexPath.row]["key"]!
        vc.titleStr = self.tableData[indexPath.row]["title"]!
        let gc = UINavigationController(rootViewController: vc)
        let mc = self.revealViewController()
        mc.pushFrontViewController(gc, animated: true)
    }
}
