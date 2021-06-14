//
//  AccountSettingsViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/4/21.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var previewProfileButton: UIButton!
	@IBOutlet weak var aboutTextView: UITextView!
	@IBOutlet weak var accountTypeLabel: UILabel!
	@IBOutlet weak var saveChanges: UIButton!
	@IBOutlet weak var signOutButton: UIButton!
	
	
	@IBOutlet weak var businessNameTextField: UITextField!
	@IBOutlet weak var businessEmailTextField: UITextField!
	@IBOutlet weak var businessPhoneNumberTextField: UITextField!
	@IBOutlet weak var businessTypeTextField: UITextField!
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	var networking: AccountDetailsNetworking!
	
	@IBOutlet weak var logoImage: UIImageView!
	
	let storage = Storage.storage().reference()
	
	var account: AccountDetails!
	
	var currentTextField: UITextField!
	var isTextView: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		account = AccountDetails()
		networking = AccountDetailsNetworking()
		
		setUpView()
		setUpUi()
		
	}
	
	
	
	func setUpView() {
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		businessEmailTextField.inputAccessoryView = toolbar
		businessNameTextField.inputAccessoryView = toolbar
		businessPhoneNumberTextField.inputAccessoryView = toolbar
		businessTypeTextField.inputAccessoryView = toolbar
		aboutTextView.inputAccessoryView = toolbar
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		isTextView = false
		
		businessNameTextField.delegate = self
		businessEmailTextField.delegate = self
		businessPhoneNumberTextField.delegate = self
		businessTypeTextField.delegate = self
		aboutTextView.delegate = self
		
		
		previewProfileButton.layer.borderWidth = 1
		previewProfileButton.layer.borderColor = UIColor.link.cgColor
		aboutTextView.layer.borderWidth = 1
		aboutTextView.layer.borderColor = UIColor.systemGray.cgColor
		aboutTextView.layer.cornerRadius = 10
		accountTypeLabel.layer.borderWidth = 1
		accountTypeLabel.layer.borderColor = UIColor.systemGray.cgColor
		logoImage.layer.cornerRadius = 75
		
		saveChanges.layer.borderWidth = 1
		saveChanges.layer.borderColor = UIColor.link.cgColor
		
		signOutButton.layer.borderWidth = 1
		signOutButton.layer.borderColor = UIColor.systemRed.cgColor
		
	}
	
	func setUpUi() {
		
		businessNameTextField.text = account.getBusinessName()
		nameLabel.text = account.getBusinessName()
		
		businessTypeTextField.text = account.getBusinessType()
		businessEmailTextField.text = account.getBusinessEmail()
		aboutTextView.text = account.getBusinessBio()
		businessPhoneNumberTextField.text = account.getBusinessPhoneNumber()
		
		
		activity.startAnimating()
		if account.getProfileUrl() != "No profile picture" {
			// Download image
			
			let storage = Storage.storage().reference()
			let profileImagesRef = storage.child("ProfileImages")
			let profile = profileImagesRef.child(account.getUid())
			
			// Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
			profile.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
					print("Error etting profile picture", self.account.getProfileUrl())
					self.activity.stopAnimating()
					self.activity.isHidden = true
				} else {
					// Data for "images/island.jpg" is returned
					let image = UIImage(data: data!)
					self.logoImage.image = image
					self.activity.stopAnimating()
					self.activity.isHidden = true
				}
			}
		} else {
			// Set default profile with no picture
			print("No found", self.account.getProfileUrl())
			self.activity.stopAnimating()
			self.activity.isHidden = true
		}
		
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		isTextView = false
		currentTextField = textField
		return true
	}
	
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		isTextView = true
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		isTextView = true
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		isTextView = false
		
	}
	
	
	
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		print(isTextView, "Keyboard will show")
		if isTextView != true {
			if currentTextField == businessEmailTextField || currentTextField == businessNameTextField || currentTextField == businessTypeTextField ||
				currentTextField == businessPhoneNumberTextField{
				if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
					if self.view.frame.origin.y == 0 {
						self.view.frame.origin.y -= keyboardSize.height - 59
					}
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
		self.view.endEditing(true)
		return true
	}
	
	
	@objc func doneClicked() {
		view.endEditing(true)
	}
	
	@IBAction func changeLogoPressed(_ sender: Any) {
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let possibleImage = info[.editedImage] as? UIImage {
			logoImage.image = possibleImage
			print("EDITED IMAGE")
		} else if let possibleImage = info[.originalImage] as? UIImage {
			logoImage.image = possibleImage
			print("ORIGINAL IMAGE")
		} else {
			return
		}
		
		
		// do something interesting here
		dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func signoutPressed(_ sender: Any) {
		
		networking.signOut(completion: {(completed) in
			self.dismiss(animated: true, completion: nil)
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			self.account.clearOut()
			if let viewController = storyboard.instantiateViewController(withIdentifier: "logIn") as? InitialViewController {
				
				// Here pass the trip id string and load the locations in the map view
				viewController.modalTransitionStyle = .coverVertical
				viewController.modalPresentationStyle = .fullScreen
				self.present(viewController, animated: true, completion: nil)
			}
			
			
		})
		
	}
	
	
	
	@IBAction func saveChangesPressed(_ sender: Any) {
		
		// Create storage reference
		// Save picture to Storage
		// Get picture download URI
		// Save download URI along with other valuable infromation to firestore
		
		guard let imageData = logoImage.image?.jpegData(compressionQuality: 0.5) else {
			return
		}
		let storage = Storage.storage().reference()
		let profileImagesRef = storage.child("ProfileImages")
		let profile = profileImagesRef.child(account.getUid())
		
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpg"
		
		profile.putData(imageData, metadata: metaData, completion: {(storageMetaData, error) in
			if error != nil {
				print(error?.localizedDescription)
				return
			}
			
			profile.downloadURL(completion: {(url, error) in
				if let metaImgeUrl = url?.absoluteString {
					
					print(metaImgeUrl)
					
					var tempAccount = self.account.getAccount()
					
					if self.logoImage.image != nil {
						tempAccount.profileImageUrl = metaImgeUrl
					}
					
					tempAccount = self.validateFields(act: tempAccount)
					
					print("ACCOUNT AFTER VALIDATED FIELDS ->",tempAccount)
					
					// Update user in database
					self.networking.updateAccountDetails(account: tempAccount)
					
					// Update user locally
					self.account.updateLocalAccountDetails(account: tempAccount)
					
					self.setUpUi()
				}
			})
			
		})
	}
	// CONSIDER JUST RE-DOWNLOADING A FRESH PROFILE COPY INSTEAD OF CHECKING FOR DIFFERENCES
	func validateFields(act: ModelStructures.AccountDetails) -> ModelStructures.AccountDetails {
		
		var tempAccount = act
		print("This account is being validated -> ",tempAccount)
		
		if businessNameTextField.text! != "" && account.getBusinessName() != businessNameTextField.text! {
			print("Changing business name from ", account.getBusinessName(), "to ", businessNameTextField.text!)
			tempAccount.businessName = businessNameTextField.text!
		}
		if businessEmailTextField.text! != "" && account.getBusinessEmail() != businessEmailTextField.text! {
			tempAccount.businessEmail = businessEmailTextField.text!
		}
		if businessPhoneNumberTextField.text! != "" && account.getBusinessPhoneNumber() != businessPhoneNumberTextField.text! {
			tempAccount.businessPhoneNumber = businessPhoneNumberTextField.text!
		}
		if businessTypeTextField.text! != "" && account.getBusinessType() != businessTypeTextField.text! {
			tempAccount.businessType = businessTypeTextField.text!
		}
		if aboutTextView.text! != "" && account.getBusinessBio() != aboutTextView.text! {
			tempAccount.businessBio = aboutTextView.text!
		}
		
		return tempAccount
	}
	
}

