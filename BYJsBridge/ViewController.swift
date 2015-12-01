//
//  ViewController.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView! = WKWebView()
    var webDelegate = BYWebJSBridgeWebviewDelegate()
    var configuration = BYWebConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[web]-0-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["web":webView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[web]-0-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["web":webView]))
        webView.UIDelegate = webDelegate
        webView.navigationDelegate = webDelegate
        webDelegate.registeConfigurationClass(configuration)
        webDelegate.registeNativeResponderClass(BYWebResponder.self)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://localhost/html/test.html")!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

