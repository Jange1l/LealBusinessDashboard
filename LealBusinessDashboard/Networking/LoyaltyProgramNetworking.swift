//
//  LoyaltyProgramNetworking.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/5/21.
//

import Foundation
import Firebase


class LoyaltyProgramNetworking {
	
	
	func fetchCurrentLoyaltyProgram(completion: @escaping (Bool, ModelStructures.LoyaltyProgram) -> ()){
		
		var lp = ModelStructures.LoyaltyProgram(businessName: AccountDetails().getBusinessName(), numberOfSteps: "", pointsPerStep: "", steps: [ModelStructures.LPStep]())
		
		LealConstants.tool_LoyaltyProgram.getDocument { (document, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, lp)
			} else {
				if let document = document, document.exists {
					
					let data = document.data()
					lp.numberOfSteps = data![LealConstants.lt_numberOfSteps] as? String
					lp.pointsPerStep = data![LealConstants.lt_pointsPerStep] as? String
				}
				// Perform actions with data
				
				LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).collection(LealConstants.lt_Steps).getDocuments(completion: {(snap, err) in
					if let err = err {
						print("Error getting documents for user information: \(err)")
						completion(false, lp)
					} else {
						
						for document in snap!.documents {
							//var email = document["email"] as! String
							let stepNumber = document[LealConstants.lps_stepNumber] as! String
							let requiredPoints = document[LealConstants.lps_requiredPoints] as! String
							let rewardName = document[LealConstants.lps_rewardName] as! String
							let rewardDescription = document[LealConstants.lps_rewardDescription] as! String
							
							let value = document["value"] as! String
							
							let step = ModelStructures.LPStep(stepNumber: stepNumber, requiredPoints: requiredPoints, rewardName: rewardName, rewardDescription: rewardDescription, value: value)
							lp.steps.append(step)
						}
					}
					completion(true, lp)
				})
			}
		}
	}
	
	func updateLoyaltyProgram(lp: ModelStructures.LoyaltyProgram, ref: ModelStructures.LoyaltyProgram) {
		
		var stepsToRemove = [ModelStructures.LPStep]()
		print("LP -> ", lp.steps, "REF LP -> ", ref.steps)
		
		if lp.steps != ref.steps {
			for s in ref.steps {
				if !lp.steps.contains(s) {
					stepsToRemove.append(s)
				}
			}
			print("STEPS TO REMOVE", stepsToRemove)
		}
		
		for s in stepsToRemove {
			print("removing step \(s.stepNumber!)")
			LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).collection(LealConstants.lt_Steps).document("Step\(s.stepNumber!)").delete() { err in
				if let err = err {
					print("Error removing document: \(err)")
				} else {
					print("Document successfully removed!")
				}
			}
		}
		
		LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).setData([
			LealConstants.toolName: LealConstants.tn_loyaltyProgram,
			LealConstants.viewIdentifier: LealConstants.ti_loyaltyProgram,
			LealConstants.lt_numberOfSteps: String(lp.numberOfSteps),
			LealConstants.lt_pointsPerStep: String(lp.pointsPerStep),
			LealConstants.logoName: "loyalty_icon",
			LealConstants.backgroundColor: ""
			
		])
		
		let pointsPer =  Float(lp.pointsPerStep)! 
		for s in lp.steps {
			LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).collection(LealConstants.lt_Steps).document("Step\(s.stepNumber!)").setData([
				LealConstants.lps_stepNumber: s.stepNumber ?? "",
				LealConstants.lps_requiredPoints: "\(pointsPer)",
				LealConstants.lps_rewardName: s.rewardName ?? "",
				LealConstants.lps_rewardDescription: s.rewardDescription ?? "",
				"value" : s.value ?? "",
				"step_image": ""
			])
		}
		
	}
	
	func initializeBlank() {
		LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).setData([
			LealConstants.toolName: LealConstants.tn_loyaltyProgram,
			LealConstants.viewIdentifier: LealConstants.ti_loyaltyProgram,
			LealConstants.lt_numberOfSteps: "1",
			LealConstants.lt_pointsPerStep: "10",
			LealConstants.logoName: "loyalty_icon",
			LealConstants.backgroundColor: ""
		])
		
		LealConstants.BusinessToolsRef.document(LealConstants.LoyaltyProgram).collection(LealConstants.lt_Steps).document("Step1").setData([
			LealConstants.lps_stepNumber: "1",
			LealConstants.lps_requiredPoints: "0",
			LealConstants.lps_rewardName: "Step 1",
			LealConstants.lps_rewardDescription: "",
			"value" :"0",
			"step_image": ""
		])
	}
	
}
