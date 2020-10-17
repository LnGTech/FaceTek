//
//  AppDelegate.swift
//  Lux
//
//  Created by sureshbabu bandaru on 7/1/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var recognitionViewController: RecognitionViewController?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		//if (@available(iOS 13, *))
			if #available(iOS 13.0, *) {
		
			let statusBar1 =  UIView()
			statusBar1.frame = UIApplication.shared.statusBarFrame
			statusBar1.backgroundColor = UIColor.red
			UIApplication.shared.keyWindow?.addSubview(statusBar1)
		}
		
		//Google map key
		GMSServices.provideAPIKey("AIzaSyCA5zQA-tWuaGYyhrAr9H1e2rMOT3sI7Ac")
		
		var res: Int32 = FSDK_ActivateLibrary(("b7m7wdOIT2vkmcvu12eJLBfk8/AEh1/yvKQcBlJGC/Xo+xLXTMCWNgrQyFymEncTzrJpDI9r+D4Usr53ZtI3fujgnIVbNbZsQ+1n3U+72C1NV0HvWH+TO1PA4IbhCnLu9JgkHidDVDgauLGtzWqjS+jls7LMSNNquMKuCn7hw8k=" as NSString).utf8String)
		
		NSLog("activation result: %d", res);
		if (res != FSDKE_OK) {
			exit(res);
		}
		
		res = FSDK_Initialize(nil);
		NSLog("initialization result: %d", res);
		
		//window = UIWindow.init(frame: UIScreen.main.bounds)
		//		window?.backgroundColor = UIColor.black
		//		window?.autoresizesSubviews = true
		//		window?.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		//		recognitionViewController = RecognitionViewController(screen: UIScreen.main)
		//		window?.rootViewController = recognitionViewController
		//		window?.makeKeyAndVisible()
		//		window?.layoutSubviews()
		
		//		if let statusBar = UIStatusBarStyle.self as? UIView {
		//			if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
		//				statusBar.backgroundColor = UIColor.red
		//			}
		//		}
		
		let defaults = UserDefaults.standard
		let is_authenticated = defaults.string(forKey: "RetrivedFaceid") // return false if not found or stored value
		
		if let name = defaults.string(forKey: "userNameKey") {
			print("nsuserdefault----",name)
			if (name == "Coding Explorer" && is_authenticated == nil) {
				//new user
				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let RegistrationVC = storyBoard.instantiateViewController(withIdentifier: "RegistrationVC")
				let navVC = UINavigationController.init(rootViewController: RegistrationVC)
				navVC.navigationBar.isHidden = true
				self.window?.rootViewController = navVC
				self.window?.makeKeyAndVisible()
			} else if (name == "Coding Explorer" && is_authenticated != nil) {
				//already registered user
				
				//Add local authentication to pass through Apple Review Guidelines
				//Guideline 2.5.13 - Performance - Software Requirements
				//https://developer.apple.com/app-store/review/guidelines/#performance
				
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
								self.localAuthFailed()
							}
						}
					}
				} else {
					// Fall back to a asking for username and password.
					// Device doesn't have face ID and touch ID
					self.goToHomeScreen()
				}
				
				
			} else {
				print("normal")
			}
		}
		return true
	}
	
	private func goToHomeScreen() {
		//successfully loggedin/authenticated
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
		//self.present(tabBarController, animated:true, completion:nil)
		self.window?.rootViewController = tabBarController
		self.window?.makeKeyAndVisible()
	}
	
	private func localAuthFailed() {
		let storyBoard : UIStoryboard = UIStoryboard(name: "LocalAuthFailed", bundle:nil)
		let viewController = storyBoard.instantiateInitialViewController()
		self.window?.rootViewController = viewController
		self.window?.makeKeyAndVisible()
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "Lux")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}

extension UIApplication {
	var statusBarView: UIView? {
		if responds(to: Selector(("statusBar"))) {
			return value(forKey: "statusBar") as? UIView
		}
		return nil
	}
}
