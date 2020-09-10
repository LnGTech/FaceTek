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

    static let baseURL = URL(string: "http://122.166.152.106:8080")!
    
}

class Baseurl {

    // MARK: - Properties
    private static var sharedNetworkManager: Baseurl = {
        let networkManager = Baseurl(baseURL: API.baseURL)

        // Configuration
        // ...
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
