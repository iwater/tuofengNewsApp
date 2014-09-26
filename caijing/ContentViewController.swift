//
//  ContentViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-17.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextViewDelegate {
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Bordered, target:nil, action:nil)
        navigationItem.titleView = TitleView(frame: CGRectMake(0, 0, 220, 25), title: "正文")
        
        var commentButton = UIBarButtonItem(title: "xxx", style: .Bordered, target: nil, action: nil)
        var app = UIBarButtonItem.appearance()
        //app.titleTextAttributesForState(<#state: UIControlState#>)

        
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
        
        self.summary.delegate = self
        
        println(self.summary.delegate)

        newsHelper.getLArticle(self.update, id: news["id"].integer!)
        //setupNavigationItems()
    }
    
    func setupCommentsButton(count: String) {
        //var view = UIView(frame: CGRectMake(0, 0, 50, 50))
        var button = UIButton(frame: CGRectMake(0, 0, 70, 50))
        button.setTitle("\u{E605} " + count, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "icomoon", size: 18)
        button.addTarget(self, action: "showComments", forControlEvents: UIControlEvents.TouchUpInside)
        
        /*var label = UILabel(frame: CGRectMake(0, 0, 70, 50))
        label.font = UIFont(name: "icomoon", size: 18)
        label.textColor = ColorHelper.UIColorFromRGB(0xffffff)
        label.text = "\u{E605} 100+"*/
        
        var btn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func showComments() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as CommentsViewController
        vc.news = news
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTableViewHeader() {
        //var headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        //headerView.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)

        let headerView = LineView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        headerView.backgroundColor = ColorHelper.UIColorFromRGB(0xf0f0f0)
        //tableView.tableHeaderView = bv
        
        var label = UILabel(frame: CGRectMake(16, 16, 100, 25))
        label.text = "延展悦读"
        label.font = UIFont(name:"HelveticaNeue-Light", size: 14)
        label.textColor = ColorHelper.UIColorFromRGB(0x999999)
        headerView.addSubview(label)
        
        //let bv = LineView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        //bv.backgroundColor = ColorHelper.UIColorFromRGB(0xf0f0f0)
        //tableView.tableHeaderView = bv
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
        
        if let news:JSONValue = self.newsDetail {
            if let links:[JSONValue] = self.newsDetail!["newsDetail"]["article"]["links"].array {
                for link:JSONValue in links {
                    let range = s1.rangeOfString(link["tag"].string!)
                    println("range")
                    println(range)
                    
                    //content.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.toRaw(), range: range)
                    //content.addAttribute(NSLinkAttributeName, value: link["link"].string!, range: range)
                    content.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.toRaw(), NSLinkAttributeName: link["link"].string!], range: range)
                }
            }
            
            if let keywords:[JSONValue] = self.newsDetail!["keywords"]["keywords"].array {
                for keyword:JSONValue in keywords {
                    let range = s1.rangeOfString(keyword.string!)
                    let url:String = "tuofeng://127.0.0.1/"
                    println("range")
                    println(range)
                    
                    //content.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.toRaw(), range: range)
                    content.addAttribute(NSForegroundColorAttributeName, value: ColorHelper.UIColorFromRGB(0xfaae4c), range: range)
                    content.addAttribute(NSLinkAttributeName, value: url, range: range)
                }
            }
        }
        self.summary.linkTextAttributes = [NSForegroundColorAttributeName: ColorHelper.UIColorFromRGB(0x00bce2)]
        self.summary.attributedText = content
        println(self.summary.textContainerInset)
    }
    
    func update(json:JSONValue) {
        self.newsDetail = json
        println(self.newsDetail)
        if let summary:String = newsDetail!["newsDetail"]["article"]["summary"].string {
            self.displaySummary(summary)
        }
        if let related:[JSONValue] = self.newsDetail!["related"]["related"].array {
            self.tableData = related
            self.tableView.reloadData()
        }
        self.tableHeightConstraint.constant = self.tableView.contentSize.height
        self.tableView.needsUpdateConstraints()
        if self.tableData.count == 0 {
          self.tableView.hidden = true
        }
        if let commentCnt:Int = newsDetail!["commentBox"]["commentCnt"].integer {
            self.setupCommentsButton(String(commentCnt))
        }
    }
    
    @IBAction func showSources(sender: AnyObject) {
        //UIActionSheet(title: "Title", delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: "OK").showInView(self.view)
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            if let sources:[JSONValue] = self.newsDetail!["sources"]["sources"].array {
                for source in sources {
                    let action = UIAlertAction(title: source["source"].string!, style: .Default) { action in
                        println(source)
                        var webview = self.storyboard?.instantiateViewControllerWithIdentifier("WebviewController") as WebviewController
                        webview.post = source
                        self.navigationController?.pushViewController(webview, animated: true)
                        //self.showDetailViewController(webview, sender: nil)
                    }
                    alertController.addAction(action)
                }
                let cancelAction = UIAlertAction(title: "返回", style: .Default, handler: { action in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(cancelAction)
            }
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            if let sources:[JSONValue] = self.newsDetail!["sources"]["sources"].array {
                for source in sources {
                    actionSheet.addButtonWithTitle(source["source"].string!)
                }
            }
            actionSheet.showInView(self.view)
        }
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
        //cell.layer.backgroundColor = ColorHelper.UIColorFromRGB(0xfafafa)
        cell.backgroundColor = ColorHelper.UIColorFromRGB(0xf0f0f0)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        var destination = segue.destinationViewController as ContentViewController
        if let selectedRows = self.tableView.indexPathsForSelectedRows() {
            destination.news = self.tableData[selectedRows[0].row]
        }
    }
    
    //UIActionSheetDelegate for iOS7
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println(buttonIndex)
        if let sources:[JSONValue] = self.newsDetail!["sources"]["sources"].array {
            var webview = self.storyboard?.instantiateViewControllerWithIdentifier("WebviewController") as WebviewController
            webview.post = sources[buttonIndex]
            self.navigationController?.pushViewController(webview, animated: true)
            //self.showDetailViewController(webview, sender: nil)
        }
    }
    
    // UITextViewDelegate
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        println(URL)
        if URL.scheme == "tuofeng" {
            let text = textView.text as NSString
            let clickedText = text.substringWithRange(characterRange)
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TopicViewController") as TopicViewController
            vc.topic = clickedText
            self.navigationController?.pushViewController(vc, animated: true)
            
            println(text.substringWithRange(characterRange))
            println(characterRange)
            
        } else if URL.scheme == "http" {
            var webview = self.storyboard?.instantiateViewControllerWithIdentifier("WebviewController") as WebviewController
            webview.url = URL
            self.navigationController?.pushViewController(webview, animated: true)
        }
        return false
    }
}