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
    let newsHelper = NewsHelper()
    
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
        //contentView.text = news!["long_summary"]! as String
        
        
        if let s2 = news!["long_summary"].string {
            let fontSize:CGFloat = 17.0
        
        var content : NSMutableAttributedString!
        content = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size: fontSize)
            ])
        /*content.addAttributes([
            //NSFontAttributeName: UIFont(name:"HelveticaNeue-Light", size:24),
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))*/
        
        let s1:NSString = s2
        
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
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(json:JSONValue) {
        self.news = json
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println("hits")
        //println(self.tableData)
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell") as UITableViewCell
        
        let rowData:JSONValue = self.tableData[indexPath.row]
        //cell.content.text = rowData["msg_content"].string
        
        return cell
    }
    
}
