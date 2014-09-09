//
//  NewsCell.swift
//  caijing
//
//  Created by 马涛 on 14-9-2.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    class func heightForText(text: String, bounds: CGRect) -> CGFloat {
println("--------------------------")
        println(text)
        println("========================")
        /*var size = text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(bounds) - (CommentCellMarginConstant * 2) -
            (CommentCellMarginConstant * CGFloat(level)), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize)],
            context: nil)
        return CommentCellMarginConstant + CommentCellUsernameHeight + CommentCellTopMargin + size.height + CommentCellBottomMargin*/
        return 100;
    }

}
