//
//  InternetConnection.swift
//  FaceTek
//
//  Created by Gudisi, Manjunath on 09/09/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import Foundation
import UIKit

class InternetConnection: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func openWifiSettings(_ sender: Any) {
		if let url = URL(string: UIApplicationOpenSettingsURLString) {
			UIApplication.shared.open(url, options: [:], completionHandler: { _ in
				// Handle
			})
		}
	}
}
