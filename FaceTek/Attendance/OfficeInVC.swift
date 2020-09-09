//
//  OfficeInVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/7/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension


class OfficeInVC: UIViewController {
	
	//let hotspotConfig = NEHotspotConfiguration(ssid: "mounika")//Unsecured connections
	//OR
	let hotspotConfig = NEHotspotConfiguration(ssid: "mounika", passphrase: "12345678", isWEP: false)//Secured connections
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if(AppManager.sharedInstance.isReachability)
		{
			print("network available")
			//self.networkStatusLabel.text = "Network Available"
			//call API from here.
			
		} else {
			DispatchQueue.main.async {
				//self.networkStatusLabel.text = "Network Unavailable"
				print("Network Unavailable")
				//Show Alert
			}
		}
		
		
		//
		//        let configuration = NEHotspotConfiguration.init(ssid: "SSIDname", passphrase: "Password", isWEP: false)
		//        configuration.joinOnce = true
		//
		//        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
		//            if error != nil {
		//                if error?.localizedDescription == "already associated."
		//                {
		//                    print("Connected")
		//                }
		//                else{
		//                    print("No Connected")
		//                }
		//            }
		//            else {
		//                print("Connected")
		//            }
		//        }
		
		// Do any additional setup after loading the view.
	}
	
	
	
	
	@IBAction func RetrySignInVC(_ sender: Any) {
		
		
		//manager.delegate = self
		
		if(AppManager.sharedInstance.isReachability)
		{
			print("network available")
			
			//self.networkStatusLabel.text = "Network Available"
			//call API from here.
			
		} else {
			DispatchQueue.main.async {
				//self.networkStatusLabel.text = "Network Unavailable"
				print("Network Unavailable")
				//Show Alert
			}
		}
		
		
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
