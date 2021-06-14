//
//  ScannerNetworking.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 2/27/21.
//

import Foundation


class ScannerNetworking {
	
	func giveCustomerPoints(customerUid: String, points: String) {
		
		LealConstants.CustomersRef.document(customerUid).collection("LoyaltyPrograms").document(AccountDetails().getUid()).getDocument(completion: {(document, err) in
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				
			} else {
				
				if let document = document, document.exists {
					
					let data = document.data()
					let currentPoints = Double(data!["customerPoints"] as! String)!
					let currentStep = Double(data!["currentStep"] as! String)!
					let pointsPerStep = Double(data!["pointsPerStep"] as! String)!
					let totalSteps = Double(data!["numberOfSteps"] as! String)!
					var timesScanned = Double(data!["timesScanned"] as! String)!
					
					let newPoints = currentPoints + Double(points)!
					
					
					timesScanned += 1
					
					if newPoints >= pointsPerStep {
						
						// Increase current step
						
						var stepsMoved = newPoints / pointsPerStep
						stepsMoved.round(.towardZero)
						stepsMoved += currentStep
						
						self.earnedRewards(customerUid: customerUid, currentStep: Int(currentStep), stepsMoved: Int(stepsMoved), totalSteps: Int(totalSteps))
						
						if stepsMoved > totalSteps {
							stepsMoved = stepsMoved.truncatingRemainder(dividingBy: totalSteps)
							if stepsMoved == 0 {
								stepsMoved = 1
							}
						}
						let remainingPoints = String(newPoints.truncatingRemainder(dividingBy: pointsPerStep)).prefix(5)
						
						
						
						LealConstants.CustomersRef.document(customerUid).collection("LoyaltyPrograms").document(AccountDetails().getUid()).updateData(
							[
								"customerPoints" : "\(remainingPoints)",
								"currentStep" : "\(Int(stepsMoved))",
								"timesScanned" : "\(Int(timesScanned))"
							])
						
						
					} else {
						LealConstants.CustomersRef.document(customerUid).collection("LoyaltyPrograms").document(AccountDetails().getUid()).updateData(
							[
								"customerPoints" : "\(newPoints)",
							])
					}
					
				}
				
			}
			
		})
		
	}
	
	func earnedRewards(customerUid: String, currentStep: Int, stepsMoved: Int, totalSteps: Int) {
		
		var rewards = [Int]()
		var earned = [Int]()
		
		for s in 1...totalSteps {
			rewards.append(s)
		}
		print(rewards, currentStep, stepsMoved)
		for m in currentStep...(stepsMoved) - 1 {
			var index = (m % totalSteps) - 1
			print(index)
			if index == -1 {
				index = rewards.count - 1
			}
			print(index)
			earned.append(rewards[index])
		}
		
		for reward in earned {
			
			let rewardId = "\(UUID().uuidString)"
			
			LealConstants.CustomersRef.document(customerUid).collection("EarnedRewards").document(rewardId).setData(
				[
					"rewardNumber" : "\(reward)",
					"businessUid" : "\(AccountDetails().getUid())",
					"rewardId" : "\(rewardId)",
					"businessName": "\(AccountDetails().getBusinessName())"
				])
		}
	}
	
	func claimReward(customerUid: String, rewardId: String) {
		// Get value of reward
		
		// Get Customer current totalSaved value
		
		// add new amount
		
		// delete earned reward
		LealConstants.CustomersRef.document(customerUid).collection("EarnedRewards").document(rewardId).delete(){ err in
			if let err = err {
				print("Error writing document: \(err)")
			} else {
				print("Document successfully written!")
				
			}
		}
		
		
	}
	
	func claimPromo(customerUid: String, rewardId: String) {
		
		
		LealConstants.CustomersRef.document(customerUid).collection("Wallet").document(rewardId).delete(){ err in
			if let err = err {
				print("Error writing document: \(err)")
			} else {
				print("Document successfully written!")
				
			}
		}
		
		// Decrease Count
		
		LealConstants.DiscountsRef.document(rewardId).getDocument(completion: {(document, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				
			} else {
				
				if let document = document, document.exists {
					
					let data = document.data()
					
					let quantity = data!["quantity"] as! String
					var count = Int(quantity)!
					count -= 1
					if count <= 0 {
						// Delete the document
						LealConstants.DiscountsRef.document(rewardId).delete()
					} else {
						//Decrease quantity number
						
						LealConstants.DiscountsRef.document(rewardId).updateData(
							[
								"quantity" : "\(count)"
							])
					}
					
					
					
					
				}
			}
		})
		
	}
	
	func getCustomerData(customerUid: String, completion: @escaping (Bool, ModelStructures.Follower) -> ()) {
		LealConstants.CustomersRef.document(customerUid).getDocument(completion: {(snap, err) in
			
			var customer = ModelStructures.Follower(customerName: "", customerUid: "", customerNotifToken: "", businessName: "", businessUid: "")
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				
			} else {
				
				
				if let document = snap, document.exists {
					
					let data = document.data()
					
					customer.customerName = data!["Name"] as! String
				}
			}
			completion(true, customer)
		})
	}
	
}
