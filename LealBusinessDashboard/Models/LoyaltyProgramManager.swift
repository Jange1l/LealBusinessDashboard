//
//  LoyaltyProgram.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/5/21.
//

import Foundation

class LoyaltyProgramManager: NSCopying {
	
//	private var businessName: String
//	private var numberOfSteps: Int
//	private var pointsPerStep: Int
//	private var steps: [ModelStructures.LPStep]
	
	private var defaults: AccountDetails!
	private var networking: LoyaltyProgramNetworking!
	
	var lp: ModelStructures.LoyaltyProgram!
	
	init() {
		lp = ModelStructures.LoyaltyProgram(businessName: "", numberOfSteps:" ", pointsPerStep: "", steps: [ModelStructures.LPStep]())
		
		self.lp.businessName = AccountDetails().getBusinessName()
		self.lp.numberOfSteps = "0"
		self.lp.pointsPerStep = "0"
		self.lp.steps = [ModelStructures.LPStep]()
		
		defaults = AccountDetails()
		networking = LoyaltyProgramNetworking()
	}
	
	private init(businessName: String, numberOfSteps: String, pointsPerStep: String, steps:[ModelStructures.LPStep]) {
		defaults = AccountDetails()
		networking = LoyaltyProgramNetworking()
		
		self.lp = ModelStructures.LoyaltyProgram(businessName: businessName, numberOfSteps:numberOfSteps, pointsPerStep: pointsPerStep, steps: steps)
		
//		self.lp.businessName = businessName
//		self.lp.numberOfSteps = numberOfSteps
//		self.lp.pointsPerStep = pointsPerStep
//		self.lp.steps = steps
	}
	
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = LoyaltyProgramManager(businessName: AccountDetails().getBusinessName(), numberOfSteps: lp.numberOfSteps, pointsPerStep: lp.pointsPerStep, steps: lp.steps)
		return  copy
	}

	func getCurrentLoyaltyProgram(completion: @escaping (Bool, LoyaltyProgramManager) -> ()) {
		
		networking.fetchCurrentLoyaltyProgram(completion: {(completed, program) in
			
			let lp = LoyaltyProgramManager(businessName: program.businessName, numberOfSteps: program.numberOfSteps, pointsPerStep: program.pointsPerStep, steps: program.steps)
			
			completion(completed, lp)
		})
		
		
	}
	
	func updateLoyaltyProgram(lp: ModelStructures.LoyaltyProgram, ref: ModelStructures.LoyaltyProgram) {
		networking.updateLoyaltyProgram(lp: lp, ref: ref)
	}
	
	
	
}
