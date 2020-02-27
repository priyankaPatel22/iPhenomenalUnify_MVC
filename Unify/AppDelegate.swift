//
//  AppDelegate.swift
//  Unify
//
//  Created by Priyanka Patel  on 8/15/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var navgController: UINavigationController?
    //Get AppDelegate shared Instance
    static let sharedInstance = UIApplication.shared.delegate as! AppDelegate
    
    //reachability - Used for checking Network reachability
    
    let reachability = try! Reachability()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //________ Set IQKeyboard Settings __________//
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        //________ Network Reachability instance variable assign __________//
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        //________ Start View Controllers __________//
        let account: Account? = AccountManager.Instance.activeAccount
        if account != nil {
            redirectDashboard()
        }else{
            //Load LoginController - No user is counrty logged in
            redirectLogin()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    // MARK: - Network reachability notification
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        case .unavailable:
            print("Network unavailable")
        }
    }
    
    func isReachable() -> Bool {
        return reachability.connection != .none
    }

    // MARK: -
    func redirectLogin() {
        let controller:LoginController = LoginController.initViewController()
        navgController = UINavigationController(rootViewController: controller)
        navgController?.isNavigationBarHidden = true
        
        window?.rootViewController = navgController
        window?.makeKeyAndVisible()
    }
    func redirectDashboard() {
        let controller = QuestionsController.initViewController()
        let objNav = NavigationViewController.initViewController()
        objNav.viewControllers = [controller]
        let sideMenu = SideMenuController.initViewController()
        
        // Configure MMDrawerController Controller
        let mmdrawerController = MMDrawerController(center: objNav, leftDrawerViewController: sideMenu, rightDrawerViewController: nil)
        mmdrawerController?.maximumRightDrawerWidth = 250
        mmdrawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.all
        //mmdrawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone
        mmdrawerController?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
        
        // var block //= MMDrawerControllerDrawerVisualStateBlock()
        
        mmdrawerController?.setDrawerVisualStateBlock({ (_ drawerController: MMDrawerController?, _ drawerSide: MMDrawerSide, _ percentVisible: CGFloat) in
            let block = MMExampleDrawerVisualStateManager.shared().drawerVisualStateBlock(for: drawerSide)
            if (block != nil) {
                block!(drawerController, drawerSide, percentVisible)
            }
        })
        
        navgController = UINavigationController(rootViewController: mmdrawerController!)
        // self.navgController.navigationBar.tintColor = [UIColor colorWithHexString:kYELLOW_COLOR];
        navgController?.isNavigationBarHidden = true
        window?.rootViewController = navgController
        window?.makeKeyAndVisible()
    }
    func logout() {
        AccountManager.Instance.activeAccount = nil
        
        self.redirectLogin()
       
    }
}



