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
       
        return JSONParse(data!)
        
    }
    
    func HTTPPost(urlString: String, parameters: String) -> AnyObject {
        let url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"

        var bodyData = (parameters as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        var requestBodyData: NSData = bodyData!
        
        request.HTTPBody = requestBodyData
        
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        
        return JSONParse(data!)
    }
    
}
