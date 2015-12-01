//
//  BYWebJSBridgeConfigurationProtocol.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//


import UIKit


protocol BYWebJSBridgeConfigurationProtocol{
    func methodSchemeNameWithBridgeWebviewDelegate(bridgeWebviewDelegate : BYWebJSBridgeWebviewDelegate)->String
    func methodHostNameWithBridgeWebviewDelegate(bridgeWebviewDelegate : BYWebJSBridgeWebviewDelegate)->String
}
protocol BYWebJSBridgeNativeResponderProtocol{
    static func bindMethod()->String
    func performActionWithParams(params : Dictionary<String,AnyObject>? , callbackHandler : BYWebJSBridgeCallbackHandler)
}
