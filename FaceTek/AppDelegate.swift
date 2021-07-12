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
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let gcmMessageIDKey = "gcm.Message_ID"
	
	var firebasePushnotificationtoken : String? // This is not optional.



	
	var recognitionViewController: RecognitionViewController?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		
		// Use Firebase library to configure APIs
		if #available(iOS 10.0, *) {
		  // For iOS 10 display notification (sent via APNS)
		  UNUserNotificationCenter.current().delegate = self

		  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		  UNUserNotificationCenter.current().requestAuthorization(
			options: authOptions,
			completionHandler: { _, _ in }
		  )
		} else {
		  let settings: UIUserNotificationSettings =
			UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
		  application.registerUserNotificationSettings(settings)
		}

		application.registerForRemoteNotifications()

		Messaging.messaging().delegate = self

		FirebaseApp.configure()
		
		
		
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

//
//				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//				let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
//				//self.present(tabBarController, animated:true, completion:nil)
//				self.window?.rootViewController = tabBarController
//				self.window?.makeKeyAndVisible()

				
				
				
				
			} else if (name == "Coding Explorer" && is_authenticated != nil) {
				//already registered user
				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
				//self.present(tabBarController, animated:true, completion:nil)
				self.window?.rootViewController = tabBarController
				self.window?.makeKeyAndVisible()
			} else {
				print("normal")
			}
		}
		return true
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
	
	func application(_ application: UIApplication,
					 didReceiveRemoteNotification userInfo: [AnyHashable: Any],
					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
					   -> Void) {
	  // If you are receiving a notification message while your app is in the background,
	  // this callback will not be fired till the user taps on the notification launching the application.
	  // TODO: Handle data of notification

	  // With swizzling disabled you must let Messaging know about the message, for Analytics
	  // Messaging.messaging().appDidReceiveMessage(userInfo)

	  // Print message ID.
	  if let messageID = userInfo[gcmMessageIDKey] {
		print("Message ID: \(messageID)")
	  }

	  // Print full message.
	  print(userInfo)

	  completionHandler(UIBackgroundFetchResult.newData)
	}

	
}

extension AppDelegate:MessagingDelegate
{
	func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String?) {
	  print("Firebase registration token: \(String(describing: fcmToken))")

		firebasePushnotificationtoken = ("\(fcmToken ?? "")")
		//print(temp1) // "I am a programer"
		
		print("fire","\(firebasePushnotificationtoken ?? "")")

		
		firebasePushnotificationtoken = ("\(fcmToken ?? "")")
		//print("firebasetoken",firebasePushnotificationtoken as Any)
		UserDefaults.standard.set(firebasePushnotificationtoken, forKey: "firebasetokenkey")

	  let dataDict: [String: String] = ["token": fcmToken ?? ""]
	  NotificationCenter.default.post(
		name: Notification.Name("FCMToken"),
		object: nil,
		userInfo: dataDict
	  )
	  // TODO: If necessary send token to application server.
	  // Note: This callback is fired at each app startup and whenever a new token is generated.
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

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
							  willPresent notification: UNNotification,
							  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
								-> Void) {
	let userInfo = notification.request.content.userInfo

	// With swizzling disabled you must let Messaging know about the message, for Analytics
	// Messaging.messaging().appDidReceiveMessage(userInfo)

	// ...

	// Print full message.
	print(userInfo)

	// Change this to your preferred presentation option
	completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
							  didReceive response: UNNotificationResponse,
							  withCompletionHandler completionHandler: @escaping () -> Void) {
	let userInfo = response.notification.request.content.userInfo

	// ...

	// With swizzling disabled you must let Messaging know about the message, for Analytics
	// Messaging.messaging().appDidReceiveMessage(userInfo)

	// Print full message.
	print(userInfo)

	completionHandler()
  }
}
