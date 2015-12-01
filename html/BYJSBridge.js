
window.BYCallBackList = {};
String.prototype.BYhashCode = function() {
    var hash = 0;
    if (this.length == 0) return hash;
    for (var index = 0; index < this.length; index++) {
        var charactor = this.charCodeAt(index);
        hash = ((hash<<5)-hash)+charactor;
        hash = hash & hash;
    }
    return hash;
};

function BYLoadMethod(methodName, data, callback) {
    dataString = JSON.stringify(data);
    identifier = (methodName+dataString).BYhashCode().toString();
    window.BYCallBackList[identifier] = callback;

    url = "byjs://appApi?callbackIdentifier="+identifier+"&data="+dataString+"&methodName="+methodName;
    window.location = url;
}

window.BYCallback = function(identifier, resultStatus, resultData) {

    callBackDict = window.BYCallBackList[identifier];

    if (callBackDict) {

        isFinished = true;
        if (resultStatus == "success") {
            callBackDict.success(resultData);
        }
        if (resultStatus == "fail") {
            callBackDict.fail(resultData);
        }
        if (resultStatus == "progress") {
            isFinished = false;
            callBackDict.progress(resultData);
        }

        if (isFinished) {
            window.BYCallBackList[identifier] = null;
            delete window.BYCallBackList[identifier];
        }
    }
}


$(document).ready(function(){
    bindEvent();
});

function bindEvent() {
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
    

}


