//
//  ExpenseClaimViewmoreVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 11/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseClaimViewmoreVC: UIViewController, UITextViewDelegate {
	
	
	@IBOutlet weak var ExpenseDetailsLbl: UILabel!
	
	@IBOutlet weak var ClaimRemarksLbl: UILabel!
	
	@IBOutlet weak var ClaimRejectionLbl: UILabel!
	
	@IBOutlet weak var ClaimRemarkstxtview: UITextView!
	
	
	@IBOutlet weak var ClaimRejectiontxtview: UITextView!
	
	var empExpClaimRemarks : String = ""
	var empExpClaimRejectionRemarks : String = ""

	

	override func viewDidLoad() {
        super.viewDidLoad()
		
		//UI Label borders
//		ClaimRemarksLbl.layer.borderWidth = 1
//		ClaimRemarksLbl.layer.borderColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
//		ClaimRejectionLbl.layer.borderWidth = 1
//		ClaimRejectionLbl.layer.borderColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRemarkstxtview.layer.borderWidth = 1
		ClaimRemarkstxtview.layer.borderColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRejectiontxtview.layer.borderWidth = 1
		ClaimRejectiontxtview.layer.borderColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)


		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		let ExpenseClaimtitleLblattributes :Dictionary = [NSAttributedStringKey.font : ExpenseDetailsLbl.font]
		ExpenseDetailsLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		ExpenseDetailsLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)!
		ClaimRemarkstxtview.delegate = self
		ClaimRemarkstxtview.text = "Claim Remarks"
		ClaimRemarkstxtview.textColor = UIColor.lightGray
		
		ClaimRejectiontxtview.delegate = self
		ClaimRejectiontxtview.text = "Claim Rejection Remarks"
		ClaimRejectiontxtview.textColor = UIColor.lightGray
		
		
		let defaults = UserDefaults.standard
		empExpClaimRemarks = defaults.string(forKey: "empExpClaimRemarks") ?? ""
		print("stored value",empExpClaimRemarks)
		empExpClaimRejectionRemarks = defaults.string(forKey: "empExpClaimRejectionRemarks") ?? ""
		print("stored value empExpClaimRejectionRemarks",empExpClaimRejectionRemarks)


		

		
		let ClaimRemarksLblattributes :Dictionary = [NSAttributedStringKey.font : ClaimRemarksLbl.font]
		ClaimRemarksLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRemarksLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		
		let ClaimRejectionLblattributes :Dictionary = [NSAttributedStringKey.font : ClaimRejectionLbl.font]
		ClaimRejectionLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRejectionLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!

		ClaimRemarkstxtview.text = "Claim Remarks"
        ClaimRemarkstxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRemarkstxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!

        ClaimRejectiontxtview.delegate = self
		ClaimRejectiontxtview.text = "Claim Rejection Remarks"
        ClaimRejectiontxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ClaimRejectiontxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!

        ClaimRejectiontxtview.delegate = self

		
		ClaimRemarkstxtview.text = empExpClaimRemarks
		ClaimRejectiontxtview.text = empExpClaimRejectionRemarks


        // Do any additional setup after loading the view.
    }
	
	func textViewDidBeginEditing(_ textView: UITextView) {
        if ClaimRemarkstxtview.text == "Claim Remarks" {
            ClaimRemarkstxtview.text = ""
            ClaimRemarkstxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ClaimRemarkstxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }
		
		if ClaimRejectiontxtview.text == "Claim rejection Remarks" {
            ClaimRejectiontxtview.text = ""
            ClaimRejectiontxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ClaimRejectiontxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            ClaimRemarkstxtview.resignFirstResponder()
        }
		if text == "\n" {
            ClaimRejectiontxtview.resignFirstResponder()
        }
		
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if ClaimRemarkstxtview.text == "" {
            ClaimRemarkstxtview.text = "Claim Remarks"
            ClaimRemarkstxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ClaimRemarkstxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }
		if ClaimRejectiontxtview.text == "" {
            ClaimRejectiontxtview.text = "Claim Rejection Remarks"
            ClaimRejectiontxtview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ClaimRejectiontxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }

    }
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)

		
	}
	

}
