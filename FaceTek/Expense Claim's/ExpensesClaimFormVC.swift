//
//  ExpensesClaimFormVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpensesClaimFormVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)

        // Do any additional setup after loading the view.
    }
    
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
