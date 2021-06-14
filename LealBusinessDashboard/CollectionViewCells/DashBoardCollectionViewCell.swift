//
//  DashBoardCollectionViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/25/20.
//

import UIKit

class DashBoardCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var cellBackground: UIView!
	
	@IBOutlet weak var cellName: UILabel!
	
	@IBOutlet weak var cellLogo: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		print("cell being loaded")
		
		cellBackground.layer.cornerRadius = 10
		
		self.layer.shadowColor = UIColor.gray.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 6
		self.layer.shadowOpacity = 0.35
		self.layer.masksToBounds = false
		
	}
	
	func updateCell(data: ModelStructures.DashBoardFeatureStructure) {
		
		if data.logo == "active" {
			cellName.text = data.name
			cellName.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
			cellName.textColor = UIColor.white
			cellBackground.layer.backgroundColor = #colorLiteral(red: 0.2417081296, green: 0.3602807522, blue: 0.3454155922, alpha: 1)
			cellLogo.image = nil
			
		} else {
			cellName.text = data.name
			print("Cell updated, Logo image name -> ",data.logo)
			cellLogo.image = UIImage(named: data.logo)
		}
		
	}
	
}
