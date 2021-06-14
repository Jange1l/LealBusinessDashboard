//
//  ActivePromosViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 4/5/21.
//

import UIKit

class ActivePromosViewController: UIViewController {

	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	var discounts: [ModelStructures.Discount]!
	
	var selectedToken: ModelStructures.Discount!
	
	var accountDetails: AccountDetails!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		accountDetails = AccountDetails()
        setCollectionView()
		fetchPostData()
    }
    
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}

	func setCollectionView() {
		// TODO: need to setup collection view flow layout
		collectionView.dataSource = self
		collectionView.delegate = self
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: 300, height: 170)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		
		collectionView.collectionViewLayout = flowLayout
		collectionView.showsHorizontalScrollIndicator = false
		
		let discount = UINib(nibName: ActivePromoCollectionViewCell.name, bundle: nil)
		collectionView.register(discount, forCellWithReuseIdentifier: ActivePromoCollectionViewCell.identifier)
	}
	
	func fetchPostData() {
		var promos = [ModelStructures.Discount]()
		activity.startAnimating()
		LealConstants.DiscountsRef.whereField("uid", isEqualTo: accountDetails.getUid()).getDocuments(completion: {(snap, err) in
			
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				
			} else {
				
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var promo = ModelStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
					
					promo.businessName = data["businessName"] as! String
					promo.discount = data["discount"] as! String
					promo.timeReleased = data["timeReleased"] as! String
					promo.duration = data["duration"] as! String
					promo.endDate = data["endDate"] as! String
					promo.description = data["description"] as! String
					promo.quantity = data["quantity"] as! String
					promo.profileUrl = data["profileUrl"] as! String
					promo.uid = data["uid"] as! String
					promo.postUid = data["postUid"] as! String
					promo.type = data["type"] as! String
					
					promos.append(promo)
				}
			}
			self.activity.stopAnimating()
			self.activity.isHidden = true
			self.discounts = promos
			self.collectionView.reloadData()
		})
		
	}
	
	@IBAction func exit(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	
	
}


extension ActivePromosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if discounts != nil {
			return discounts.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivePromoCollectionViewCell.identifier, for: indexPath) as? ActivePromoCollectionViewCell {
			
			cell.deleted = {
				value in
				self.fetchPostData()
			}
			if discounts != nil {
				cell.setCell(x: discounts[indexPath.item])
			}
			
			return cell
		}
		
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedToken = discounts[indexPath.item]
		
	}
}
