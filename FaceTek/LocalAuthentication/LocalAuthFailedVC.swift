//
//  LocalAuthFailedVC.swift
//  FaceTek
//
//  Created by Gudisi, Manjunath on 17/10/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class LocalAuthFailedVC : UIViewController {
	
	@IBAction func tryAgain(_ sender: Any) {
		localAuthentication()
	}
	
	private func localAuthentication() {
		let context = LAContext()
		context.localizedCancelTitle = "Enter Username/Password"
		var error: NSError? = nil
		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			let reason = "Log in to your account"
			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

				if success {
					// Move to the main thread because a state update triggers UI changes.
					DispatchQueue.main.async { [unowned self] in
						//successfully loggedin/authenticated
						self.goToHomeScreen()
					}

				} else {
					print(error?.localizedDescription ?? "Failed to authenticate")
					// Fall back to a asking for username and password.
					
					DispatchQueue.main.async {
						let alertController = UIAlertController(title: "Error",
																message: error?.localizedDescription ?? "Failed to authenticate",
																preferredStyle: .alert)
						alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
							//some code
						})
						
						self.present(alertController, animated: true)
					}
				}
			}
		} else {
			// Fall back to a asking for username and password.
			// Device doesn't have face ID and touch ID
			self.goToHomeScreen()
		}
	}
	
	private func goToHomeScreen() {
		//successfully loggedin/authenticated
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate!.window?.rootViewController = tabBarController
		appDelegate!.window?.makeKeyAndVisible()
	}
}
