//
//  BYWebConfiguration.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//

import UIKit

class BYWebConfiguration: NSObject,BYWebJSBridgeConfigurationProtocol {
    /**
     支持的scheme
     
     来自其他请求的过滤
     
     - parameter bridgeWebviewDelegate: 代理
     
     - returns: 支持的scheme
     */
    func methodSchemeNameWithBridgeWebviewDelegate(bridgeWebviewDelegate: BYWebJSBridgeWebviewDelegate) -> String {
        return "byjs"
    }
    /**
     支持的hostName
     
     来自其他请求的过滤
     
     - parameter bridgeWebviewDelegate: 代理
     
     - returns: 支持的hostName
     */
    func methodHostNameWithBridgeWebviewDelegate(bridgeWebviewDelegate: BYWebJSBridgeWebviewDelegate) -> String {
        return "appApi"
    }
}

