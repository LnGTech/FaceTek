//
//  ExpensesClaimFormVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

extension UIViewController {
func ExpenseClaimdismissKey()
{
let dismisstap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.ExpenseClaimdismissKeyboard))
dismisstap.cancelsTouchesInView = false
view.addGestureRecognizer(dismisstap)
}
@objc func ExpenseClaimdismissKeyboard()
{
view.endEditing(true)
}
}




class ExpensesClaimFormVC: UIViewController,UITextViewDelegate {
	
	@IBOutlet weak var ExpenseClaimTextview: UITextView!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		ExpenseClaimdismissKey()

		//Textview Place holder code
		
		ExpenseClaimTextview.delegate = self
		ExpenseClaimTextview.text = "Remarks (Optional)"
		ExpenseClaimTextview.textColor = UIColor.lightGray
		
    }
	func textViewDidBeginEditing(_ textView: UITextView) {

		if ExpenseClaimTextview.textColor == UIColor.lightGray {
			ExpenseClaimTextview.text = ""
			ExpenseClaimTextview.textColor = UIColor.black
		}
	}
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
