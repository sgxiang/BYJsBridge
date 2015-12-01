# BYJsBridge
swift版iOS网页的js交互

## 支持 

* iOS8+
* swift2+

## 使用

导入class目录下的BYWeb开头的文件到项目，将html目录下的文件放入服务器中。

* 修改`BYJSBridge.js`文件的`BYLoadMethod`方法自定义url scheme和url hostName
* 修改`BYJSBridge.js`文件的`bindEvent`方法绑定交互方法

```js
//绑定`test`方法，返回给客户端`message`
$("#test").bind("click", function(){
	BYLoadMethod("test", {"message":"hello html."},{
		success:function(data){
    		console.log(data)
    	},
    	fail:function(data){
        	console.log(data)
        },
        progress:function(data){
        	console.log(data)
		}
	});
});
```

* 修改`BYWebConfiguration.swift`文件自定义url scheme和url hostName
* 修改`BYWebResponder.swift`文件定义交互行为

```swift
class BYWebResponder: NSObject,BYWebJSBridgeNativeResponderProtocol {
	//监听test方法
    static func bindMethod() -> String {
        return "test"
    }
    //执行的行为
    func performActionWithParams(params: Dictionary<String, AnyObject>?, callbackHandler: BYWebJSBridgeCallbackHandler) {
        if params == nil{ return }
        guard let message = params!["message"] as? String else{
            return
        }
        print(message)
	    callbackHandler.successWithResultDictionary(["success":"success"])
    }
}
```

* 初始化webView设置代理和注册配置和方法

```swift
webView.UIDelegate = webDelegate
webView.navigationDelegate = webDelegate
webDelegate.registeConfigurationClass(configuration)
webDelegate.registeNativeResponderClass(BYTestResponder.self)
webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://localhost/html/test.html")!))
```