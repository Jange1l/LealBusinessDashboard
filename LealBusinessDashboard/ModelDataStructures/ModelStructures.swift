//
//  LoyaltyProgram.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/4/21.
//

import Foundation
import UIKit

struct ModelStructures {
	
	struct LPStep: Equatable {
		var stepNumber: String!
		var requiredPoints: String!
		var rewardName: String!
		var rewardDescription: String!
		var value: String!
	}
	
	struct LoyaltyProgram {
		var businessName: String!
		var numberOfSteps: String!
		var pointsPerStep: String!
		var steps: [LPStep]
	}
	
	struct CreatePromotion {
		
	}
	
	struct DashBoardFeatureStructure {
		var viewControllerIdentifier: String
		var name: String
		var logo: String
		var color: String
	}
	
	struct Follower {
		var customerName: String
		var customerUid: String
		var customerNotifToken: String
		var businessName: String
		var businessUid: String
		
	}
	struct AccountDetails {
		var businessName: String
		var businessEmail: String
		var businessPhoneNumber: String
		var profileImageUrl: String
		var businessType: String
		var businessBio: String
		var promotionsPostedCount: String
		var followersCount: String
		
		var uid: String
	}
	
	struct Discount {
		var businessName: String
		var discount: String
		var timeReleased: String
		var duration: String
		var endDate: String
		var description: String
		var quantity: String
		var profileUrl: String
		var profileImage: UIImage
		var uid: String
		var postUid: String
		var type: String
	}
}

