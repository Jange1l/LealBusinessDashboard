//
//  FollowButtonTableViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/18/21.
//

import UIKit

class FollowButtonTableViewCell: UITableViewCell {

	@IBOutlet weak var followButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		followButton.layer.cornerRadius = 15
		followButton.layer.borderWidth = 1
		followButton.layer.borderColor = UIColor.link.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
