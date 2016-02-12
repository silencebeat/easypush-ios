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

public protocol RequestDelegate{
    func onSuccess(result: String) -> Void
    func onFailed(message: String, errorStatus: Int) -> Void
}

class PushHelper {

    private var requestDelegate: RequestDelegate?
    private var isFinish = true
    private var params = ["" : ""]
    private var headers: [String : String]?
    let defaults = NSUserDefaults.standardUserDefaults()
    var baseUrl = ""
    
    init(baseUrl: String, key: String, requestDelegate: RequestDelegate){
        self.requestDelegate = requestDelegate
        self.baseUrl = baseUrl

        self.headers = ["Authentication" : key]
        
        params = ["device" : "ios" , "device_id" : getUUID()]
    }
    
    init(baseUrl: String, key: String){
        self.baseUrl = baseUrl
        self.headers = ["Authentication" : key]
        params = ["device" : "ios" , "device_id" : getUUID()]
    }
    

    func subscribe(name: String, email: String, imagePath: String){
        var deviceToken = ""
        if let tokenString = defaults.stringForKey("DEVICETOKEN") {
            deviceToken = tokenString
        }
        
        if deviceToken == "" {
            print("has no token")
            return
        }
        
        params.updateValue(name, forKey: "name")
        params.updateValue(email, forKey: "email")
        params.updateValue(imagePath, forKey: "image_path")
        params.updateValue(deviceToken, forKey: "app_id")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(baseUrl + "/api/user/login")
        }
    }

    
    func unSubscribe(){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(self.isFinish){
            self.isFinish = false
            sendPostRequest(baseUrl + "/api/user/logout")
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
                        if self.requestDelegate != nil {
                            self.requestDelegate!.onFailed(response.result.value!, errorStatus: (response.response?.statusCode)!)
                        }
                    } else {
                        if self.requestDelegate != nil {
                            self.requestDelegate!.onSuccess(response.result.value!)
                        }
                    }
 
                    break
                case .Failure:
                    let statusCode = response.response?.statusCode
                    
                    if statusCode == 400 {
                        message = "Invalid EASYPUSH_KEY"
                    
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
                    
                    if self.requestDelegate != nil {
                        self.requestDelegate!.onFailed(message, errorStatus: statusCode!)
                    }
                    break
                }
        }
    }
    
    func getUUID() -> String {
        if let uuiString = UIDevice.currentDevice().identifierForVendor?.UUIDString {
            return uuiString
        }
        return ""
    }
    
    
}