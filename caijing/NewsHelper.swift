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
    let URL_Type = "http://caijing.tuofeng.cn/app/news/by_portals/"
    let URL_Article = "http://caijing.tuofeng.cn/app/article/"
    let URL = "http://caijing.tuofeng.cn/app/"
    let URL_Tag = "http://caijing.tuofeng.cn/app/tag/"
    
    lazy var defaultHeaders: [String: String] = {
        let accept: String = "application/json"
        let userAgent: String = "tuofeng caijing app 1.0 http://caijing.tuofeng.cn/"
        
        return ["Accept": accept,
            "User-Agent": userAgent]
        }()
    
    init(){
        Alamofire.Manager.sharedInstance.defaultHeaders = defaultHeaders
        println(Alamofire.Manager.sharedInstance.defaultHeaders)
    }
    
    func getList(callback:(([JSONValue])->Void), page:Int = 1, type:String = "home") {
        let url = URL + "news/\(type)/"
        Alamofire.request(.GET, type == "home" ? URL : url, parameters: ["page": page, "type": "json"])
            .responseJSON {(request, response, JSON, error) in
                if let data: AnyObject = JSON? {
                    let json:[JSONValue] = JSONValue(data).array!
                    callback(json)
                }
        }
    }
    
    func getLArticle(callback:((JSONValue)->Void), id:Int) {
        let url = URL_Article + "\(id)/"
        Alamofire.request(.GET, url, parameters: ["type": "json"])
            .responseJSON {(request, response, JSON, error) in
                println(error)
                println(JSON)
                if let data: AnyObject = JSON? {
                    callback(JSONValue(data))
                }
        }
    }
    
    func getLArticleComments(callback:(([JSONValue])->Void), id:Int, page:Int = 1) {
        let url = URL_Article + "\(id)/comments/"
        Alamofire.request(.GET, url, parameters: ["page": page, "type": "json"])
            .responseJSON {(request, response, JSON, error) in
                if let data: AnyObject = JSON? {
                    let json:[JSONValue] = JSONValue(data)["comments"].array ?? []
                    callback(json)
                }
        }
    }
    
    func getTopic(callback:(([JSONValue])->Void), keyword:String, page:Int = 1) {
        let url = URL_Tag
        Alamofire.request(.GET, url, parameters: ["page": page, "type": "json", "keyword": keyword])
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
                if let data: AnyObject = JSON? {
                    if let articles: [JSONValue] = JSONValue(data)["articleList"]["articles"].array {
                        callback(articles)
                    }
                }
        }
    }

}