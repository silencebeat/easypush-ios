# easypush-ios
  easypush-ios is an ios basic example project to handle connection with **easypush** server. You can modify as you need depends on your requirements. 
  Please feel free if you have questions about this project

# Requirements
  1. Ios 8 and above
  2. Using swift programming language
  3. Easypush server
  4. [Alamofire](https://github.com/Alamofire/Alamofire "Alamofire") library

# How to use
  1. First you need to copy PushHelper.swift class into your project. 
  2. Initialize PushHelper class into your class
  3. Implement RequestDelegate
  4. PushHelper class require 3 parameters, **baseUrl**, **key** and **requestDelegate**. 
     **baseUrl** is your domain url that already installed easypush server, and key is a **TOKEN** from your easypush server
  
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
  
  Note: Please check the AppDelegate.swift. there are 2 modifications need
  
  ```
  /*
    Register your app for remote notification and user notification setting
  */
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool   {
        // Override point for customization after application launch.
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
  }
  /*
    Save device token into cache with key "DEVICETOKEN"
  */
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        print("devicetokenstring: \(deviceTokenString)")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(deviceTokenString, forKey: "DEVICETOKEN")
  }
  
  ```
  
# Subscribe
  Require 2 parameters, **name** and **email**. you can add **imagePath** as optional parameter
  
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
  This project is completely **free to use**. 

# Credits
  This project using [Alamofire](https://github.com/Alamofire/Alamofire "Alamofire") as the third party library to handle Http Request connection.
