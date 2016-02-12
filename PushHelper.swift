//
//  PushHelper.swift
//  CandraLagiIseng
//
//  Created by algo on 1/14/16.
//  Copyright © 2016 apiquestudio. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public protocol ReqListener {
    func onSuccess(result: String) -> Void
    func onFailed(message: String, errorStatus: Int) -> Void
}

class PushHelper {

    private var requestListener: ReqListener?
    private var isFinish = true
    private var params = ["" : ""]
    private var headers: [String : String]?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init(requestListener: ReqListener){
        self.requestListener = requestListener
        
        if APIQUE_KEY == "" {
            print("please add APIQUE_KEY value in info.plist")
        }
        self.headers = ["Authentication" : APIQUE_KEY]
        
        params = ["device" : "ios" , "device_id" : getUUID()]
    }
    
    func addParam (key: String, value: String) {
        self.params.updateValue(value, forKey: key)
    }
    
    func subscribe(URL: String){
        var deviceToken = ""
        if let tokenString = defaults.stringForKey("DEVICETOKEN") {
            deviceToken = tokenString
        }
        
        if deviceToken == "" {
            print("has no token")
            return
        }
        
        self.params.updateValue(deviceToken, forKey: "app_id")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(URL)
        }
    }

    
    func unSubscribe(URL: String){
        var deviceToken = ""
        if let tokenString = defaults.stringForKey("DEVICETOKEN") {
            deviceToken = tokenString
        }
        
        if deviceToken == "" {
            print("has no token")
            return
        }
        
        self.params.updateValue(deviceToken, forKey: "app_id")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(URL)
        }
    }
    
    private func sendPostRequest(URL: String){
        
        Alamofire.request(.POST, URL, parameters: self.params, encoding: .URL, headers: headers)
            .responseString { response in
                self.isFinish = true
                var message = ""
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                switch response.result {
                case .Success:
                    if response.response?.statusCode == 500 {
                        if self.requestListener != nil {
                            self.requestListener!.onFailed(response.result.value!, errorStatus: (response.response?.statusCode)!)
                        }
                    } else {
                        if self.requestListener != nil {
                            self.requestListener!.onSuccess(response.result.value!)
                        }
                    }
 
                    break
                case .Failure:
                    let statusCode = response.response?.statusCode
                    
                    if statusCode == 400 {
                        message = "Invalid APIQUE_KEY"
                    
                    } else if statusCode == 401 {
                        message = "You need valid credentials for me to respond to this request"
                    
                    } else if statusCode == 403 {
                        message = "I understood your credentials, but sorry you're not allowed"
                    
                    } else if statusCode == 404 {
                        message = "Resource error"
                    
                    } else if statusCode == 500 {
                        message = "Internal Server Error"
                    
                    } else {
                        message = (response.result.error?.description)!
                    }
                    
                    if self.requestListener != nil {
                        self.requestListener!.onFailed(message, errorStatus: statusCode!)
                    }
                    break
                }
        }
    }
    
    private var APIQUE_KEY: String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        if dict?.objectForKey("APIQUE_KEY") == nil {
            return ""
        }
        
        let test: AnyObject = dict!.objectForKey("APIQUE_KEY")!
        
        return test as! String
    }
    
    func getUUID() -> String {
        if let uuiString = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            return uuiString
        }
        return ""
    }
    
    
}