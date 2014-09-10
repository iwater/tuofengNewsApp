//
//  HomeViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-8.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UITableViewController {
    let newsHelper = NewsHelper()
    var tableData:[JSONValue] = []
    var page = 1
    var loadMoreEnabled = false
    //var refreshControl:UIRefreshControl!
    
    @IBOutlet var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "驼峰财经·首页"
        //self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = ColorHelper.UIColorFromRGB(0x00bce2)
        self.tableView.layer.backgroundColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.addTarget(<#target: AnyObject?#>, action: <#Selector#>, forControlEvents: <#UIControlEvents#>)
        //self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(refreshControl)
        
        self.setupNavigationItems()
        
        //self.tableView.contentOffset = CGPointMake(0, -self.refreshControl?.frame.size.height)
        self.refresh()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("hits")
        println(self.tableData)
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as HomeItemCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        
        println(indexPath.row)
        
        if (loadMoreEnabled && indexPath.row == self.tableData.count-1) {
            self.loadMore()
        }
        
        cell.title.text = rowData["title"].string
        cell.summary.text = rowData["summary"].string
        cell.source.text = rowData["source"].string
        cell.time.text = rowData["timeTxt"].string
        //cell.contentView.backgroundColor = UIColor.redColor()
        //cell.contentView.layer.borderWidth = 15
        //cell.contentView.layer.borderColor = UIColor.blueColor().CGColor
        //cell.contentView.layer.cornerRadius = 10
        //cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.contentView.layer.backgroundColor = UIColor.clearColor().CGColor
        cell.contentView.layer.borderWidth = 16
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
        
        
        let background = UIView()
        //cell.backgroundView = background
        let lay = background.layer
        lay.borderColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        lay.borderWidth = 4
        lay.backgroundColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        let v2 = UIView(frame: CGRect(x: 8.0, y: 4.0, width: 304.0, height: 112.0))
        v2.layer.backgroundColor = UIColor.whiteColor().CGColor
        v2.layer.borderWidth = 1
        v2.layer.borderColor = ColorHelper.UIColorFromRGB(0xe6e6e3).CGColor
        v2.layer.cornerRadius = 3
        v2.layer.masksToBounds = true
        background.addSubview(v2)
        
        //let constraint = NSLayoutConstraint(item: background, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: v2, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        //background.addConstraint(constraint)
        //v2.layer.frame =
        
        cell.summary.tintColor = ColorHelper.UIColorFromRGB(0xf2f2f0)
        //println(self.tableData.count)
        cell.backgroundView = background
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let rowData = self.tableData[indexPath.row].object
        println(tableView.bounds)
        return 130;
        //return NewsCell.heightForText(rowData["summary"]! as String, bounds: tableView.bounds)
    }
    
    func doRefresh() {
        self.refresh("")
    }
    
    func update(data:[JSONValue]) {
        self.tableData = data
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.loadMore()
    }
    
    func append(data:[JSONValue]) {
        //var tempDatasource:NSMutableArray = NSMutableArray(array: self.tableData, copyItems: false)
        for item in data {
            self.tableData.append(item)
        }
        //self.tableData.append(data)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.loadMoreEnabled = true
    }
    
    func loadMore() {
        println("tring load more")
        self.loadMoreEnabled = false
        newsHelper.getList2(self.append, page:page++)
    }
    
    func refresh(_:AnyObject = "")
    {
        println("refreshed")
        newsHelper.getList2(self.update, page:page++)
    }
    
    func setupNavigationItems() {
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "doRefresh")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == "openNews") {
            var destination = segue.destinationViewController as DetailViewController
            if let selectedRows = self.tableView.indexPathsForSelectedRows() {
                destination.news = self.tableData[selectedRows[0].row]
            }
        }
    }
    
}

