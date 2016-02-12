# easypush-ios
  easypush-ios is an ios example project to handle connection with easypush server. Please feel free if you have question about this project

# Requirements
  1. Ios 8 and above
  2. Written by swift programming language

# How to use
  1. First you need to copy PushHelper.swift class into your project. 
  2. Initialize PushHelper class into your class
  3. Implement RequestDelegate
  4. PushHelper class require 3 parameters, "baseUrl", "key" and "requestDelegate"
     baseUrl is your domain url that already installed easypush server, and key is a TOKEN from your easypush server
  
  Example : 
  ```
  import UIKit

class ViewController: UIViewController, RequestDelegate {

    var pushHelper: PushHelper?
    @IBOutlet var btnSubsribe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushHelper = PushHelper(baseUrl: "http://192.168.1.18/pushnotification", key: "3156df29bae2213d65e4b199e1a6f180ade81926", requestDelegate: self)
   
    }
  ...
}
  ```
  
  note:
  

# Subscribe
  Require 2 parameters, name and email. you can add imagePath as optional parameter
  
  ```
  pushHelper?.subscribe("yourname", email: "youremail@company.com")
  ```
  or
  ```
  pushHelper?.subscribe("yourname", email: "youremail@company.com", imagePath: "")
  ```

# Unsubscribe
  This is the simple way to unsubscribe push notification from your easypush server
  ```
  pushHelper?.unSubscribe()
  ```

  Full Code (you can check it inside this git project) :
  ```
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
  ```

# License
  This project is completely free to use. 

# Credits
  This project using [Alamofire](https://github.com/Alamofire/Alamofire "Alamofire") as the third party library to handle Http Request connection.
