//
//  AccountDetails.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/4/21.
//

import Foundation
import Firebase

struct LealConstants {
	
	static let uid = Auth.auth().currentUser!.uid
	
	// Collections
	static let BusinessUsers = "BusinessUsers"
	static let UserTools = "Tools"
	static let LoyaltyProgram = "LoyaltyProgram"
	static let CreatePromotion = "CreatePromotion"
	static let Followers = "Followers"
	
	// Account fields
	static let f_bName = "BusinessName"
	static let f_bEmail = "Email"
	static let f_bUsername = "Username"
	static let f_bUid = "Uid"
	static let f_bProfileImageURL = "ProfileUrl"
	static let f_bPhoneNumber = "PhoneNumber"
	static let f_bBusinessType = "BusinessType"
	static let f_bBusinessBio = "BusinessBio"
	static let f_bPromotionsPostedCount = "PromotionsPostedCount"
	static let f_bFollowersCount = "FollowerCount"
	
	// Loyalty Program Fields
	static let lt_numberOfSteps = "numberOfSteps"
	static let lt_pointsPerStep = "pointsPerStep"
	static let lt_Steps = "Steps"
	// LTP Step Fields
	static let lps_stepNumber = "step_number"
	static let lps_requiredPoints = "required_points"
	static let lps_rewardName = "reward_name"
	static let lps_rewardDescription = "reward_description"
	
	
	// Dashboard Feature Fields CHANGE THIS TO MORE MEANINGFUL NAMES
	static let viewIdentifier = "viewIdentifier"
	static let toolName = "toolName"
	static let logoName = "logoName"
	static let backgroundColor = "backgroundColor"
	// Tool Names
	static let tn_loyaltyProgram = "Manage Loyalty Program"
	static let tn_createPromotion = "Create Promotion"
	static let tn_analytics = "Manage Analytics"
	
	// Tool View Ids
	static let ti_loyaltyProgram = "ManageLoyaltyProgram"
	static let ti_createPromotion = "CreatePromotion"
	
	// DB References
	static let db = Firestore.firestore()
	static let BusinessToolsRef = db.collection(BusinessUsers).document(uid).collection(UserTools)
	static let AccountDetailsRef = db.collection(BusinessUsers).document(uid)
	static let tool_LoyaltyProgram = db.collection(BusinessUsers).document(uid).collection(UserTools).document(LoyaltyProgram)
	static let FollowersRef = db.collection(BusinessUsers).document(uid).collection(Followers)
	static let LocationRef = db.collection("Locations").document(uid)
	static let CustomersRef = db.collection("CustomerUsers")
	
	
	
	static let NotifyRef = db.collection("NotifyDiscount")
	
	static let DiscountsRef = db.collection("Discounts")
	static let BundlesRef = db.collection("Bundles")
	static let AnnouncementsRef = db.collection("Announcements")
}
