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

class LocalAuthentication : NSObject {
	static func check(from viewController: UIViewController, reply: @escaping (Bool, Error?) -> Void) {
		let context = LAContext()
		context.localizedCancelTitle = "Enter Username/Password"
		var error: NSError? = nil
		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			let reason = "Log in to your account"
			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
				DispatchQueue.main.async {
					if success == false {
						DispatchQueue.main.async {
							let alertController = UIAlertController(title: "Error",
																	message: error?.localizedDescription ?? "Failed to authenticate",
																	preferredStyle: .alert)
							alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
								//some code
							})
							
							viewController.present(alertController, animated: true)
						}
					}
					reply(success, error)
				}
			}
		} else {
			DispatchQueue.main.async {
				reply(true, error)
			}
		}
	}
}

class LocalAuthFailedVC : UIViewController {
	
	@IBAction func tryAgain(_ sender: Any) {
		localAuthentication()
	}
	
	private func localAuthentication() {
		LocalAuthentication.check(from: self) { (success, error) in
			if success == true {
				self.goToHomeScreen()
			}
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
