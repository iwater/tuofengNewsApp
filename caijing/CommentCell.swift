//
//  CommentCell.swift
//  caijing
//
//  Created by 马涛 on 14-9-12.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    class func heightForText(text: String, bounds: CGRect) -> CGFloat {
        let space:CGFloat = 32.0
        let width = bounds.width - space
        var size = text.boundingRectWithSize(CGSizeMake(width, CGFloat.max),
        options: NSStringDrawingOptions.UsesLineFragmentOrigin,
        attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0)],
        context: nil)
        let h = size.height
        println(h)
        return 100;
    }
}