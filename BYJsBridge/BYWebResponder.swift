//
//  BYWebResponder.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//


import UIKit

class BYWebResponder: NSObject,BYWebJSBridgeNativeResponderProtocol {
    static func bindMethod() -> String {
        return "test"
    }
    func performActionWithParams(params: Dictionary<String, AnyObject>?, callbackHandler: BYWebJSBridgeCallbackHandler) {
        
        if params == nil{ return }
        guard let message = params!["message"] as? String else{
            return
        }
        
        print(message)
        
        callbackHandler.successWithResultDictionary(["success":"success"])
        
    }
}

