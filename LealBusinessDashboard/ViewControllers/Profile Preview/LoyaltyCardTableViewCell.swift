//
//  LoyaltyCardTableViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/20/21.
//

import UIKit

class LoyaltyCardTableViewCell: UITableViewCell {

	@IBOutlet weak var cardBackgroundView: UIView!
	@IBOutlet weak var pointsBackgroundView: UIView!
	
	@IBOutlet weak var businessNameLabel: UILabel!
	@IBOutlet weak var customerNameLabel: UILabel!
	@IBOutlet weak var memeberSinceLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!
	@IBOutlet weak var levelOfLabel: UILabel!
	
	
	@IBOutlet weak var viewLpButton: UIButton!
	
	var lp: ModelStructures.LoyaltyProgram!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	
	func updateCell(lp: ModelStructures.LoyaltyProgram) {
		self.lp = lp
		viewLpButton.layer.cornerRadius = 15
		//cardBackgroundView.layer.borderWidth = 1
		//cardBackgroundView.layer.borderColor = UIColor.systemTeal.cgColor
		pointsBackgroundView.layer.cornerRadius = 50
		businessNameLabel.text = lp.businessName
		pointsLabel.text = "\(lp.pointsPerStep!)"
		levelOfLabel.text = "Level 1 of \(lp.numberOfSteps!)"
		
	}
	
	
}
