//
//  BYWebJSBridgeCallbackHandler.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//


import UIKit
import WebKit

class BYWebJSBridgeCallbackHandler: NSObject {

    private weak var wkWebView : WKWebView?
    private var callbackIdentifier : String?

    private init(wkWebView : WKWebView , callbackIdentifier : String ) {
        super.init()
        self.wkWebView = wkWebView
        self.callbackIdentifier = callbackIdentifier
    }
    
    convenience init?(webView : UIView , callbackIdentifier : String){
        guard let view = webView as? WKWebView else { return nil }
        self.init(wkWebView: view,callbackIdentifier: callbackIdentifier)
    }
    
    private func getCallbackString(state : String , resultData : Dictionary<String,AnyObject> )->String?{
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(resultData, options: NSJSONWritingOptions(rawValue: 0))
            if let resultDataString =  NSString(data: data, encoding: NSUTF8StringEncoding)?.stringByReplacingOccurrencesOfString("\"", withString: "\\\""){
                return "window.BYCallback(\"\(callbackIdentifier!)\", \"\(state)\", \"\(resultDataString)\")"
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    
    private func evaluateStateAction(state : String , resultData : Dictionary<String,AnyObject>){
        guard wkWebView != nil , let callbackString = getCallbackString(state, resultData: resultData) else{ return }
        wkWebView?.evaluateJavaScript(callbackString, completionHandler: nil)
    }
    
    func progressWithResultDictionary(resultData : Dictionary<String,AnyObject>){
        evaluateStateAction("progress", resultData: resultData)
    }
    func successWithResultDictionary(resultData : Dictionary<String,AnyObject>){
        evaluateStateAction("success", resultData: resultData)
    }
    func failedWithResultDictionary(resultData : Dictionary<String,AnyObject>){
        evaluateStateAction("fail", resultData: resultData)
    }

    
}
