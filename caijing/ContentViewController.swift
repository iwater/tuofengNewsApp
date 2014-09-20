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
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showSourceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Bordered, target:nil, action:nil)
        self.title = "驼峰·正文"
        
        titleLabel.text = news["title"].string
        timeLabel.text = news["publish_time"].string
        
        if let content = news!["long_summary"].string {
            self.displaySummary(content)
        }
        
        showSourceButton.backgroundColor = ColorHelper.UIColorFromRGB(0xf0f0f0)
        showSourceButton.layer.borderColor = ColorHelper.UIColorFromRGB(0xd9d9d7).CGColor
        showSourceButton.layer.borderWidth = 0.5
        showSourceButton.layer.masksToBounds = true
        showSourceButton.layer.cornerRadius = 3
        view.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)
        summary.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)
        tableView.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)
        
        setTableViewHeader()
        
        newsHelper.getLArticle(self.update, id: news["id"].integer!)
    }
    
    func setTableViewHeader() {
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        headerView.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)
        var label = UILabel(frame: CGRectMake(16, 16, 100, 25))
        label.text = "延展悦读"
        label.font = UIFont(name:"HelveticaNeue-Light", size: 12)
        label.textColor = ColorHelper.UIColorFromRGB(0x999999)
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
    }
    
    func displaySummary(summary: String){
        let fontSize:CGFloat = 18.0
        
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
        self.tableHeightConstraint.constant = self.tableView.contentSize.height
        self.tableView.needsUpdateConstraints()
    }
    
    @IBAction func showSources(sender: AnyObject) {
        //UIActionSheet(title: "Title", delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: "OK").showInView(self.view)
        let destructiveButtonTitle = NSLocalizedString("Destructive Choice", comment: "")
        let otherButtonTitle = NSLocalizedString("Safe Choice", comment: "")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .Destructive) { action in
            NSLog("The \"Other\" alert action sheet's destructive action occured.")
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .Default) { action in
            NSLog("The \"Other\" alert action sheet's other action occured.")
        }
        
        // Add the actions.
        alertController.addAction(destructiveAction)
        alertController.addAction(otherAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell") as UITableViewCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        println(rowData.object)
        cell.textLabel?.text = rowData["title"].string
        cell.textLabel?.textColor = ColorHelper.UIColorFromRGB(0x4d4d4d)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        var destination = segue.destinationViewController as ContentViewController
        if let selectedRows = self.tableView.indexPathsForSelectedRows() {
            destination.news = self.tableData[selectedRows[0].row]
        }
    }
}