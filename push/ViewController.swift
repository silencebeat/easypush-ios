//
//  ViewController.swift
//  push
//
//  Created by algo on 2/9/16.
//  Copyright © 2016 easypush. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ReqListener {

    var pushHelper: PushHelper?
    @IBOutlet var btnSubsribe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushHelper = PushHelper(requestListener: self)
        
        pushHelper?.addParam("email", value: "youremail@company.com")
        pushHelper?.addParam("name", value: "yourname")
        pushHelper?.addParam("image_path", value: "http://mydomain.com/my_image.jpg")
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSubscribeTapped(sender: UIButton) {
        if btnSubsribe.titleLabel?.text == "Subscribe" {
            pushHelper?.subscribe("http://192.168.1.18/pushnotification/api/user/login")
        }else {
            pushHelper?.subscribe("http://192.168.1.18/pushnotification/api/user/logout")
        }
        
    }
    
    func onFailed(message: String, errorStatus: Int) {
        print("\(message) errorStatus: \(errorStatus)")
    }
    
    func onSuccess(result: String) {
        print("\(result)")
        if btnSubsribe.titleLabel?.text == "Subscribe" {
            btnSubsribe.setTitle("Unsubscribe", forState: .Normal)
        }else {
            btnSubsribe.setTitle("Subscribe", forState: .Normal)
        }
    }
}

