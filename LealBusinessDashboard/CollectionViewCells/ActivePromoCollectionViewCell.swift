//
//  ActivePromoCollectionViewCell.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 4/11/21.
//

import UIKit

class ActivePromoCollectionViewCell: UICollectionViewCell {

	static let name = "ActivePromoCollectionViewCell"
	static let identifier = "ActivePromoCell"
	
	var deleted: ((_ value: String) -> ())?
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var cellBGV: UIView!
	@IBOutlet weak var label: UILabel!
	
	@IBOutlet weak var duration: UILabel!
	@IBOutlet weak var quantity: UILabel!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var discount: ModelStructures.Discount!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		self.layer.shadowColor = UIColor.gray.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 6
		self.layer.shadowOpacity = 0.35
		self.layer.masksToBounds = false
		mainView.layer.cornerRadius = 15
		cellBGV.layer.cornerRadius = 50
		cellBGV.layer.borderColor = UIColor.green.cgColor
		cellBGV.layer.borderWidth = 1
    }

	
	func setCell(x: ModelStructures.Discount) {
		discount = x
		label.text = x.discount
		duration.text = getTimeLeft(endDate: x.endDate)
		quantity.text = x.quantity
		descriptionLabel.text = x.description
	}
	
	@IBAction func deletePressed(_ sender: Any) {
		delete()
	}
	func delete() {
		print("DELETE PRESSED -> \(discount.postUid)" )
		LealConstants.DiscountsRef.document(discount.postUid).delete(){ err in
			if let err = err {
				   print("Error removing document: \(err)")
			   } else {
				   print("Document successfully removed!")
				self.deleted?("True")
			   }
		   }
	}
	
	func getTimeLeft(endDate: String) -> String{
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		let timeReleased = form.string(from: date)
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		
		if hours! > 24 {
			duration.textColor = UIColor.systemTeal
			var days = Double(hours!) / 24
			print("HOUS AND DAYS DISCOUNT TOKEN -> ",hours, days)
			days.round()
			return "\(Int(days)) Days"
		}
	
		if hours! > 0 && hours! < 24 {
			duration.textColor = UIColor.systemTeal
			if hours == 1 {
				duration.textColor = UIColor.systemTeal
				return "1 hour"
			}
			return "\(hours!) Hours"
		}
		
		if hours! < 0 && minutes! < 0 {
			duration.textColor = UIColor.yellow
			
			return "Expired"
		}
		
		
		duration.textColor = UIColor.systemTeal
		return "\(hours!) Hours"
	}
}
