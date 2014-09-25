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
            
            var leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: revealViewController(), action: "revealToggle:")
            var backButton = UIBarButtonItem(title: "后退", style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
            self.navigationItem.leftBarButtonItems = [leftButton, backButton]
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        println(self)
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
    
    func goBack() {
        webView.goBack()
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        self.setupLoadingButton()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        self.setupShareButton()
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}
