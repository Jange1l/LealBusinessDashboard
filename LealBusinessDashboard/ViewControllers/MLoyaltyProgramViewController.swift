//
//  MLoyaltyProgramViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/26/20.
//

import UIKit

class MLoyaltyProgramViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var stepsCollectionView: UICollectionView!
	@IBOutlet weak var numberOfStepsLabel: UILabel!
	@IBOutlet weak var pointsPerStepInput: UITextField!
	
	@IBOutlet weak var pointsCircle: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var numberOfSteps: Int!
	var lp: LoyaltyProgramManager!
	var referenceLp: LoyaltyProgramManager!
	
	var selectedStep: ModelStructures.LPStep!
	var currentTextField: UITextField!
	
	@IBOutlet weak var levelOfLabel: UILabel!
	@IBOutlet weak var pointsValLabel: UILabel!
	
	
	@IBOutlet weak var changeBackgroundButton: UIButton!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		lp = LoyaltyProgramManager()
		referenceLp = LoyaltyProgramManager()
		setView()
		setUpCollectionView()
		getCurrentLoyaltyProgram()
    }
	
	// MARK: View Logic
	
	
	@IBAction func changeBackgroundPressed(_ sender: Any) {
		
	}
	func setUpCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 100, height: 100)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		
		self.stepsCollectionView.collectionViewLayout = flowLayout
		self.stepsCollectionView.showsVerticalScrollIndicator = true
		let cellNib = UINib(nibName: "StepCollectionViewCell", bundle: nil)
		self.stepsCollectionView.register(cellNib, forCellWithReuseIdentifier: "stepCell")
		
		changeBackgroundButton.layer.borderWidth = 1
		changeBackgroundButton.layer.borderColor = UIColor.link.cgColor
	}
	
	func setView() {
		pointsCircle.layer.cornerRadius = 50
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		pointsPerStepInput.inputAccessoryView = toolbar
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		pointsPerStepInput.delegate = self
	}
	@objc func doneClicked() {
		view.endEditing(true)
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		currentTextField = textField
		return true
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		
		if currentTextField == pointsPerStepInput{
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
	
	// MARK: Business Logic
	
	func getCurrentLoyaltyProgram() {
		activityIndicator.startAnimating()
		lp.getCurrentLoyaltyProgram(completion: {(completed, program) in
			
			// set all fields for the loyalty program
			self.lp.lp = program.lp
			self.referenceLp = program.copy() as! LoyaltyProgramManager
			
			self.numberOfStepsLabel.text = String(program.lp.numberOfSteps!)
			self.numberOfSteps = Int(program.lp.numberOfSteps!)
			self.pointsPerStepInput.text = program.lp.pointsPerStep!
			self.levelOfLabel.text = "Level 1 of \(self.numberOfSteps!)"
			self.pointsValLabel.text = String(program.lp.pointsPerStep)
			
			self.stepsCollectionView.reloadData()
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
		})
		
	}
	
	func showError(_ message:String) {
		let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func showWarning(_ message:String) {
		let alert = UIAlertController(title: "Wait!", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			self.saveButtonPressed(self)
		}))
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
			
			
		}))
		self.present(alert, animated: true, completion: nil)
	}
    
	@IBAction func backButtonPressed(_ sender: Any) {
		lp.lp.numberOfSteps = numberOfStepsLabel.text!
		lp.lp.pointsPerStep = pointsPerStepInput.text!
		
		if lp.lp.steps != referenceLp.lp.steps {
			showWarning("Changes were made, do you want to save?")
		} else {
			self.dismiss(animated: true, completion: nil)
		}
		
	}
	
	func addStep(stepNumber: Int) {
		let step = ModelStructures.LPStep(stepNumber: "\(stepNumber)", requiredPoints: pointsPerStepInput.text, rewardName: "", rewardDescription: "")
		lp.lp.steps.append(step)
		levelOfLabel.text = "Level 1 of \(numberOfSteps!)"
		stepsCollectionView.reloadData()
	}
	
	func removeStep() {
		lp.lp.steps.popLast()
		levelOfLabel.text = "Level 1 of \(numberOfSteps!)"
		stepsCollectionView.reloadData()
	}
	
	@IBAction func decreaseSteps(_ sender: Any) {
		if numberOfSteps > 1 {
			let message  = "Are you sure you want  to remove step \(numberOfSteps!)?"
			
			let alert = UIAlertController(title: "Wait!", message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
				NSLog("The \"OK\" alert occured.")
				self.numberOfSteps -= 1
				self.numberOfStepsLabel.text = String(self.numberOfSteps)
				self.removeStep()
			}))
			
			alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
				
			}))
			
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	@IBAction func increaseSteps(_ sender: Any) {
		if numberOfSteps < 10 {
			numberOfSteps += 1
			numberOfStepsLabel.text = String(numberOfSteps)
			addStep(stepNumber: numberOfSteps)
		}
	}
	
	// MARK: Save Button
	
	@IBAction func saveButtonPressed(_ sender: Any) {
		
		lp.lp.numberOfSteps = numberOfStepsLabel.text!
		lp.lp.pointsPerStep = pointsPerStepInput.text!
		
		
		lp.updateLoyaltyProgram(lp: lp.lp, ref: referenceLp.lp)
		
		referenceLp.lp = lp.lp
		// show alert that loyalty program has been published
		let message  = "Your loyalty program has been published!"
		
		let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			let generator = UINotificationFeedbackGenerator()
			generator.notificationOccurred(.success)
		}))
	
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: Segues
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let viewController = segue.destination as? StepDetailViewController {
			viewController.lp = lp
			viewController.step = selectedStep
			viewController.stepsArray = lp.lp.steps
		}
	}
	
	@IBAction func unwindFromStepDetail(_ sender: UIStoryboardSegue) {
		if sender.source is StepDetailViewController {
			if let senderVc = sender.source as? StepDetailViewController {
				
				let editedSteps = senderVc.lp
				lp = editedSteps!
				//print(lp.lp.steps)
				
			}
			stepsCollectionView.reloadData()
		}
	}
	
}

extension MLoyaltyProgramViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return lp.lp.steps.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stepCell", for: indexPath) as? StepCollectionViewCell {
			
			
			cell.cellName.text = "Step \(lp.lp.steps[indexPath.item].stepNumber!)"
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let stepDetail = lp.lp.steps[indexPath.item]
		selectedStep = stepDetail
		currentTextField = nil
		performSegue(withIdentifier: "stepDetail", sender: nil)
	}
	
	//Add spaces at the beginning and the end of the collection view
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
	   return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
   }
	
}
 
