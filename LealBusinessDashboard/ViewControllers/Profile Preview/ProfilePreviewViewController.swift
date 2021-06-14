//
//  ProfilePreviewViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/17/21.
//

import UIKit
import CoreLocation

class ProfilePreviewViewController: UIViewController {
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	@IBOutlet weak var profileViewStructureTV: UITableView!
	
	var sections: Int!
	var loyaltyProgram: LoyaltyProgramManager!
	
	var adn: AccountDetailsNetworking!
	var profile: ModelStructures.AccountDetails!
	
	let locationManager = CLLocationManager()
	var placeMark: CLPlacemark!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		adn = AccountDetailsNetworking()
		profile = ModelStructures.AccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "", promotionsPostedCount: "", followersCount: "", uid: "")
		loyaltyProgram = LoyaltyProgramManager()
		
		setNibs()
		getData()
		
		
	}
	func getData() {
		activity.startAnimating()
		getProfileData(completion: {(status) in
			
			self.getLoyaltyProgramData(completion: {(status) in
				
				self.lookUpCurrentLocation(completionHandler: {(placeMark) in
					self.placeMark = placeMark
					self.activity.stopAnimating()
					self.activity.isHidden = true
					self.profileViewStructureTV.reloadData()
				})
				
			})
		})
	}
	
	func getLoyaltyProgramData(completion: @escaping (Bool) -> ()) {
		loyaltyProgram.getCurrentLoyaltyProgram(completion: {(status, program) in
			self.loyaltyProgram = program
			completion(true)
		})
	}
	
	func getProfileData(completion: @escaping (Bool) -> ()) {
		adn.getAccountDocument(completion: {(status, data) in
			self.profile = data
			completion(true)
		})
	}
	
	func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
								-> Void ) {
		// Use the last reported location.
		if let lastLocation = self.locationManager.location {
			let geocoder = CLGeocoder()
			
			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(lastLocation,
											completionHandler: { (placemarks, error) in
												if error == nil {
													let firstLocation = placemarks?[0]
													completionHandler(firstLocation)
												}
												else {
													// An error occurred during geocoding.
													completionHandler(nil)
												}
											})
		}
		else {
			// No location was available.
			completionHandler(nil)
		}
	}
	
	
	func setNibs() {
		sections = 4
		
		let cellNib = UINib(nibName: "HeaderTableViewCell", bundle: nil)
		self.profileViewStructureTV.register(cellNib, forCellReuseIdentifier: "HeaderCell")
		
		let followButtonNib = UINib(nibName: "FollowButtonTableViewCell", bundle: nil)
		self.profileViewStructureTV.register(followButtonNib, forCellReuseIdentifier: "FollowButtonCell")
		
		let loyaltyNib = UINib(nibName: "LoyaltyCardTableViewCell", bundle: nil)
		self.profileViewStructureTV.register(loyaltyNib, forCellReuseIdentifier: "LoyaltyCardCell")
		
		let contactNib = UINib(nibName: "ContactAndLocationTableViewCell", bundle: nil)
		self.profileViewStructureTV.register(contactNib, forCellReuseIdentifier: "ContactCell")
	}
}

extension ProfilePreviewViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
			case 0:
				return 348
			case 1:
				return 200
			default:
				return 300
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch indexPath.row {
			case 0:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderTableViewCell {
					// Show SubCategory Title
					
					
					// Pass the data to colletionview inside the tableviewcell
					
					// Set cell's delegate
					cell.updateCell(profile: profile)
					cell.selectionStyle = .none
					return cell
				}
				
			case 1:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactAndLocationTableViewCell {
					// Show SubCategory Title
					
					
					// Pass the data to colletionview inside the tableviewcell
					
					// Set cell's delegate
					cell.updateCell(profile: profile)
					cell.selectionStyle = .none
					return cell
				}
				
			case 2:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyCardCell", for: indexPath) as? LoyaltyCardTableViewCell {
					// Show SubCategory Title
					
					
					// Pass the data to colletionview inside the tableviewcell
					
					// Set cell's delegate
					cell.updateCell(lp: loyaltyProgram.lp)
					cell.selectionStyle = .none
					return cell
				}
			default:
				return UITableViewCell()
				
		}
		return UITableViewCell()
	}
}
