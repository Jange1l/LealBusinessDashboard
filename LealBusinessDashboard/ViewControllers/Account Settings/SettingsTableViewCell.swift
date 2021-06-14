//
//  SettingsTableViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/9/21.
//

import UIKit
import Firebase
import CoreLocation

class SettingsTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var previewProfileButton: UIButton!
	@IBOutlet weak var aboutTextView: UITextView!
	@IBOutlet weak var accountTypeLabel: UILabel!
	@IBOutlet weak var saveChanges: UIButton!
	@IBOutlet weak var signOutButton: UIButton!
	
	@IBOutlet weak var currentLocationButton: UIButton!
	@IBOutlet weak var upgradeAccountButton: UIButton!
	
	
	@IBOutlet weak var businessNameTextField: UITextField!
	@IBOutlet weak var businessEmailTextField: UITextField!
	@IBOutlet weak var businessPhoneNumberTextField: UITextField!
	@IBOutlet weak var businessTypeTextField: UITextField!
	@IBOutlet weak var adressLabel: UILabel!
	
	
	
	var networking: AccountDetailsNetworking!
	
	@IBOutlet weak var logoImage: UIImageView!
	
	let storage = Storage.storage().reference()
	
	var account: AccountDetails!
	
	var currentTextField: UITextField!
	var isTextView: Bool!
	
	var loaded: ((_ value: String) -> ())?
	
	var preview: ((_ value: String) -> ())?
	
	var saveData: ((_ value: String) -> ())?
	
	var signOutPressed: ((_ value: String) -> ())?
	
	var editLocation: ((_ value: String) -> ())?
	
	var upgradeAccount: ((_ value: String) -> ())?
	
	var placeMark: CLPlacemark!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		account = AccountDetails()
		networking = AccountDetailsNetworking()
		
		setUpView()
		setUpUi()
    }

	
	@IBAction func upgradeAccountPressed(_ sender: Any) {
		upgradeAccount?("True")
	}
	
	@IBAction func editLocationPressed(_ sender: Any) {
		editLocation?("True")
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
		
		currentLocationButton.layer.borderWidth = 1
		currentLocationButton.layer.borderColor = UIColor.link.cgColor
		
	}
	
	func setUpUi() {
		
		businessNameTextField.text = account.getBusinessName()
		nameLabel.text = account.getBusinessName()
		
		businessTypeTextField.text = account.getBusinessType()
		businessEmailTextField.text = account.getBusinessEmail()
		aboutTextView.text = account.getBusinessBio()
		businessPhoneNumberTextField.text = account.getBusinessPhoneNumber()
		
		lookUpCurrentLocation(completionHandler: {(place) in })
		
		
		if account.getProfileUrl() != "No profile picture" {
			// Download image
			
			let storage = Storage.storage().reference()
			let profileImagesRef = storage.child("ProfileImages")
			let profile = profileImagesRef.child(account.getUid())
			
			// Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
			profile.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
					print("Error getting profile picture", self.account.getProfileUrl())
					self.loaded?("Done")
					
					
				} else {
					// Data for "images/island.jpg" is returned
					let image = UIImage(data: data!)
					self.logoImage.image = image
					self.loaded?("Done")
				}
			}
		} else {
			// Set default profile with no picture
			print("No found", self.account.getProfileUrl())
			
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
	
	
	func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
								-> Void ) {
		
		networking.getLocation(completion: {(status, place) in
			
			let geocoder = CLGeocoder()
			geocoder.reverseGeocodeLocation(place,
											completionHandler: { (placemarks, error) in
												if error == nil {
													let firstLocation = placemarks?[0]
													self.placeMark = firstLocation
													self.adressLabel.text = "\(self.placeMark.locality ?? ""), \(self.placeMark.subLocality ?? ""), \(self.placeMark.thoroughfare ?? ""), \(self.placeMark.postalCode ?? ""), \(self.placeMark.subThoroughfare ?? "")"
													
													completionHandler(firstLocation)
												}
												else {
													// An error occurred during geocoding.
													print("COULDNT GET LOCATION ADDRESS")
													completionHandler(nil)
												}
											})
			
		})
	}
	
	
	@objc func keyboardWillShow(notification: NSNotification) {
		print(isTextView, "Keyboard will show")
		if isTextView != true {
			if currentTextField == businessEmailTextField || currentTextField == businessNameTextField || currentTextField == businessTypeTextField ||
				currentTextField == businessPhoneNumberTextField{
				if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
					if self.window?.rootViewController?.view.frame.origin.y == 0 {
						self.window?.rootViewController?.view.frame.origin.y -= keyboardSize.height - 59
					}
				}
			}
		}
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		if self.window?.rootViewController?.view.frame.origin.y != 0 {
			self.window?.rootViewController?.view.frame.origin.y = 0
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		self.window?.rootViewController?.view.endEditing(true)
		return true
	}


	@objc func doneClicked() {
		self.window?.rootViewController?.view.endEditing(true)
	}
	
	@IBAction func changeLogoPressed(_ sender: Any) {
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		picker.allowsEditing = true
		self.window?.rootViewController?.present(picker, animated: true)
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
		self.window?.rootViewController?.dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.window?.rootViewController?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func signoutPressed(_ sender: Any) {
		
		signOutPressed?("True")
//		networking.signOut(completion: {(completed) in
//			self.window?.rootViewController?.dismiss(animated: true, completion: nil)
//			let storyboard = UIStoryboard(name: "Main", bundle: nil)
//			self.account.clearOut()
//			if let viewController = storyboard.instantiateViewController(withIdentifier: "logIn") as? InitialViewController {
//
//				// Here pass the trip id string and load the locations in the map view
//				viewController.modalTransitionStyle = .coverVertical
//				viewController.modalPresentationStyle = .fullScreen
//				self.window?.rootViewController?.present(viewController, animated: true, completion: nil)
//			}
//
//
//		})
		
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
		
		self.saveData?("Saved")
		
		
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
					AccountDetails().setProfilePUrl(profileUri: tempAccount.profileImageUrl)
					// Update user in database
					self.networking.updateAccountDetails(account: tempAccount)
					
					// Update user locally
					self.account.updateLocalAccountDetails(account: tempAccount)
					
					self.setUpUi()
					
				}
			})
			
		})
	}
	
	
	@IBAction func previewPressed(_ sender: Any) {
		preview?("Pressed")
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
