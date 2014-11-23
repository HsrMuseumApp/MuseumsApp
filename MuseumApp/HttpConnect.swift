import Foundation


class HttpConnect {
    
    func JSONParse(data:NSData) -> AnyObject {
        var jsonErrorOptional: NSError?
        let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
        return jsonObject
    }
    
   
    func HTTPGet(urlString: String) -> AnyObject {
        let url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        //var reply = NSString(data: data!, encoding: NSUTF8StringEncoding
        return JSONParse(data!)
    }
    
}
