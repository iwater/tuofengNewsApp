//
//  ViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-1.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let newsHelper = NewsHelper()
    var tableData:[[String:AnyObject]] = []
    var refreshControl:UIRefreshControl!
                            
    @IBOutlet var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "驼峰财经·首页"
        self.navigationController?.navigationBar.tintColor = ColorHelper.UIColorFromRGB(0xffffff)
        self.navigationController?.navigationBar.barTintColor = ColorHelper.UIColorFromRGB(0x00bce2)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.newsTableView.addSubview(refreshControl)
        
        self.setupNavigationItems()
        
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("hits")
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as NewsCell
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.title.text = rowData["title"] as? String
        cell.summary.text = rowData["summary"] as? String
        //cell.contentView.backgroundColor = UIColor.redColor()
        //cell.contentView.layer.cornerRadius = 15
        //cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let background = UIView()
        let lay = background.layer
        lay.borderColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        lay.borderWidth = 4
        let v2 = UIView()
        v2.backgroundColor = UIColor.whiteColor()
        v2.layer.borderWidth = 1
        v2.layer.borderColor = ColorHelper.UIColorFromRGB(0xe6e6e3).CGColor
        v2.layer.cornerRadius = 15
        v2.layer.masksToBounds = true
        background.addSubview(v2)
        
        cell.backgroundView = background
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        println(tableView.bounds)
        return 100;
        //return NewsCell.heightForText(rowData["summary"]! as String, bounds: tableView.bounds)
    }
    
    func refresh()
    {
        //println("refreshed")
        newsHelper.getList(){(data:[[String:AnyObject]]) in
            //println(data)
            self.tableData = data
            self.newsTableView!.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupNavigationItems() {
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == "openNews") {
            var destination = segue.destinationViewController as DetailViewController
            if let selectedRows = newsTableView.indexPathsForSelectedRows() {
                //destination.news = self.tableData[selectedRows[0].row] as [String:AnyObject]
            }
        }
    }

}

