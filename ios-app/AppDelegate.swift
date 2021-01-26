//
//  AppDelegate.swift
//  ios-app
//
//  Created by Duckie N on 1/25/21.
//

import UIKit
import AppLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let loginController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController")
         self.window?.rootViewController = loginController
         self.window?.makeKeyAndVisible()
         return true
    }
}

