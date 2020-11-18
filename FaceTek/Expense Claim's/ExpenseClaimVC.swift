//
//  ExpenseClaimVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseClaimVC: UIViewController {
	
	@IBOutlet weak var SelectedDateLbl: UILabel!
	
	var Currentdatestr : String = ""
	var SelectedDatestr : String = ""


	@IBOutlet weak var DateView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		Currentdatestr = dateFormatter.string(from: today)
		SelectedDateLbl.text = Currentdatestr
		
		DateView.layer.borderWidth = 1
		DateView.layer.borderColor = UIColor.lightGray.cgColor
		
				let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.DateselectedViewAction))
		self.DateView.addGestureRecognizer(gesture)



        // Do any additional setup after loading the view.
    }
    
	@objc func DateselectedViewAction(sender : UITapGestureRecognizer) {
		print("Selected date...")
		AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

			   AKMonthYearPickerView.sharedInstance.previousYear = 4
			   
			   AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
	}


	
	@IBAction func Btnclk(_ sender: Any) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		
		
		let ExpensesClaimFormVC = storyBoard.instantiateViewController(withIdentifier: "ExpensesClaimFormVC") as! ExpensesClaimFormVC
		self.present(ExpensesClaimFormVC, animated:true, completion:nil)
        
		
		
	}
	
	private func doneHandler() {
		
				print("Month picker Done button action")
		//selected_date_DoneMethod()
    }
    
	
    private func completetionalHandler(month: Int, year: Int) {
        print( "month = ", month, " year = ", year )
		var Monthstr = String(month)
		var Yearstr = String(year)
		var Datestr = "1"

		SelectedDatestr = Yearstr + "-" + Monthstr + "-" + Datestr
		
		print("SelectedDatestr....",SelectedDatestr)
    }
	
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
	
}
