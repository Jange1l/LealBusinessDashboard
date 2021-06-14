//
//  Utilities.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 1/4/21.
//

import Foundation

class Utilities {
	
	static func isPasswordValid(_ password : String) -> Bool {
		
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{5,}")
		return passwordTest.evaluate(with: password)
	}
}
