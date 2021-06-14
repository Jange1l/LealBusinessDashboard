//
//  HeaderTableViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/17/21.
//

import UIKit
import Firebase

class HeaderTableViewCell: UITableViewCell {

	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var businessNameLabel: UILabel!
	
	@IBOutlet weak var numberOfPromotionsLabel: UILabel!
	@IBOutlet weak var numberOfFollowersLabel: UILabel!
	
	var profile: ModelStructures.AccountDetails!
	let storage = Storage.storage().reference()
	
	
	@IBOutlet weak var followButton: UIButton!
	//var account: AccountDetails!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		logoImage.layer.cornerRadius = 64
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
	
	func updateCell(profile: ModelStructures.AccountDetails) {
		self.profile = profile
		setPicture()
		followButton.layer.borderWidth = 1
		followButton.layer.cornerRadius = 15
		followButton.layer.borderColor = UIColor.link.cgColor
		businessNameLabel.text = profile.businessName
		numberOfPromotionsLabel.text = profile.promotionsPostedCount
		numberOfFollowersLabel.text =  profile.followersCount
		
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
					self.logoImage.image = image
//					self.activity.stopAnimating()
//					self.activity.isHidden = true
				}
			}
		} else {
			// Set default profile with no picture
			
		}
	}
    
}
