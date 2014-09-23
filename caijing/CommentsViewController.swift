//
//  CommentsViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-12.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class CommentsViewController: UITableViewController {
    var news:JSONValue!
    
    let newsHelper = NewsHelper()
    var tableData:[JSONValue] = []
    var page = 1
    var loadMoreEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = TitleView(frame: CGRectMake(0, 0, 220, 25), title: "评论")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        newsHelper.getLArticleComments(self.update, id: news["id"].integer!, page: page++)
    }
    
    override func viewDidLayoutSubviews() {
        // fix ios8 BUG: cell separtor left margin
        // http://stackoverflow.com/questions/25128117/ios-8-setting-setseparatorinset-to-zero
        // http://openradar.io/17678622
        let systemVersion = UIDevice.currentDevice().systemVersion as NSString
        if systemVersion.doubleValue >= 8.0 {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("hits")
        println(self.tableData)
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as CommentCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        
        println(indexPath.row)
        
        if (loadMoreEnabled && indexPath.row == self.tableData.count-1) {
            self.loadMore()
        }
        
        cell.content.text = rowData["msg_content"].string
        cell.user.text = rowData["msg_username"].string
        cell.time.text = rowData["timeTxt"].string
        if let avatar_url:String = rowData["user"]["profile_image_url"].string {
            //let urlString: NSString = rowData["user"]["profile_image_url"].string as? NSString
            //let imgURL: NSURL = NSURL(string: avatar_url)
            //let imgData: NSData = NSData(contentsOfURL: imgURL)
            //cell.avatar.image = UIImage(data: imgData)
            cell.avatar.layer.cornerRadius = 18
            cell.avatar.clipsToBounds = true
            
            
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: avatar_url)
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    cell.avatar.image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    //self.imageCache[urlString] = image
                    //if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    //    cellToUpdate.imageView.image = image
                    //}
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        
        // fix ios8 BUG: cell separtor left margin
        // http://stackoverflow.com/questions/25128117/ios-8-setting-setseparatorinset-to-zero
        // http://openradar.io/17678622
        let systemVersion = UIDevice.currentDevice().systemVersion as NSString
        if systemVersion.doubleValue >= 8.0 {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let systemVersion = UIDevice.currentDevice().systemVersion as NSString
        if systemVersion.doubleValue >= 8.0 {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        let rowData:JSONValue = self.tableData[indexPath.row]
        println(tableView.bounds)
        let h = CommentCell.heightForText(rowData["msg_content"].string!, bounds: tableView.bounds)
        println(h)
        return h
        //return NewsCell.heightForText(rowData["summary"]! as String, bounds: tableView.bounds)
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
        newsHelper.getLArticleComments(self.append, id: news["id"].integer! , page:page++)
    }
}