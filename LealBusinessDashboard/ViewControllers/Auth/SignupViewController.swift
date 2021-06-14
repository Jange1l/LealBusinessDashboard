//
//  SignupViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/3/21.
//

import UIKit
import Firebase
import CoreLocation

class SignupViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
	
	@IBOutlet weak var signUpButton: UIView!
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	
	var currentTextField: UITextField!
	var accountDetails: AccountDetails!
	var lt_program: LoyaltyProgramNetworking!
	let db = Firestore.firestore()
	let manager = CLLocationManager()
	
	var userLocation: CLLocation!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setLocationManager()
		lt_program = LoyaltyProgramNetworking()
		accountDetails = AccountDetails()
		setView()
		
	}
	
	func setLocationManager() {
		manager.delegate = self
		manager.requestAlwaysAuthorization()
		manager.startUpdatingLocation()
		manager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			print("Found user's location: \(location)")
			userLocation = location
			
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
	func setView() {
		signUpButton.layer.cornerRadius = 30
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		nameTextField.inputAccessoryView = toolbar
		emailTextField.inputAccessoryView = toolbar
		passwordTextField.inputAccessoryView = toolbar
		confirmPasswordTextField.inputAccessoryView = toolbar
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		nameTextField.delegate = self
		emailTextField.delegate = self
		passwordTextField.delegate = self
		confirmPasswordTextField.delegate = self
	}
	
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		currentTextField = textField
		return true
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		
		if currentTextField == confirmPasswordTextField || currentTextField == passwordTextField{
			if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
				if self.view.frame.origin.y == 0 {
					self.view.frame.origin.y -= keyboardSize.height - 59
				}
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func doneClicked() {
		view.endEditing(true)
	}
	func showError(_ message:String) {
		let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func validateFields() -> String? {
		// Check that all the fields are filled in
		if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
			return "Please fill in all text fields"
		}
		
		// Check that the password is valid and equal
		let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		if Utilities.isPasswordValid(trimmedPassword) == false {
			return "Please make sure your password has at least 5 characters, contains at least one special character and contains at least one number"
		}
		
		if passwordTextField.text != confirmPasswordTextField.text {
			return "Please make sure the passwords match"
		}
		
		return nil
	}
	
	func logUserIn() {
		// Create cleaned versions of the text field
		let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Signing in the user
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
			
			if error != nil {
				//                // Couldn't sign in
				//                self.errorLabel.text = error!.localizedDescription
				//                self.errorLabel.alpha = 1
				let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
					NSLog("The \"OK\" alert occured.")
				}))
				self.present(alert, animated: true, completion: nil)
			}
			else {
				print("Log In was successful")
				//Transition to other view controller
				
				let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
				
				self.view.window?.rootViewController = homeViewController
				self.view.window?.makeKeyAndVisible()
			}
		}
	}
	
	
	@IBAction func signupButtonPressed(_ sender: Any) {
		// Validate all fields
		let error = validateFields()
		
		if error != nil {
			showError(error!)
		} else {
			
			let businessName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
			let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			
			// Create the user
			Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
				
				// Check for errors
				if err != nil {
					
					// There was an error creating the user
					self.showError("Error creating user")
				}
				else {
					
					// User was created successfully, now store the first name and last name
					
					let userRef = self.db.collection("BusinessUsers").document(result!.user.uid)
					userRef.setData([
						LealConstants.f_bName: businessName!,
						LealConstants.f_bEmail: email,
						LealConstants.f_bUsername: "\(result!.user.uid)_\(businessName!)",
						LealConstants.f_bUid: Auth.auth().currentUser!.uid as String,
						LealConstants.f_bPhoneNumber: "",
						LealConstants.f_bBusinessType: "",
						LealConstants.f_bProfileImageURL: "",
						LealConstants.f_bBusinessBio: "",
						LealConstants.f_bPromotionsPostedCount: "0",
						LealConstants.f_bFollowersCount: "0"
					]) { err in
						if let err = err {
							print("Error writing document: \(err)")
						} else {
							print("Document successfully written!")
							
							
							// Save all Account data locally
							
							self.accountDetails.setBusinessName(name: businessName!)
							self.accountDetails.setBusinessEmail(email: email)
							self.accountDetails.setUid(uid: Auth.auth().currentUser!.uid as String)
							if self.userLocation != nil {
								self.setLocation(l: self.userLocation)
							}
							self.setBaseTools()
							
							
						}
					}
					
					
					
					// Transition to the home screen
					self.logUserIn()
				}
				
				
			}
		}
	}
	
	func setLocation(l: CLLocation) {
		print("Business location set")
		db.collection("Locations").document(accountDetails.getUid()).setData([
														"Name": accountDetails.getBusinessName(),
														"Uid": accountDetails.getUid(),
														"Lat": "\(l.coordinate.latitude)",
														"Long": "\(l.coordinate.longitude)"
		])
	}
	
	
	func setBaseTools()  {
		
		// Manage Loyalty Program feature initialized in database
		
		lt_program.initializeBlank()
		
		
		// Create Promotion feature initialized in database
		LealConstants.BusinessToolsRef.document(LealConstants.CreatePromotion).setData([
			LealConstants.toolName: LealConstants.tn_createPromotion,
			LealConstants.viewIdentifier: LealConstants.ti_createPromotion,
			LealConstants.logoName: "create_icon",
			LealConstants.backgroundColor: ""
		])
		
		LealConstants.BusinessToolsRef.document("LivePromotions").setData([
			LealConstants.toolName: "Posted Promos",
			LealConstants.viewIdentifier: "PostedPromos",
			LealConstants.logoName: "active",
			LealConstants.backgroundColor: ""
			
		])
		
	}
}
