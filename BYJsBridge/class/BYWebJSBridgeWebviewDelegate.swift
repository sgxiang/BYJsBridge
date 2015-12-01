//
//  BYWebJSBridgeWebviewDelegate.swift
//  BYJsBridge
//
//  Created by ysq on 15/12/1.
//  Copyright © 2015年 ysq. All rights reserved.
//


import UIKit
import WebKit

class BYWebJSBridgeWebviewDelegate : NSObject,WKNavigationDelegate,WKUIDelegate  {
    
    /// 回调保存的参数
    private let kCTJSBridgeParamKeyCallbackIdentifier = "callbackIdentifier";
    /// 参数携带的数据块
    private let kCTJSBridgeParamKeyParams = "data";
    /// 方法名
    private let kCTJSBridgeParamKeyNativeAPIName = "methodName";
    
    /// 存储js命令配置
    private var configuration : BYWebJSBridgeConfigurationProtocol?
    /// 存储js命令执行的响应类
    private var responderDictionary : Dictionary<String,BYWebJSBridgeNativeResponderProtocol> = Dictionary()
    /// 存储js命令执行的响应类索引
    private var  responderClassDictionary  : Dictionary<String,Any> = Dictionary()

    /**
    配置对js操作的可执行域
    
    - parameter object: 配置类
    */
    func registeConfigurationClass(object : BYWebJSBridgeConfigurationProtocol){
        self.configuration = object
    }
    
    /**
    注册js命令可执行的方法回调
    
    - parameter responderObject: 响应配置对象
    */
    func registeNativeResponderClass <T : NSObject where T : BYWebJSBridgeNativeResponderProtocol>(responderObject : T.Type){
        self.responderClassDictionary[responderObject.bindMethod()] = T.self
    }
    
    //MARKL - jsBridgeCheck
    
    /**
    检测是否是js执行命令  ->  scheme 和 hostName
    
    - parameter url: 地址
    
    - returns: 是否是执行命令
    */
    private func checkIsJsBridgeAction(url : NSURL)->Bool{
        if url.scheme == configuration?.methodSchemeNameWithBridgeWebviewDelegate(self) && url.host == configuration?.methodHostNameWithBridgeWebviewDelegate(self){
            return true
        }
        return false
    }
    
    //MARK: private methods
    
    /**
    将参数转为字典
    kCTJSBridgeParamKeyParams存储参数中携带的数据字典
    
    - parameter queryString: 参数字符串
    
    - returns: 参数字典
    */
    private func dictionaryWithQueryString(queryString : String)->Dictionary<String,AnyObject>{
        var resultDictionary : Dictionary<String,AnyObject> = Dictionary()
        let components : NSArray = NSArray(array:  queryString.componentsSeparatedByString("&") )
        components.enumerateObjectsUsingBlock { (obj, idx, stop) -> Void in
            if let str = obj as? String{
                let param = str.componentsSeparatedByString("=")
                if param.count == 2{
                    let key = param[0]
                    let encodeValue = param[1]
                    let decodedValue = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(nil, encodeValue, "", CFStringBuiltInEncodings.UTF8.rawValue)
                    resultDictionary[key] = decodedValue as String
                }
            }
        }
        
        do{
            let param = try NSJSONSerialization.JSONObjectWithData(resultDictionary[kCTJSBridgeParamKeyParams]!.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions(rawValue: 0))
            if let dic = param as? Dictionary<String,AnyObject>{
                resultDictionary[kCTJSBridgeParamKeyParams] = dic
            }else{
                resultDictionary.removeValueForKey(kCTJSBridgeParamKeyParams)
            }
        }catch{
            resultDictionary.removeValueForKey(kCTJSBridgeParamKeyParams)
        }
        return resultDictionary
    }
    
    
    private func responderWithMethodName(methodName : String)->BYWebJSBridgeNativeResponderProtocol?{
        if responderClassDictionary.keys.contains(methodName) && responderDictionary[methodName] == nil{
            responderDictionary[methodName] = (responderClassDictionary[methodName] as? NSObject.Type)!.init() as? BYWebJSBridgeNativeResponderProtocol
        }
        return responderDictionary[methodName]
    }
    

    //MARK:- WKWebView delegate
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        //判断是否是交互命令
        if checkIsJsBridgeAction(navigationAction.request.URL!) && navigationAction.request.URL!.query != nil{
            //获取参数字典
            let params = dictionaryWithQueryString(navigationAction.request.URL!.query!)
            
            if let identifier = params[kCTJSBridgeParamKeyCallbackIdentifier] as? String , let apiName = params[kCTJSBridgeParamKeyNativeAPIName] as? String{
                
                //生成js函数处理类
                let callbackHandler = BYWebJSBridgeCallbackHandler(webView: webView, callbackIdentifier: identifier)
                
                //查找是否有处理该apiName请求的处理类
                if let responder : BYWebJSBridgeNativeResponderProtocol = responderWithMethodName(apiName){
                    //告诉网页js处理即将开始
                    callbackHandler?.progressWithResultDictionary(["status":"willStartAction","params":params])
                    //响应器回调
                    responder.performActionWithParams(params[kCTJSBridgeParamKeyParams] as? Dictionary<String,AnyObject>, callbackHandler: callbackHandler!)
                }else{
                    //js处理流程出错，无法响应该方法
                    callbackHandler?.failedWithResultDictionary(["error":"no responder for your method"])
                }
                decisionHandler(.Cancel)
                return
            }
        }
        
        decisionHandler(.Allow)
        
    }
    
    
    
}
