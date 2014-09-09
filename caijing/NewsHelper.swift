//
//  NewsHelper.swift
//  caijing
//
//  Created by 马涛 on 14-9-2.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import Alamofire

class NewsHelper {
    let URL = "http://caijing.tuofeng.cn/app/news/by_portals/"
    func getList(callback:(([[String:AnyObject]])->Void), page:Int = 2) -> Void {
        Alamofire.request(.GET, URL, parameters: ["page": page, "type": "json"])
            .responseJSON {(request, response, JSON, error) in
                if let data: AnyObject = JSON? {
                    callback(data as [[String:AnyObject]])
                } else {
                    println(response)
                    callback([])
                }
        }
    }
}