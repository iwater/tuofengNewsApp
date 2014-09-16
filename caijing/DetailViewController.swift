//
//  DetailViewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-4.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableData:[JSONValue] = []
    var news:JSONValue!
    var newsDetail:JSONValue?
    let newsHelper = NewsHelper()
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "驼峰·正文"
        
        newsHelper.getLArticle(self.update, id: news["id"].integer!)
        
        titleLabel.text = news["title"].string
        timeLabel.text = news["publish_time"].string
        sourceLabel.text = news["source"].string
        
        if let summary = news!["long_summary"].string {
            self.displaySummary(summary)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func displaySummary(summary: String){
            let fontSize:CGFloat = 17.0
            
            var content : NSMutableAttributedString!
            content = NSMutableAttributedString(string:summary, attributes: [
                NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size: fontSize)
                ])
            /*content.addAttributes([
            //NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size:24),
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))*/
            
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
            
            contentView.attributedText = content
            contentView.tintColor = ColorHelper.UIColorFromRGB(0x1f1f1f)
            contentView.scrollEnabled = false
            contentView.contentInset.left = 50
    }
    
    func update(json:JSONValue) {
        self.newsDetail = json
        println(newsDetail)
        if let summary:String = newsDetail!["newsDetail"]["article"]["summary"].string {
            self.displaySummary(summary)
            println(summary)
            println("hit")
            println(self.contentView.contentSize)
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.contentSize.width, self.contentView.contentSize.height);
            self.view.setNeedsLayout()
            view.layoutSubviews()
            println(self.scroller.contentSize)
            println(self.scroller.scrollEnabled)
            self.scroller.contentSize = CGSizeMake(self.scroller.frame.size.width, self.contentView.frame.origin.y + self.contentView.frame.size.height)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell") as UITableViewCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        //cell.content.text = rowData["msg_content"].string
        
        return cell
    }
    
}
