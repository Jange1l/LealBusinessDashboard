//
//  DashBoardFeatures.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/25/20.
//

import Foundation


public class DashBoardFeatures {
	
	var features = [ModelStructures.DashBoardFeatureStructure]()
	let networking: DashBoardFeaturesNetworking!
	
	init() {
		networking = DashBoardFeaturesNetworking()
	}
	
	
	func addFeature(_ featureName: String, _ featureIdentifier: String, _ logo: String, _ color: String) {
		let additionalFeature = ModelStructures.DashBoardFeatureStructure(viewControllerIdentifier: featureIdentifier, name: featureName, logo: logo, color: color)
		
		features.append(additionalFeature)
 	}
	
	func getCurrentFeatures(completion: @escaping (Bool) -> ()) {
		networking.getAvailableAccountTools(completion: { (status, tools) in
			for feature in tools {
				self.addFeature(feature.name, feature.viewControllerIdentifier, feature.logo, feature.color)
			}
			AccountDetails().setAvailableFeaturesList(namesList: self.features)
			completion(true)
		})
	}
	
	
}
