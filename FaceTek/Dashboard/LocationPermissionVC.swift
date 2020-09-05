//
//  LocationPermissionVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/31/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionVC: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var Allowbtnn: UIButton!
	var locationManager: CLLocationManager?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Allowbtnn.layer.cornerRadius = 10
		Allowbtnn.clipsToBounds = true
		
		// Do any additional setup after loading the view.
	}
	
	@IBAction func AllowBtn(_ sender: Any) {
		
		if locationManager == nil {
			locationManager = CLLocationManager()
			locationManager?.delegate = self
			locationManager?.requestWhenInUseAuthorization()
		} else {
			showLocationAlert()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			self.navigationController?.popViewController(animated: true)
		} else {
			DispatchQueue.main.async {
				self.showLocationAlert()
			}
		}
	}
	
	private func showLocationAlert() {
		let alert = UIAlertController.init(title: "Location access is mandatory",
										   message: "Please allow location permission to proceed further",
										   preferredStyle: .alert)
		let okAction = UIAlertAction.init(title: "OK", style: .default) { (alertAction) in
			//some code
		}
		alert.addAction(okAction)
		alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
			if let url = URL(string: UIApplicationOpenSettingsURLString) {
				UIApplication.shared.open(url, options: [:], completionHandler: { _ in
					// Handle
				})
			}
		})
		
		self.present(alert, animated: true) {
			//some code
		}
	}
	
}
