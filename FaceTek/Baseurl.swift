//
//  Baseurl.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/10/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import Foundation

enum API {
	//Development IP Address Value
	static let baseURL = URL(string: "http://122.166.248.191:8080")!
	//Production IP Address Value
	//static let baseURL = URL(string: "http://52.183.137.54:8080")!
}

class Baseurl {

    // MARK: - Properties
    private static var sharedNetworkManager: Baseurl = {
        let networkManager = Baseurl(baseURL: API.baseURL)

        return networkManager
    }()

    // MARK: -
    let baseURL: URL

    // Initialization
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
	
	class func shared() -> Baseurl {
		return sharedNetworkManager
	}
}
