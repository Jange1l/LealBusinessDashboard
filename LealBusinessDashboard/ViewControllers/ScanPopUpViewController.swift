//
//  ScanPopUpViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/11/21.
//

import UIKit

class ScanPopUpViewController: UIViewController {

	
	@IBOutlet weak var customerLabel: UILabel!
	@IBOutlet weak var purchaseAmountInpuTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	var customerUid: String!
	var scannerNetworking: ScannerNetworking!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		scannerNetworking = ScannerNetworking()
		setView()
		getCustomerData()
    }
    
	func getCustomerData() {
		activity.startAnimating()
		scannerNetworking.getCustomerData(customerUid: customerUid, completion: {(status, customer) in
			self.customerLabel.text = "Customer: \(customer.customerName)"
			self.activity.stopAnimating()
			self.activity.isHidden = true
		})
	}
	func setView() {
		submitButton.layer.borderWidth = 1
		submitButton.layer.borderColor = UIColor.link.cgColor
		submitButton.layer.backgroundColor = UIColor.white.cgColor
		submitButton.layer.cornerRadius = 10
		
	}
    
	@IBAction func submitPressed(_ sender: Any) {
		
		if purchaseAmountInpuTextField.text != "" {
			scannerNetworking.giveCustomerPoints(customerUid: customerUid, points: purchaseAmountInpuTextField.text!)
		}
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.success)
		self.dismiss(animated: true, completion: nil)
	}
	
	
}
