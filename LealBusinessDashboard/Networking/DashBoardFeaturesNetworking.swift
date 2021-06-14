//
//  DashBoardFeaturesNetworking.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/4/21.
//

import Foundation
import Firebase

public class DashBoardFeaturesNetworking {
	
	func getAvailableAccountTools(completion: @escaping (Bool, [ModelStructures.DashBoardFeatureStructure]) -> ()) {
		
		var tools = [ModelStructures.DashBoardFeatureStructure]()
		
		LealConstants.BusinessToolsRef.getDocuments() { (querySnapshot, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false,tools)
			} else {
				
				for document in querySnapshot!.documents {
					let viewIdentifier = document[LealConstants.viewIdentifier] as! String
					let toolName = document[LealConstants.toolName] as! String
					
					let logo = document[LealConstants.logoName] as! String
					
					let backgroundColor = document[LealConstants.backgroundColor] as! String
					
					let feature = ModelStructures.DashBoardFeatureStructure(viewControllerIdentifier: viewIdentifier, name: toolName, logo: logo, color: backgroundColor)
					tools.append(feature)
				}
			}
			completion(true, tools)
		}
	}
	
	
	
}
