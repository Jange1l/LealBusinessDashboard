//
//  StepCollectionViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/30/21.
//

import UIKit

class StepCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var cellName: UILabel!
	@IBOutlet weak var bcgView: UIView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		bcgView.layer.cornerRadius = 10
		
		self.layer.shadowColor = UIColor.systemGray.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 4
		self.layer.shadowOpacity = 0.75
		self.layer.masksToBounds = false
    }

	
}
