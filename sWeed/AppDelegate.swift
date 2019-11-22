//
//  AppDelegate.swift
//  sWeed
//
//  Created by Atahan on 28/10/2019.
//  Copyright © 2019 sWeed. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDAhNcXgZZesqWnJw2jKoMgYHFPAck866E")
        //GMSPlacesClient.provideAPIKey("AIzaSyDAhNcXgZZesqWnJw2jKoMgYHFPAck866E")
        FirebaseApp.configure();
        MSAppCenter.start("6a52d6df-ef15-4d30-b7cc-e64b651ffc10", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        //SignUpViewController().CheckIfLoggedIn()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

