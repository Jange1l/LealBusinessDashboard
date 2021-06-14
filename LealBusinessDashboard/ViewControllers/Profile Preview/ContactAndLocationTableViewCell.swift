//
//  ContactAndLocationTableViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/24/21.
//

import UIKit

class ContactAndLocationTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var phoneNumberButton: UIButton!
	@IBOutlet weak var emailButton: UIButton!
	
	@IBOutlet weak var seeOnMapButton: UIButton!
	
	var profile: ModelStructures.AccountDetails!
	var phoneNumber: String!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func updateCell(profile: ModelStructures.AccountDetails) {
		self.profile = profile
		seeOnMapButton.layer.cornerRadius = 15
		self.phoneNumber = profile.businessPhoneNumber
	}
	
	
	@IBAction func callButtonPressed(_ sender: Any) {
		print(phoneNumber)
		callNumber(phoneNumber: phoneNumber)
	}
	
	private func callNumber(phoneNumber:String) {
	  if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
		print("phone works?", phoneCallURL)
		let application:UIApplication = UIApplication.shared
		if (application.canOpenURL(phoneCallURL)) {
			application.open(phoneCallURL, options: [:], completionHandler: nil)
		}
	  }
		
	}
	
	
}
