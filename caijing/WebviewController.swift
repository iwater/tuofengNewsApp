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
        
        if 1 == self.navigationController?.viewControllers.count {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.barTintColor = ColorHelper.UIColorFromRGB(0x00bce2)
            
            var backArrow = UIBarButtonItem(image: UIImage(named: "arrow"), style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
            self.navigationItem.leftBarButtonItem = backArrow
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        if let url = webView.stringByEvaluatingJavaScriptFromString("window.location.href") {
            //UIApplication.sharedApplication().openURL(NSURL(string: url))
            if let title = webView.stringByEvaluatingJavaScriptFromString("document.title") {
                println(title)
                self.sendContentToWechat(url, title: title)
            } else {
                println("fail")
            
            }
        }
    }
    
    func sendContentToWechat(url: String, title: String) {
        println(post)
        let message:WXMediaMessage = WXMediaMessage()
        message.title = title
        message.description = "TEST"
        let ext:WXAppExtendObject = WXAppExtendObject()
        ext.url = url
        message.mediaObject = ext
        let req:SendMessageToWXReq = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1
        WXApi.sendReq(req)
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.revealViewController().revealToggleAnimated(true)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        self.setupLoadingButton()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        self.setupShareButton()
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}
