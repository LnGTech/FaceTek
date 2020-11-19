//
//  ExpenseClaimVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseClaimVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	var ExpenseHistoryData = NSMutableDictionary()
    var marLeavesData = NSMutableArray()

	@IBOutlet weak var NoDatafoundview: UIView!
	var ExpensetblArray:NSMutableArray = NSMutableArray()

    var MainDict:NSMutableDictionary = NSMutableDictionary()

	@IBOutlet weak var SelectedDateLbl: UILabel!
	
	var Currentdatestr : String = ""
	var SelectedDatestr : String = ""
	
	@IBOutlet weak var Expensetbl: UITableView!
	@IBOutlet weak var DateView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.Expensetbl.isHidden = true

		self.Expensetbl.rowHeight = 240.0

		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		Currentdatestr = dateFormatter.string(from: today)
		SelectedDateLbl.text = Currentdatestr
		
		Expensetbl.register(UINib(nibName: "ExpenseHeadercell", bundle: nil), forCellReuseIdentifier: "ExpenseHeadercell")

		Expensetbl.register(UINib(nibName: "Expensecell", bundle: nil), forCellReuseIdentifier: "Expensecell")

		DateView.layer.borderWidth = 1
		DateView.layer.borderColor = UIColor.lightGray.cgColor
		
				let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.DateselectedViewAction))
		self.DateView.addGestureRecognizer(gesture)


ExpenseClaimAPI_Integration()
        // Do any additional setup after loading the view.
    }
    
	@objc func DateselectedViewAction(sender : UITapGestureRecognizer) {
		print("Selected date...")
		AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

			   AKMonthYearPickerView.sharedInstance.previousYear = 4
			   
			   AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
	}


	func ExpenseClaimAPI_Integration()
		{
			print("Expense Proceed------")
		   
			let defaults = UserDefaults.standard
			
			var RetrivedempId = defaults.integer(forKey: "empId")
			print(" RetrivedempId----",RetrivedempId)
			var RetrivedcustId = defaults.integer(forKey: "custId")
			print(" RetrivedcustId----",RetrivedcustId)
			
			//let parameters = ["empId": RetrivedempId as Any, "monthYear": Currentdatestr as Any] as [String : Any]
			
			let parameters = ["refCustId": RetrivedcustId as Any, "refEmpId": RetrivedempId as Any , "empExpClaimDate": Currentdatestr as Any] as [String : Any]

			
			//let parameters = ["empId": 358 as Any, "monthYear": "2020-11-1" as Any] as [String : Any]

			
			let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd"
					let myDate = dateFormatter.date(from: Currentdatestr)!

					dateFormatter.dateFormat = "MMM yyyy"
					let Convertdate = dateFormatter.string(from: myDate)
					print("Convertdate",Convertdate)
					SelectedDateLbl.text = Convertdate
					
					var StartPoint = Baseurl.shared().baseURL
					var Endpoint = "/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/getEmpExpenseClaimMob"

					let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!

					//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/getEmpExpenseClaimMob")!
					//http://122.166.152.106:8080/serenityuat/inmatesignup/validateMobileNo
					//create the session object
					let session = URLSession.shared
							//now create the URLRequest object using the url object
							var request = URLRequest(url: url as URL)
							request.httpMethod = "POST" //set http method as POST
							do {
								request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
							} catch let error {
								print(error.localizedDescription)
							}
							request.addValue("application/json", forHTTPHeaderField: "Content-Type")
							request.addValue("application/json", forHTTPHeaderField: "Accept")
							//create dataTask using the ses
							//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
							let task = URLSession.shared.dataTask(with: request) { data, response, error in
								guard let data = data, error == nil else {
									print(error?.localizedDescription ?? "No data")
									return
								}
								let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
								if let responseJSON = responseJSON as? [String: Any] {
									print("Leave History Json Response",responseJSON)
									DispatchQueue.main.async {
								 if let absentShiftDetailsid = responseJSON["expenseClaimDto"] as? NSNull {
								
							 print("null values printed.....")
									self.NoDatafoundview.isHidden = false

					//             self.NoLeavesView.isHidden = false
					            self.Expensetbl.isHidden = true
															}
								else
								{
									self.Expensetbl.isHidden = false

							print("Normal values printed....")
							}
									
										}
										 self.ExpenseHistoryData = NSMutableDictionary()
										if responseJSON != nil{
											self.ExpenseHistoryData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
										}
									
									DispatchQueue.main.async {
										self.Expensetbl.reloadData()
									}
									}
								}
							
							task.resume()
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
			if ExpenseHistoryData.allKeys.count > 0{
				if let temp = ExpenseHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
					return temp.count
				}
				return 0
			}
			return 0
		}
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			if  ExpenseHistoryData.allKeys.count > 0{
				var arrSectionsData = NSArray()
				if let temp = ExpenseHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
					arrSectionsData = temp
				}
				if arrSectionsData.count > 0{
//					let dict = arrSectionsData.object(at: section) as? NSDictionary
//					if let temp = dict?.value(forKey: "empExpClaimAppRejById") as? Int{
					
					
					var temp = Int()
					

					temp = 1
					
						return temp
					}
					return 0
				}
				return 0
//			}
//			return 0
		}
		func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
			let headerCell = tableView.dequeueReusableCell(withIdentifier: "ExpenseHeadercell") as! ExpenseHeadercell
			var arrSectionsData = NSArray()
			if let temp = ExpenseHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
				arrSectionsData = temp
			}
			if arrSectionsData.count > 0{
				let dict = arrSectionsData.object(at: section) as? NSDictionary
				//headerCell.Leavestatusname.text = "Leave Status"
				headerCell.HeadercellBackVieew.layer.borderWidth = 1
				headerCell.HeadercellBackVieew.layer.borderColor = UIColor.lightGray.cgColor
				
			}
		   
			return headerCell
		}
		
		
		func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
			return 230
		}
		func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
			return 45
		}
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let Expensecell = tableView.dequeueReusableCell(withIdentifier: "Expensecell", for: indexPath) as! Expensecell
			 let arrLeaveHistory =  ExpenseHistoryData.value(forKey: "expenseClaimDto") as! NSArray
			print("arrLeaveHistory....",arrLeaveHistory)
			
			let ExpenseTypeDetails = arrLeaveHistory.object(at: indexPath.section) as? NSDictionary
			
			var empExpClaimDate = ""
			if let temp = ExpenseTypeDetails?.value(forKey: "empExpClaimDate") as? String{
				empExpClaimDate = String(temp)
				Expensecell.ClaimDateLbl.text = empExpClaimDate
							}

			
			var empExpDate = ""
			if let temp = ExpenseTypeDetails?.value(forKey: "empExpDate") as? String{
				empExpDate = String(temp)
				
				
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "dd-MM-YYYY"

				//dateFormatter.dateFormat = "yyyy-MM-dd"
				let myDate = dateFormatter.date(from: empExpDate)!

				//dateFormatter.dateFormat = "dd-MM-YYYY"
				dateFormatter.dateFormat = "YYYY-MM-dd"

				let Convertdate = dateFormatter.string(from: myDate)
				Expensecell.ExpenseDateLbl.text = Convertdate

				//Expensecell.ExpenseDateLbl.text = empExpDate
							}
			
			
			var ExpenseAmount = ""
			if let temp = ExpenseTypeDetails?.value(forKey: "empExpAmount") as? Int{
				ExpenseAmount = String(temp)
				var Rupeesymbolstr = "₹" + ExpenseAmount
				Expensecell.ExpenseAmtLbl.text = Rupeesymbolstr
							}

			var ExpenseApprovedAmt = ""
			if let temp = ExpenseTypeDetails?.value(forKey: "empExpApprovedAmount") as? Int{
				ExpenseApprovedAmt = String(temp)
				var Rupeesymbolstr = "₹" + ExpenseApprovedAmt

				Expensecell.ExpenseApprovedAmtLbl.text = Rupeesymbolstr

			}
			
			var empExpType = ""
			if let temp = ExpenseTypeDetails?.value(forKey: "empExpType") as? String{
				empExpType = temp
				print("empExpType...",empExpType)
				Expensecell.ExpenseTypeLbl.text = empExpType
				Expensecell.Viewmore_Btmview.layer.borderWidth = 1
				Expensecell.Viewmore_Btmview.layer.borderColor = UIColor.lightGray.cgColor
				
				Expensecell.ExpenseBackview.layer.borderWidth = 1
				Expensecell.ExpenseBackview.layer.borderColor = UIColor.lightGray.cgColor

				
			}
			
			
			return Expensecell
		}
		func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
			return 250;//Choose your custom row height
		}
	
	@IBAction func Btnclk(_ sender: Any) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		
		
		let ExpensesClaimFormVC = storyBoard.instantiateViewController(withIdentifier: "ExpensesClaimFormVC") as! ExpensesClaimFormVC
		self.present(ExpensesClaimFormVC, animated:true, completion:nil)
        
		
		
	}
	func selected_date_DoneMethod()
	{
			print("Leave Proceed------")
		   
			let defaults = UserDefaults.standard
			
			var RetrivedempId = defaults.integer(forKey: "empId")
			print(" RetrivedempId----",RetrivedempId)
			

			
			let parameters = ["empId": RetrivedempId as Any, "monthYear": SelectedDatestr as Any] as [String : Any]
		
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: SelectedDatestr)!

		dateFormatter.dateFormat = "MMM yyyy"
		let Convertdate = dateFormatter.string(from: myDate)
		print("Convertdate",Convertdate)
		SelectedDateLbl.text = Convertdate
		
		
			
			var StartPoint = Baseurl.shared().baseURL
			var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmployeeLeaveList"
			
			let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
			
			//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/setup/getAbsentEmployeeDetails")!
			//http://122.166.152.106:8080/serenityuat/inmatesignup/validateMobileNo
			//create the session object
			let session = URLSession.shared
			//now create the URLRequest object using the url object
			var request = URLRequest(url: url as URL)
			request.httpMethod = "POST" //set http method as POST
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
			} catch let error {
				print(error.localizedDescription)
			}
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")
			//create dataTask using the ses
			//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data, error == nil else {
					print(error?.localizedDescription ?? "No data")
					return
				}
				let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
				if let responseJSON = responseJSON as? [String: Any] {
					print("Leave History Json Response",responseJSON)
					DispatchQueue.main.async {
				 if let absentShiftDetailsid = responseJSON["empLeaveList"] as? NSNull {
				
			 print("null values printed.....")
					self.NoDatafoundview.isHidden = false

	//             self.NoLeavesView.isHidden = false
	//            self.Absenttbl.isHidden = true
											}
				else
				{
					self.Expensetbl.isHidden = true

			print("Normal values printed....")
			}
					
						}
						 self.ExpenseHistoryData = NSMutableDictionary()
						if responseJSON != nil{
							self.ExpenseHistoryData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
						}
					
					DispatchQueue.main.async {
						self.Expensetbl.reloadData()
					}
					}
				}
			
			task.resume()
		}
	
	
	private func doneHandler() {
		
				print("Month picker Done button action")
		selected_date_DoneMethod()
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
