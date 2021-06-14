//
//  StepDetailViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/7/21.
//

import UIKit

class StepDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
	
	@IBOutlet weak var stepNumber: UILabel!
	@IBOutlet weak var rewardName: UITextField!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var rewardDescription: UITextView!
	
	@IBOutlet weak var descriptionTextView: UITextView!
	
	@IBOutlet weak var rewardNameTextField: UITextField!
	
	var step: ModelStructures.LPStep!
	var stepsArray: [ModelStructures.LPStep]!
	var lp: LoyaltyProgramManager!
	
	var currentTextField: UITextField!
	var currentTextView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		rewardNameTextField.delegate = self
		setData()
		setView()
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// IF USER HASNT SAVED PRESENT ALERT TO SAVE WORK BEFORE DISPATHCING
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		step.rewardName = rewardName.text
		step.rewardDescription = rewardDescription.text
		step.value = valueTextField.text
		
		let index = lp.lp.steps.firstIndex(where: {$0.stepNumber == step!.stepNumber})
		lp.lp.steps[index!] = step
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let maxLength = 14
		let currentString: NSString = (rewardNameTextField.text ?? "") as NSString
		let newString: NSString =
			currentString.replacingCharacters(in: range, with: string) as NSString
		return newString.length <= maxLength
	}
	func setView() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		descriptionTextView.layer.borderWidth = 0.5
		descriptionTextView.layer.borderColor = UIColor.systemGray.cgColor
		descriptionTextView.layer.cornerRadius = 10
		
		descriptionTextView.delegate = self
		
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		descriptionTextView.inputAccessoryView = toolbar
		rewardName.inputAccessoryView = toolbar
		valueTextField.inputAccessoryView = toolbar
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		currentTextView = textView
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		currentTextView = textView
		return true
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		currentTextField = textField
		return true
	}
	func textViewDidEndEditing(_ textView: UITextView) {
		currentTextView = nil 

	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		
		if currentTextView == descriptionTextView {
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
	
	func setData() {
		stepNumber.text = "Step \(step.stepNumber!)"
		rewardName.text = step.rewardName
		rewardDescription.text = step.rewardDescription
		valueTextField.text = step.value
	}
	
	
	@IBAction func cancelButtonPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	
	@IBAction func saveStep(_ sender: Any) {
		
		
	}
	
}
