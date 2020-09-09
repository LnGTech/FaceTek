//
//  AppManager.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import UIKit
import Foundation

class AppManager: NSObject{

	fileprivate var _useClosures:Bool = false
	fileprivate var _isReachability:Bool = false
	
	var isReachability:Bool {
		get {return _isReachability}
	}
	
	// Create a shared instance of AppManager
	final  class var sharedInstance : AppManager {
		struct Static {
			static var instance : AppManager?
		}
		
		if !(Static.instance != nil) {
			Static.instance = AppManager()
		}
		
		return Static.instance!
	}
}
