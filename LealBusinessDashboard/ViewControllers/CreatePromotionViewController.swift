//
//  CreatePromotionViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/26/20.
//

import UIKit

class CreatePromotionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
	
	@IBOutlet weak var dismissButton: UIButton!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var type: UISegmentedControl!
	
	var tokens: [String]!
	
	var adn: AccountDetailsNetworking!
	var profile: ModelStructures.AccountDetails!
	var postManager: PostManager!
	
	@IBOutlet weak var endDate: UITextField!
	
	@IBOutlet weak var quantityTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var postButton: UIButton!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	
	
	var selecteDuration: String?
	var durations: [String]!
	
	var currentTextField = UITextField()
	var currentTextView = UITextView()
	var isTextView: Bool!
	
	var selectedToken: String!
	
	var datePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createDatePicker()
		
		adn = AccountDetailsNetworking()
		postManager = PostManager()
		
		profile = ModelStructures.AccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "", promotionsPostedCount: "", followersCount: "", uid: "")
		
		
		setTokens()
		setCollectionView()
		getProfileData(completion: {(status) in })
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		descriptionTextView.delegate = self
	}
	
	// MARK: UIPickerView
	
	func setView() {
		let toolbarText = UIToolbar()
		toolbarText.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		toolbarText.setItems([doneButton], animated: false)
		
		endDate.inputAccessoryView = toolbarText
		descriptionTextView.inputAccessoryView = toolbarText
		quantityTextField.inputAccessoryView = toolbarText
		
		descriptionTextView.layer.borderWidth = 1.5
		descriptionTextView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
		descriptionTextView.layer.cornerRadius = 15
		
		postButton.layer.borderColor = UIColor.link.cgColor
		postButton.layer.borderWidth = 1
		postButton.layer.cornerRadius = 10
	}
	
	func createDatePicker() {
		// Pick Date and add it to the input text field
		setView()
		datePicker = UIDatePicker()
		datePicker.date = Date()
		datePicker.locale = .current
		datePicker.datePickerMode = .dateAndTime
		datePicker.preferredDatePickerStyle = .automatic
		if #available(iOS 13.4, *) {
			datePicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
			datePicker.preferredDatePickerStyle = .wheels
			
		}
		//ToolBar
		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
		
		toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
		datePicker.sizeToFit()
		endDate.inputAccessoryView = toolbar
		endDate.inputView = datePicker
	}
	@objc func donedatePicker(){
		
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		endDate.text = form.string(from: datePicker.date)
		self.view.endEditing(true)
	}
	
	@objc func cancelDatePicker(){
		self.view.endEditing(true)
	}
	
	@objc func doneClicked() {
		view.endEditing(true)
	}
	
	
	@objc func action() {
		view.endEditing(true)
	}
	// MARK: View Logic
	
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
		
		if isTextView == true {
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
	
	@IBAction func dismissButtonPressed(_ sender: Any) {
		print("Dismiss create promotion view")
		self.dismiss(animated: true, completion: nil)
	}
	
	func setCollectionView() {
		// TODO: need to setup collection view flow layout
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 100, height: 100)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: TokenCollectionViewCell.name, bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: TokenCollectionViewCell.identifier)
		
		let discount = UINib(nibName: DiscountCollectionViewCell.name, bundle: nil)
		self.collectionView.register(discount, forCellWithReuseIdentifier: DiscountCollectionViewCell.identifier)
	}
	
	
	@IBAction func typeSelection(_ sender: Any) {
		switch type.selectedSegmentIndex
		{
			case 0:
				// Change to Discount
				tokens = []
				for percent in stride(from: 5, through: 100, by: 5) {
					let label = "\(percent)% Off"
					tokens.append(label)
				}
				descriptionLabel.text = "Description"
				quantityLabel.isHidden = false
				quantityTextField.isHidden = false
				
				durationLabel.isHidden = false
				endDate.isHidden = false
				
				
				collectionView.reloadData()
			case 1:
				tokens = ["Buy 1 Get 1 Free", "Buy 2 Get 1 Free", "Buy 3 Get 1 Free", "Buy 4 Get 1 Free"]
				descriptionLabel.text = "Description"
				quantityLabel.isHidden = false
				quantityTextField.isHidden = false
				
				durationLabel.isHidden = false
				endDate.isHidden = false
				
				collectionView.reloadData()
			case 2:
				tokens = []
				tokens.append("Profile image")
				descriptionLabel.text = "Message"
				quantityLabel.isHidden = true
				quantityTextField.isHidden = true
				
				durationLabel.isHidden = true
				endDate.isHidden = true
				
				
				collectionView.reloadData()
			default:
				tokens = []
				tokens.append("No image")
				collectionView.reloadData()
		}
	}
	
	func setTokens() {
		tokens = []
		for percent in stride(from: 5, through: 100, by: 5) {
			let label = "\(percent)% Off"
			tokens.append(label)
		}
		collectionView.reloadData()
	}
	
	func getProfileData(completion: @escaping (Bool) -> ()) {
		adn.getAccountDocument(completion: {(status, data) in
			self.profile = data
			completion(true)
		})
	}
	
	
	
	@IBAction func postButtonPressed(_ sender: Any) {
		//MAKE SURE ALL FIELDS ARE FILLED IN
		
		let error = validateFields()
		
		if error != nil {
			showError(error!)
			
		} else {
			switch type.selectedSegmentIndex {
				case 0:
					postManager.postDiscount(load: selectedToken, endDate: "\(endDate.text!)", description: descriptionTextView.text!, quantity: quantityTextField.text!)
					showMessage("Discount posted!")
				case 1:
					postManager.postBundle(load: selectedToken, endDate: "\(endDate.text!)", description: descriptionTextView.text!, quantity: quantityTextField.text!)
					showMessage("Bundle posted!")
				case 2:
					postManager.postAnnouncement(message: descriptionTextView.text!)
					showMessage("Announcement posted!")
				default:
					print("")
			}
			
		}
		
		
	}
	
	func validateFields() -> String? {
		if type.selectedSegmentIndex == 2 {
			if descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Add description" {
				return "Please write a message to post."
			}
		} else {
			if endDate.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || quantityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Add description"{
				return "Please make sure all fields are filled in"
			}
			
			if selectedToken == nil {
				return "Please select a token"
			}
		}
		
		return nil
	}
	
	func showError(_ message:String) {
		let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func showMessage(_ message: String) {
		let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.success)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
}


extension CreatePromotionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tokens.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		switch type.selectedSegmentIndex {
			case 0:
				if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountCollectionViewCell.identifier, for: indexPath) as? DiscountCollectionViewCell {
					
					let label = tokens[indexPath.item]
					
					cell.setDiscount(value: label)
					return cell
				}
			case 1:
				if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountCollectionViewCell.identifier, for: indexPath) as? DiscountCollectionViewCell {
					
					let label = tokens[indexPath.item]
					
					cell.setDiscount(value: label)
					return cell
				}
			case 2:
				if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TokenCollectionViewCell.identifier, for: indexPath) as? TokenCollectionViewCell {
					
					let label = tokens[indexPath.item]
					
					cell.updateCell(profile: profile)
					return cell
				}
			default:
				return UICollectionViewCell()
		}
		
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedToken = tokens[indexPath.item]
		
	}
}


