//
//  ViewController.swift
//  push
//
//  Created by algo on 2/9/16.
//  Copyright © 2016 easypush. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RequestDelegate {

    var pushHelper: PushHelper?
    @IBOutlet var btnSubsribe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushHelper = PushHelper(baseUrl: "http://192.168.1.18/pushnotification", key: "3156df29bae2213d65e4b199e1a6f180ade81926", requestDelegate: self)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSubscribeTapped(sender: UIButton) {
        if btnSubsribe.titleLabel?.text == "Subscribe" {
            pushHelper?.subscribe("yourname", email: "youremail@company.com", imagePath: "")
        }else {
            pushHelper?.unSubscribe()
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

