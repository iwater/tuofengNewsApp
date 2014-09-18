//
//  ContentViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-17.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

func lend2<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableData:[JSONValue] = []
    var news:JSONValue!
    var newsDetail:JSONValue?
    let newsHelper = NewsHelper()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Bordered, target:nil, action:nil)
        self.title = "驼峰·正文"
        
        titleLabel.text = news["title"].string
        timeLabel.text = news["publish_time"].string
        
        if let content = news!["long_summary"].string {
            self.displaySummary(content)
        }
        
        newsHelper.getLArticle(self.update, id: news["id"].integer!)
    }
    
    func displaySummary(summary: String){
        let fontSize:CGFloat = 17.0
        
        var content : NSMutableAttributedString!
        content = NSMutableAttributedString(string:summary, attributes: [
            NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size: fontSize)
            ])
        
        let s1:NSString = summary
        
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend() {
                (para2 : NSMutableParagraphStyle) in
                para2.headIndent = -5
                para2.firstLineHeadIndent = 2 * fontSize
                //para2.tailIndent = -10
                para2.lineBreakMode = .ByWordWrapping
                para2.alignment = .Justified
                para2.lineHeightMultiple = 1.1
                para2.hyphenationFactor = 1.0
                para2.paragraphSpacing = 15.0
                para2.paragraphSpacingBefore = 0.0
            }, range:NSMakeRange(0, s1.length))
        
        self.summary.attributedText = content
    }
    
    func update(json:JSONValue) {
        self.newsDetail = json
        println(self.newsDetail!["related"]["related"])
        if let summary:String = newsDetail!["newsDetail"]["article"]["summary"].string {
            self.displaySummary(summary)
        }
        if let related:[JSONValue] = self.newsDetail!["related"]["related"].array {
            self.tableData = related
            self.tableView.reloadData()
        }
    }
    @IBAction func showSources(sender: AnyObject) {
        UIActionSheet(title: "Title", delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: "OK").showInView(self.view)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell") as UITableViewCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        println(rowData.object)
        cell.textLabel?.text = rowData["title"].string
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        var destination = segue.destinationViewController as ContentViewController
        if let selectedRows = self.tableView.indexPathsForSelectedRows() {
            destination.news = self.tableData[selectedRows[0].row]
        }
    }
}