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
    let URL = "http://caijing.tuofeng.cn/app/news/by_portals/?page=2&type=json"
    func getList(callback:(([[String:AnyObject]])->Void)) -> Void {
        Alamofire.request(.GET, URL)
            .responseJSON {(request, response, JSON, error) in
                let data = JSON as [[String:AnyObject]]
                callback(data)
        }
    }
}