//
//  PostNetworking.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/23/21.
//

import Foundation
import Firebase


class PostNetworking {
	let accountDetails = AccountDetails()
	func postDiscount(businessName: String, discount: String, timeReleased: String, duration: String, description: String, endDate: String, quantity: String) {
		
		let postUid = UUID().uuidString
		
		LealConstants.DiscountsRef.document(postUid).setData(
			[
				"businessName": businessName,
				"discount": discount,
				"timeReleased": timeReleased,
				"duration": duration,
				"endDate": endDate,
				"description": description,
				"quantity" : quantity,
				"profileUrl" : "\(AccountDetails().getProfileUrl())",
				"uid" :"\(AccountDetails().getUid())",
				"postUid" : postUid,
				"type" : "discount"
			])
		
		sendDiscountNotification(message: description, discount: discount)
		
	}
	
	func postBundle(businessName: String, discount: String, timeReleased: String, duration: String, description: String, endDate: String, quantity: String) {
		
		let postUid = UUID().uuidString
		
		LealConstants.DiscountsRef.document(postUid).setData(
			[
				"businessName": businessName,
				"discount": discount,
				"timeReleased": timeReleased,
				"duration": duration,
				"endDate": endDate,
				"description": description,
				"quantity" : quantity,
				"profileUrl" : "\(AccountDetails().getProfileUrl())",
				"uid" :"\(AccountDetails().getUid())",
				"postUid" : postUid,
				"type" : "bundle"
			])
		
		sendDiscountNotification(message: description, discount: discount)
	}
	
	func postAnnouncement(businessName: String, message: String, timeReleased: String) {
		
		let postUid = UUID().uuidString
		
		LealConstants.AnnouncementsRef.document(postUid).setData(
			[
				"businessName": businessName,
				"message": message,
				"timeReleased": timeReleased,
				"profileUrl" : "\(AccountDetails().getProfileUrl())",
				"uid" :"\(AccountDetails().getUid())",
				"postUid" : postUid
				
			])
		
		sendDiscountNotification(message: message, discount: "")
	}
	
	func sendDiscountNotification(message: String, discount: String) {
		AccountDetailsNetworking().getFollowersUid(completion: {(status, followers) in
			
			print("Followers -> ", followers)
			if status != false {
				print("")
				for f in followers {
					if discount != "" {
						LealConstants.NotifyRef.addDocument(data:
						[
							"businessName" : "\(self.accountDetails.getBusinessName()) - \(discount)",
							"message" : "Hi \(f.customerName) - \(message)",
							"notifToken" : "\(f.customerNotifToken)",

						])
					} else {
						LealConstants.NotifyRef.addDocument(data:
						[
							"businessName" : "\(self.accountDetails.getBusinessName())",
							"message" : "\(message)",
							"notifToken" : "\(f.customerNotifToken)",

						])
					}
					
				}

			}
			
		})
	}
	
	
	
}
