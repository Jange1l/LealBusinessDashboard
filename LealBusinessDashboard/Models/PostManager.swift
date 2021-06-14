//
//  PostManager.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/23/21.
//

import Foundation


class PostManager {
	
	var networking: PostNetworking!
	private var defaults: AccountDetails!
	
	init() {
		defaults = AccountDetails()
		networking = PostNetworking()
	}
	
	func postDiscount(load: String, endDate: String, description: String, quantity: String)  {
		
		let businessName = defaults.getBusinessName()
		
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		let timeReleased = form.string(from: date)
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		
		
		networking.postDiscount(businessName: businessName, discount: load, timeReleased: timeReleased, duration: "\(hours!) \(minutes!)", description: description, endDate: endDate, quantity: quantity)
		
		
		
		
	}
	
	func postBundle(load: String, endDate: String, description: String,  quantity: String) {
		let businessName = defaults.getBusinessName()
		
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		let timeReleased = form.string(from: date)
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		networking.postBundle(businessName: businessName, discount: load, timeReleased: timeReleased, duration: "\(hours!) \(minutes!)", description: description, endDate: endDate, quantity: quantity)
	}
	
	func postAnnouncement(message: String) {
		let businessName = defaults.getBusinessName()
		
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		let date = Date()
		let timeReleased = form.string(from: date)
		
		networking.postAnnouncement(businessName: businessName, message: message, timeReleased: timeReleased)
	}
	
}
