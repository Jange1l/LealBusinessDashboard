//
//  InitialViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/3/21.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

	@IBOutlet weak var signupButton: UIButton!
	@IBOutlet weak var loginButton: UIButton!
	
	override func viewDidAppear(_ animated: Bool) {
		authenticateUser()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpUi()
        
    }
    

	func setUpUi() {
		signupButton.layer.cornerRadius = 10
		
		loginButton.layer.borderWidth = 1
		loginButton.layer.borderColor = UIColor.systemPurple.cgColor
		loginButton.layer.cornerRadius = 10
	}
    

	func authenticateUser() {
		if Auth.auth().currentUser == nil {
			print("No current user")
		} else {
			let home = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
			
			self.view.window?.rootViewController = home
			self.view.window?.makeKeyAndVisible()
		}
	}
}
