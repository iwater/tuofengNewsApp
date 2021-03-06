//
//  TopicViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-24.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class TopicViewController: UITableViewController {
    var topic: String = ""
    let newsHelper = NewsHelper()
    var tableData:[JSONValue] = []
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = TitleView(frame: CGRectMake(0, 0, 220, 25), title: "专题")
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Bordered, target:nil, action:nil)

        tableView.layer.backgroundColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        newsHelper.getTopic(self.update, keyword: topic, page: page++)
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 60))
        headerView.backgroundColor = ColorHelper.UIColorFromRGB(0xf16262)
        
        var label = UILabel(frame: CGRectMake(10, 17, 300, 26))
        label.text = "关于" + topic + "的专栏"
        label.font = UIFont(name:"HelveticaNeue-Light", size: 20)
        label.textColor = ColorHelper.UIColorFromRGB(0xffffff)
        headerView.addSubview(label)
        
        tableView.tableHeaderView = headerView

    }
    
    func update(data:[JSONValue]) {
        self.tableData = data
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        //self.loadMore()
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
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.contentView.layer.backgroundColor = UIColor.clearColor().CGColor
        cell.contentView.layer.borderWidth = 16
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
        
        let background = UIView()
        cell.backgroundView = background
        let lay = background.layer
        lay.backgroundColor = ColorHelper.UIColorFromRGB(0xf2f2f0).CGColor
        let v2 = UIView(frame: CGRect(x: 8.0, y: 8.0, width: 304.0, height: 112.0))
        v2.layer.backgroundColor = UIColor.whiteColor().CGColor
        v2.layer.borderWidth = 1
        v2.layer.borderColor = ColorHelper.UIColorFromRGB(0xe6e6e3).CGColor
        v2.layer.cornerRadius = 3
        v2.layer.masksToBounds = true
        background.addSubview(v2)
        
        cell.summary.tintColor = ColorHelper.UIColorFromRGB(0xf2f2f0)

        cell.backgroundView = background
        
        return cell
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