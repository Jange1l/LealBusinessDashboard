//
//  DiscountCollectionViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/23/21.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {

	static let name = "DiscountCollectionViewCell"
	static let identifier = "DiscountCell"
	
	
	@IBOutlet weak var bView: UIView!
	@IBOutlet weak var label: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		bView.layer.cornerRadius = 50
		bView.layer.borderColor = UIColor.green.cgColor
		bView.layer.borderWidth = 1
		
    }

	
	func setDiscount(value: String) {
		label.text = value
	}
	
	
	
	override var isSelected: Bool {
		didSet{
			if self.isSelected {
				UIView.animate(withDuration: 0.3) { // for animation effect
					self.layer.borderColor = UIColor.systemPurple.cgColor
					self.layer.borderWidth = 3
				}
			}
			else {
				UIView.animate(withDuration: 0.3) { // for animation effect
					self.layer.borderWidth = 0
				}
			}
		}
	}
	
	
	
}
