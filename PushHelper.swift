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
    func onFinish(result: String) -> Void
    func onFailed(message: String, errorStatus: Int) -> Void
}

class PushHelper {

    private var requestListener: ReqListener?
    private var device = "ios"
    private var isFinish = true
    private var params: [String : AnyObject]?
    private let DEVICE_ID = "deviceId"
    private let APP_ID = "appId"
    private let DEVICE = "device"
    private var headers: [String : String]?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init(requestListener: ReqListener){
        self.requestListener = requestListener
        
        if APIQUE_KEY == "" {
            print("please add APIQUE_KEY value in info.plist")
        }
        self.headers = ["Authentication" : APIQUE_KEY]
        
        var deviceToken = ""
        if let tokenString = defaults.stringForKey("DEVICETOKEN") {
            deviceToken = tokenString
        }
        
        params = [DEVICE: device , APP_ID : deviceToken, DEVICE_ID: getUUID()]
    }
    
    func addParam (key: String, value: String) {
        self.params?.updateValue(value, forKey: key)
        
    }
    
    func subscribe(URL: String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(URL)
        }
    }

    
    func unSubscribe(URL: String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(URL)
        }
    }
    
    private func sendPostRequest(URL: String){
        
        Alamofire.request(.POST, URL, parameters: params, encoding: .JSON, headers: headers)
            .responseString { response in
                self.isFinish = true
                var message = ""
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                
                switch response.result {
                case .Success:
                    if response.response?.statusCode == 500 {
                        if self.requestListener != nil {
                            self.requestListener!.onFailed("Server error", errorStatus: (response.response?.statusCode)!)
                        }
                    } else {
                        if self.requestListener != nil {
                            print("\(response.response?.statusCode)")
                            self.requestListener!.onFinish(response.result.value!)
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
                        message = "Server error"
                    
                    } else {
                        message = (response.result.error?.description)!
                    }
                    
                    print("\(statusCode)")
                    
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