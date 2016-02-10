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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushHelper = PushHelper(requestListener: self)
        
        pushHelper?.addParam("email", value: "youremail@company.com")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSubscribeTapped(sender: UIButton) {
        pushHelper?.subscribe("http://demo.easypush.rocks")
    }

    @IBAction func btnUnsubscribeTapped(sender: UIButton) {
        pushHelper?.unSubscribe("http://demo.easypush.rocks")
    }
    
    func onFailed(message: String, errorStatus: Int) {
        print("\(message) errorStatus: \(errorStatus)")
    }
    
    func onFinish(result: String) {
        print("\(result)")
    }
}

