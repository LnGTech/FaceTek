//
//  MyTeamVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class MyTeamVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		//let statusBarColor = UIColor(red: 32/255, green: 149/255, blue: 215/255, alpha: 1.0)
		
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		
    }
    
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
