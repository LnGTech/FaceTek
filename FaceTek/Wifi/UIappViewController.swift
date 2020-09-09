//
//  UIappViewController.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import UIKit

class UIappViewController: UIViewController, ReachabilityObserverDelegate{
	
	fileprivate var internetConnectionViewController : UIViewController? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	//MARK: Lifecycle
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		try? addReachabilityObserver()
	}
	
	deinit {
		removeReachabilityObserver()
	}
	
	//MARK: Reachability
	
	func reachabilityChanged(_ isReachable: Bool) {
		if !isReachable {
			goToInternetConnectionScreen()
		} else {
			dismissInternetConnectionScreen()
		}
	}
	
	private func goToInternetConnectionScreen() {
		if internetConnectionViewController == nil {
			let storyboard = UIStoryboard.init(name: "InternetConnection", bundle: nil)
			internetConnectionViewController = storyboard.instantiateInitialViewController()
		}
		
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate?.window?.addSubview((internetConnectionViewController?.view)!)
	}
	
	private func dismissInternetConnectionScreen() {
		if (internetConnectionViewController != nil) {
			internetConnectionViewController?.view.removeFromSuperview()
			internetConnectionViewController = nil
		}
	}
}
