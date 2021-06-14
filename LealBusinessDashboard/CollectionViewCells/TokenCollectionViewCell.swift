//
//  TokenCollectionViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/23/21.
//

import UIKit
import Firebase

class TokenCollectionViewCell: UICollectionViewCell {

	static let name = "TokenCollectionViewCell"
	static let identifier = "TokenCell"
	
	@IBOutlet weak var bView: UIView!
	@IBOutlet weak var image: UIImageView!
	
	
	var profile: ModelStructures.AccountDetails!
	let storage = Storage.storage().reference()
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		self.layer.cornerRadius = 50
		
    }

	func updateCell(profile: ModelStructures.AccountDetails) {
		self.profile = profile
		setPicture()
		
	}
	
	func setPicture() {
		if profile.profileImageUrl != nil {
			// Download image
			let storage = Storage.storage().reference()
			let profileImagesRef = storage.child("ProfileImages")
			let p = profileImagesRef.child(profile.uid)
			
			// Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
			p.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
				} else {
					// Data for "images/island.jpg" is returned
					let image = UIImage(data: data!)
					self.image.image = image
//					self.activity.stopAnimating()
//					self.activity.isHidden = true
				}
			}
		} else {
			// Set default profile with no picture
			
		}
	}
	
}
