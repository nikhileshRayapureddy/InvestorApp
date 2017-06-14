//
//  AppDelegate.swift
//  InvestorApp
//
//  Created by NIKHILESH on 14/06/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:- Loader  methods
    func showLoader(message:String)
    {
        
        
        self.performSelector(onMainThread: #selector(showLoaderr(message:)), with: message, waitUntilDone: false)
        
    }
    
    func showLoaderr(message : String)
    {
        let vwBgg = self.window!.viewWithTag(123453)
        if vwBgg == nil
        {
            let vwBg = UIView( frame:self.window!.frame)
            vwBg.backgroundColor = UIColor.clear
            vwBg.tag = 123453
            self.window!.addSubview(vwBg)
            
            let imgVw = UIImageView (frame: vwBg.frame)
            imgVw.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            vwBg.addSubview(imgVw)
            
            let height = vwBg.frame.size.height/2.0
            
            let lblText = UILabel(frame:CGRect(x: 0, y: height-60, width: vwBg.frame.size.width, height: 30))
            lblText.font = UIFont(name: "OpenSans", size: 17)
            
            if message == ""
            {
                lblText.text =  "Loading ..."
            }
            else
            {
                lblText.text = message
            }
            lblText.textAlignment = NSTextAlignment.center
            lblText.backgroundColor = UIColor.clear
            lblText.textColor =   UIColor.white// Color_AppGreen
            // lblText.textColor = Color_NavBarTint
            vwBg.addSubview(lblText)
            
            
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
            indicator.center = vwBg.center
            vwBg.addSubview(indicator)
            indicator.startAnimating()
            
            vwBg.addSubview(indicator)
            indicator.bringSubview(toFront: vwBg)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    }
    func removeloder()
    {
        self.performSelector(onMainThread:#selector(removeloderr), with: nil, waitUntilDone: false)
    }
    func removeloderr()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let vwBg = self.window!.viewWithTag(123453)
        if vwBg != nil
        {
            vwBg!.removeFromSuperview()
        }
        
    }

}

