//
//  STViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/9/21.
//

import UIKit
import CoreLocation

class STViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	let locationManager = CLLocationManager()
	
	var networking: AccountDetailsNetworking!
	
	var account: AccountDetails!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		account = AccountDetails()
		activity.startAnimating()
		setNibs()
		getData()
	}
	
	func getData() {
		networking = AccountDetailsNetworking()
		
	}
	
	func setNibs() {
		let cellNib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
		self.tableView.register(cellNib, forCellReuseIdentifier: "settingsCell")
	}
	
	
	func showAlert() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
		let alert = UIAlertController(title: "Success", message: "Data saved succesfuly!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
	
		self.present(alert, animated: true, completion: nil)
	}
	
	func signOutAlert() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
		let alert = UIAlertController(title: "Wait!", message: "Are you sure you want to log out?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			self.signOut()
		}))
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			
		}))
	
		self.present(alert, animated: true, completion: nil)
	}
	
	func notAvailableAlert() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
		let alert = UIAlertController(title: "Oops", message: "This feature is not available yet", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
	
		self.present(alert, animated: true, completion: nil)
	}
	
	func signOut() {
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
	
}

extension STViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
			case 0:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsTableViewCell {
					
					
					cell.selectionStyle = .none
					
					cell.editLocation = {
						value in
						self.notAvailableAlert()
					}
					
					cell.upgradeAccount = {
						value in
						self.notAvailableAlert()
					}
					cell.signOutPressed = {
						value in
						self.signOutAlert()
					}
					cell.saveData = {
						value in
						self.showAlert()
					}
					cell.loaded = {
						value in
						self.activity.stopAnimating()
						self.activity.isHidden = true
					}
					
					cell.preview = { value in
						var profilePreview: ProfilePreviewViewController = (self.storyboard?.instantiateViewController(identifier: "profilePreview"))! as ProfilePreviewViewController
						self.present(profilePreview, animated: true, completion: nil)
					}
					return cell
				}
			default:
				return UITableViewCell()
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 777
	}
	
	
}
