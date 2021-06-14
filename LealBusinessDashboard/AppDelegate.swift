//
//  AppDelegate.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/25/20.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	let defaults = UserDefaults.standard
	let accountDetails = AccountDetails()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		FirebaseApp.configure()
		if accountDetails.hasUserLoggedinBefore() {
			
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let newViewController = storyBoard.instantiateViewController(withIdentifier: "logIn") as! InitialViewController
			
		}
		
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

