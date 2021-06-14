//
//  AccountDetails.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/5/21.
//

import Foundation
// This class is intended to save all crucial account details into user defaults
//
// The intended interaction is for the client to request any of those account value from userDefaults. If any values need to be updated they will be updated with this class. Do not reference values from here.
//
// This class gets called when the user initially signs up or for future editing purposes

class AccountDetails {
		
	var networking: AccountDetailsNetworking!
	
	let defaults = UserDefaults.standard
	
	private let BusinessName = "BusinessName"
	private let BusinessEmail = "BusinessEmail"
	private let BusinessPhoneNumber = "BusinessPhoneNumber"
	private let Uid = "Uid"
	private let FollowersUidList = "FollowersUidList"
	private let AvailableFeaturesNameList = "AvailableFeaturesNameList"
	private let BusinessType = "BusinessType"
	private let BusinessBio = "BusinessBio"
	private let ProfileUrl = "ProfileUrl"
	private let IsLoggedIn = "IsLoggedIn"
	
	init() {
		networking = AccountDetailsNetworking()
		
	}
	
	//MARK: Check User State
	func hasUserLoggedinBefore() -> Bool {
		var permission = false
		if !defaults.bool(forKey: IsLoggedIn) {
			networking.signOut(completion: {(completed) in
				self.clearOut()
			})
			permission = false
			defaults.setValue(true, forKey: IsLoggedIn)
		} else {
			permission = true
		}
		return permission
	}
	
	// MARK: Getters
	func getBusinessName() -> String {
		
		return defaults.string(forKey: BusinessName) ?? ""
	}
	
	func getBusinessEmail() -> String {
		return defaults.string(forKey: BusinessEmail) ?? "Add email in account details"
	}
	
	func getBusinessPhoneNumber() -> String {
		return defaults.string(forKey: BusinessPhoneNumber) ?? ""
	}
	
	func getUid() -> String {
		return defaults.string(forKey: Uid)!
		
	}
	
	func getBusinessType() -> String {
		return defaults.string(forKey: BusinessType) ?? ""
	}
	
	func getBusinessBio() -> String {
		return defaults.string(forKey: BusinessBio) ?? "Set a business bio"
	}
	
	func getProfileUrl() -> String {
		return defaults.string(forKey: ProfileUrl) ?? "No profile picture"
	}
	
	func getFollowersUidList() -> [String] {
		return defaults.stringArray(forKey: FollowersUidList) ?? [String]()
	}
	
	func getAvailableFeaturesNameList() -> [String] {
		return defaults.stringArray(forKey: AvailableFeaturesNameList) ?? [String]()
	}
	
	// MARK: Setters
	func setBusinessName(name: String) {
		defaults.setValue(name, forKey: BusinessName)
	}
	
	func setBusinessEmail(email: String) {
		defaults.setValue(email, forKey: BusinessEmail)
	}
	
	func setBusinessPhoneNumber(number: String) {
		defaults.setValue(number, forKey: BusinessPhoneNumber)
	}
	
	func setUid(uid: String) {
		print("set uid called ->", uid)
		defaults.setValue(uid, forKey: Uid)
	}
	
	func setBusinessType(type: String) {
		defaults.setValue(type, forKey: BusinessType)
	}
	
	func setBusinessBio(bio: String) {
		defaults.setValue(bio, forKey: BusinessBio)
	}
	
	func setProfilePUrl(profileUri: String) {
		defaults.setValue(profileUri, forKey: ProfileUrl)
	}
	
//	func setFollowersUidList(list: [String] ) {
//		let input = list as NSArray
//		defaults.setValue(input, forKey: "BusinessName")
//	}
	
	func setAvailableFeaturesList(namesList: [ModelStructures.DashBoardFeatureStructure]) {

		var input = [String]()

		for name in namesList{
			input.append(name.name)
		}

		defaults.setValue(input as NSArray, forKey: "FeatureList")
	}
	
	// MARK: Logic Functions
	
	func save_AtLogin_LocalAccountDetails(completion: @escaping (Bool) -> ()) {
		
		networking.getAccountDocument(completion: {(completed, account) in
			print("USER LOGGED IN AS ->")
			print("BUSINESS NAME IN ACTD-> ",account.businessName)
			self.setBusinessName(name: account.businessName)
			self.setBusinessEmail(email: account.businessEmail)
			self.setBusinessPhoneNumber(number: account.businessPhoneNumber)
			self.setBusinessType(type: account.businessType)
			self.setProfilePUrl(profileUri: account.profileImageUrl)
			self.setBusinessBio(bio: account.businessBio)
			self.setUid(uid: account.uid)
			
			completion(true)
		})
	}
	
	// CONSIDER JUST RE-DOWNLOADING A FRESH PROFILE COPY INSTEAD OF CHECKING FOR DIFFERENCES
	func updateLocalAccountDetails(account: ModelStructures.AccountDetails) {
		print("SAVING THIS ACCOUNT LOCALLY ", account)
		setBusinessName(name: account.businessName)
		setBusinessEmail(email: account.businessEmail)
		setBusinessPhoneNumber(number: account.businessPhoneNumber)
		setBusinessType(type: account.businessType)
		setProfilePUrl(profileUri: account.profileImageUrl)
		setBusinessBio(bio: account.businessBio)
	}
	
	func clearOut() {
		print("All data cleared out")
		setBusinessName(name: "")
		setBusinessEmail(email: "")
		setBusinessPhoneNumber(number: "")
		setBusinessType(type: "")
		setProfilePUrl(profileUri: "")
		setBusinessBio(bio: "")
		setUid(uid: "")
		defaults.setValue(false, forKey: IsLoggedIn)
	}
	
	func getAccountDetails(completion: @escaping (Bool) -> ()) {
		networking.getAccountDocument(completion: {(completed, account) in
			
			completion(true)
		})
	}
	
	func getAccount() -> ModelStructures.AccountDetails {
		var tempAccount = ModelStructures.AccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "",promotionsPostedCount: "", followersCount: "", uid: "")
		
		tempAccount.businessName = getBusinessName()
		tempAccount.businessEmail = getBusinessEmail()
		tempAccount.businessPhoneNumber = getBusinessPhoneNumber()
		tempAccount.businessType = getBusinessType()
		tempAccount.profileImageUrl = getProfileUrl()
		tempAccount.businessBio = getBusinessBio()
		tempAccount.uid = getUid()
		return tempAccount
	}
	
	
}
