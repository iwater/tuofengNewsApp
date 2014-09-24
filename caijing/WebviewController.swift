//
//  WebviewController.swift
//  caijing
//
//  Created by 马涛 on 14-9-20.
//  Copyright (c) 2014年 马涛. All rights reserved.
//

import Foundation
import UIKit

class WebviewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView : UIWebView! = nil
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    var post: JSONValue!
    var url: NSURL?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        if let realpost = self.post {
            if let realUrl:String = self.post["url"].string {
                self.webView.loadRequest(NSURLRequest(URL: NSURL(string: realUrl)))
            }
        }
        if let url = self.url {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func setupLoadingButton() {
        self.navigationItem.rightBarButtonItem = nil
        var loadingItem = UIBarButtonItem(customView: self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = loadingItem
    }
    
    func setupShareButton() {
        self.navigationItem.rightBarButtonItem = nil
        var shareItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func onShareButton() {
        //Helper.showShareSheet(self.post, controller: self, barbutton: self.navigationItem.rightBarButtonItem)
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        self.setupLoadingButton()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        self.setupShareButton()
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}
