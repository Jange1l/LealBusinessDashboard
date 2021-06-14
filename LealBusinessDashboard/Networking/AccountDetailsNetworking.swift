//
//  AccountDetailsNetworking.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/5/21.
//

import Foundation
import Firebase
import CoreLocation

class AccountDetailsNetworking {
	
	func getAccountDocument(completion: @escaping (Bool, ModelStructures.AccountDetails) -> ()){
		
		var account = ModelStructures.AccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "",promotionsPostedCount: "", followersCount: "", uid: "")
		
		LealConstants.AccountDetailsRef.getDocument { (document, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, account)
			} else {
				if let document = document, document.exists {
					
					let data = document.data()
					//user.name = (data!["firstName"] as! NSString) as String
					account.businessName = data![LealConstants.f_bName] as! String
					account.businessEmail = data![LealConstants.f_bEmail] as! String
					account.businessPhoneNumber = data![LealConstants.f_bPhoneNumber] as! String
					account.businessBio = data![LealConstants.f_bBusinessBio] as! String
					account.businessType = data![LealConstants.f_bBusinessType] as! String
					account.profileImageUrl = data![LealConstants.f_bProfileImageURL] as! String
					account.promotionsPostedCount = data![LealConstants.f_bPromotionsPostedCount] as! String
					account.followersCount = data![LealConstants.f_bFollowersCount] as! String
					account.uid = data![LealConstants.f_bUid] as! String
					
					
				}
				// Perform actions with data
				completion(true, account)
			}
		}
	}
	
	func updateAccountDetails(account: ModelStructures.AccountDetails) {
		LealConstants.AccountDetailsRef.updateData([
			LealConstants.f_bName: account.businessName,
			LealConstants.f_bEmail: account.businessEmail,
			LealConstants.f_bProfileImageURL: account.profileImageUrl,
			LealConstants.f_bPhoneNumber: account.businessPhoneNumber,
			LealConstants.f_bBusinessType: account.businessType,
			LealConstants.f_bBusinessBio: account.businessBio
		])
	}
	
	
	func getFollowersUid(completion: @escaping (Bool, [ModelStructures.Follower] ) -> ()) {
		var followers = [ModelStructures.Follower]()
		
		LealConstants.FollowersRef.getDocuments(completion: {(snap, err) in
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false,followers)
			} else {
				
				for document in snap!.documents {
					let customerName = document["customerName"] as! String
					let customeruid = document["customerUid"] as! String
					let customerNotifToken = document["notificationToken"] as! String
					let businessName = AccountDetails().getBusinessName()
					let businessUid = AccountDetails().getUid()
					
					let follower = ModelStructures.Follower(customerName: customerName, customerUid: customeruid, customerNotifToken: customerNotifToken, businessName: businessName, businessUid: businessUid)
					
					followers.append(follower)
				}
			}
			completion(true, followers)
			
		})
	}
	
	func getLocation(completion: @escaping (Bool, CLLocation) -> ()) {
		
		var lt: Double!
		var lg: Double!
		
		LealConstants.LocationRef.getDocument(completion:{ (snap, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				var place = CLLocation(latitude: 00.0, longitude: 0.0)
				completion(false, place)
			} else {
				if let document = snap, document.exists {
					
					let data = document.data()
					let lat = Double(data!["Lat"] as! String)
					let long = Double(data!["Long"]as! String)
					lt = lat
					lg = long
				}
				var place = CLLocation(latitude: lt!, longitude: lg!)
				completion(true, place)
			}
		} )
	}
	
	func signOut(completion: @escaping (Bool) -> ()) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			print("User signed out")
			//self.dismiss(animated: true, completion: nil)
			completion(true)
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			completion(false)
		}
		
	}
	
	
	
}
