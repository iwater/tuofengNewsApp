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
    var type = "home"
    var titleStr = "首页"
    var loadMoreEnabled = false
    let defaultCellHeight:CGFloat = 130
    //var sideBar: SideMenu!
    //var sideMenu : SideMenu2?
    //var refreshControl:UIRefreshControl!
    
    @IBAction func HandleGesture(sender: AnyObject) {
        println("fired")
        view.userInteractionEnabled = false
        //sideMenu?.toggleMenu()
    }
    //@IBOutlet var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Bordered, target:nil, action:nil)
        self.title = titleStr
        //self.navigationController?.hidesBarsOnTap = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
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
        
        self.tableView.estimatedRowHeight = defaultCellHeight
        
        println(navigationItem.titleView?.frame)
        var tv = UIView(frame: CGRectMake(0, 0, 220, 25))
        tv.backgroundColor = UIColor.clearColor()
        
        var label = UILabel(frame: CGRectMake(16, 16, 100, 25))
        label.text = "· " + self.titleStr
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
        
        tv.addSubview(cr)
        tv.addSubview(label)
        
        //iv.setTranslatesAutoresizingMaskIntoConstraints(false)
        cr.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["logo"] = cr
        viewsDict["title"] = label
        
        tv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[title]-|", options: nil, metrics: nil, views: viewsDict))
        tv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[logo(21)]", options: nil, metrics: nil, views: viewsDict))
        tv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[logo(40)]", options: nil, metrics: nil, views: viewsDict))
        tv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-2-[logo]", options: nil, metrics: nil, views: viewsDict))
        tv.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[logo]-[title]", options: nil, metrics: nil,
                views: viewsDict))
        navigationItem.titleView = tv
        
        self.refresh()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("hits")
        //println(self.tableData)
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
        //println(rowData["commentCnt"].string)
        cell.comments.hidden = true
        if let count:Int = rowData["commentCnt"].integer {
            if count > 0 {
                let comment:String = "\u{E605} " + String(count)
                cell.comments.setTitle(comment, forState: UIControlState.Normal)
                //cell.comments.titleLabel?.text = "\u{E605} " + String(count)
                cell.comments.hidden = false
            }
        }
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
        cell.backgroundView = background
        let lay = background.layer
        //lay.borderColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        //lay.borderWidth = 4
        lay.backgroundColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        let v2 = UIView(frame: CGRect(x: 8.0, y: 8.0, width: 304.0, height: 112.0))
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
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let rowData = self.tableData[indexPath.row].object
        println(tableView.bounds)
        return defaultCellHeight
        //return NewsCell.heightForText(rowData["summary"]! as String, bounds: tableView.bounds)
    }*/
    
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
        newsHelper.getList(self.append, page:page++, type: type)
    }
    
    func refresh(_:AnyObject = "")
    {
        println("refreshed")
        page = 1
        newsHelper.getList(self.update, page:page++, type: type)
    }
    
    func setupNavigationItems() {
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "doRefresh")
        self.navigationItem.rightBarButtonItem = rightButton
        var leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: revealViewController(), action: "revealToggle:")
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if(segue.identifier == "openNewsComments") {
            var destination = segue.destinationViewController as CommentsViewController
            let position = sender.convertPoint(CGPointZero, toView: self.tableView)
            let path = self.tableView.indexPathForRowAtPoint(position)
            destination.news = self.tableData[path!.row]
        } else if (segue.identifier == "openNews") {
            var destination = segue.destinationViewController as ContentViewController
            if let selectedRows = self.tableView.indexPathsForSelectedRows() {
                destination.news = self.tableData[selectedRows[0].row]
            }
        }
    }
}