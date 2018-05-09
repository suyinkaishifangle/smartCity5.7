//
//  AppDelegate.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: BOUNDS)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        observeInternet()
        
        return true
    }
    /**
     observeInternet 网络监控
     */
    func observeInternet(){
        let reachability = AFNetworkReachabilityManager.shared()
        reachability.setReachabilityStatusChange { (status) in
            // 当网络状态改变了, 就会调用这个block
            switch status{
            case .unknown:
                debugPrint("未知网络")
                
            case .reachableViaWiFi,.reachableViaWWAN:
                debugPrint("WIFi")
            case .notReachable:
                let alert = UIAlertView.init(title: "温馨提示", message: "当前网络不通畅，请检查您的网络设置", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        }
        reachability.startMonitoring()
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


}

