//
//  DashBoardViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/25/20.
//

import UIKit

class DashBoardViewController: UIViewController {

	@IBOutlet weak var dashBoardCollectionView: UICollectionView!
	var dashBoardFeatures: DashBoardFeatures!
	var accountDetails: AccountDetails!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
	
		setUpCollectionView()
		fetchAccountTools()
        
    }
    

	func setUpCollectionView() {
		dashBoardFeatures = DashBoardFeatures()
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: 230, height: 230)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		
		self.dashBoardCollectionView.collectionViewLayout = flowLayout
		self.dashBoardCollectionView.showsVerticalScrollIndicator = true
		let cellNib = UINib(nibName: "DashBoardCollectionViewCell", bundle: nil)
		self.dashBoardCollectionView.register(cellNib, forCellWithReuseIdentifier: "DashBoardCell")
	}
	
	func fetchAccountTools() {
		activityIndicator.startAnimating()
		dashBoardFeatures = DashBoardFeatures()
		dashBoardFeatures.getCurrentFeatures(completion: { (status) in
			self.dashBoardCollectionView.reloadData()
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			
		})
	}
	
	
   
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}

}

extension DashBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dashBoardFeatures.features.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashBoardCell", for: indexPath) as? DashBoardCollectionViewCell {
			
			cell.updateCell(data: dashBoardFeatures.features[indexPath.item])
			
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let viewControllerIdentifier = dashBoardFeatures.features[indexPath.item].viewControllerIdentifier
		
		performSegue(withIdentifier: viewControllerIdentifier, sender: nil)
		
	}
	
	//Add spaces at the beginning and the end of the collection view
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
	   return UIEdgeInsets(top: 20, left: 40, bottom: 40, right: 40)
   }
}
