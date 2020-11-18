//
//  ExpenseClaimVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseClaimVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	var LeaveHistoryData = NSMutableDictionary()
    var marLeavesData = NSMutableArray()

    var ExpensetblArray:NSMutableArray = NSMutableArray()

    var MainDict:NSMutableDictionary = NSMutableDictionary()

	
	@IBOutlet weak var SelectedDateLbl: UILabel!
	
	
	var Currentdatestr : String = ""
	var SelectedDatestr : String = ""
	



	@IBOutlet weak var Expensetbl: UITableView!
	@IBOutlet weak var DateView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.Expensetbl.rowHeight = 230.0

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
			

			
			//let parameters = ["empId": RetrivedempId as Any, "monthYear": Currentdatestr as Any] as [String : Any]
			
			let parameters = ["refCustId": 74 as Any, "refEmpId": 358 as Any , "empExpClaimDate": "2020-11-18" as Any] as [String : Any]

			
			//let parameters = ["empId": 358 as Any, "monthYear": "2020-11-1" as Any] as [String : Any]

			
			let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd"
					let myDate = dateFormatter.date(from: Currentdatestr)!

					dateFormatter.dateFormat = "MMM yyyy"
					let Convertdate = dateFormatter.string(from: myDate)
					print("Convertdate",Convertdate)
					SelectedDateLbl.text = Convertdate
					
					
					
//					var StartPoint = Baseurl.shared().baseURL
//					var Endpoint = "attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/getEmpExpenseClaimMob"
//
//					let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
					
					let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/getEmpExpenseClaimMob")!
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
									//self.Nodatafoundview.isHidden = false

					//             self.NoLeavesView.isHidden = false
					//            self.Absenttbl.isHidden = true
															}
								else
								{
									//self.LeaveHistorytbl.isHidden = false

							print("Normal values printed....")
							}
									
										}
										 self.LeaveHistoryData = NSMutableDictionary()
										if responseJSON != nil{
											self.LeaveHistoryData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
										}
									
									DispatchQueue.main.async {
										self.Expensetbl.reloadData()
									}
									}
								}
							
							task.resume()
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
			if LeaveHistoryData.allKeys.count > 0{
				if let temp = LeaveHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
					return temp.count
				}
				return 0
			}
			return 0
		}
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			if  LeaveHistoryData.allKeys.count > 0{
				var arrSectionsData = NSArray()
				if let temp = LeaveHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
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
			if let temp = LeaveHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
				arrSectionsData = temp
			}
			if arrSectionsData.count > 0{
				let dict = arrSectionsData.object(at: section) as? NSDictionary
				//headerCell.Leavestatusname.text = "Leave Status"
//				headerCell.LeaveHistorystatusview.layer.borderWidth = 1
//				headerCell.LeaveHistorystatusview.layer.borderColor = UIColor.lightGray.cgColor
				
				
				
								//headerCell.LeaveHistoryRejectedLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
				
	//            if let temp = dict?.value(forKey: "totalCount") as? Int{
	//                headerCell.lblCount.text = "count: \(temp)"
	//            }
	//            var strTimings = ""
	//            if let shiftStarttime = dict?.value(forKey: "shiftStart") as? String{
	//                strTimings = shiftStarttime
	//            }
	//            if let shiftEndtime = dict?.value(forKey: "shiftEnd") as? String{
	//                //strTimings = strTimings + shiftEndtime
	//                strTimings = "\(strTimings)  -  \(shiftEndtime)"
	//
	//            }
	//             headerCell.lblTimings.text = strTimings
	//            if let temp = dict?.value(forKey: "shiftName") as? String{
	//                 headerCell.lblShiftName.text = temp
	//            }
	//
			}
		   
			return headerCell
		}
		@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
		{

			//RejectedView.isHidden = false

		print("image tapped")
			// Your action
		}
		
		func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
			return 230
		}
		func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
			return 45
		}
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let Expensecell = tableView.dequeueReusableCell(withIdentifier: "Expensecell", for: indexPath) as! Expensecell
			 let arrLeaveHistory =  LeaveHistoryData.value(forKey: "expenseClaimDto") as! NSArray
			print("arrLeaveHistory....",arrLeaveHistory)
			
			let leaveTypeDetails = arrLeaveHistory.object(at: indexPath.section) as? NSDictionary
			var strLeavetypeName = ""
			if let temp = leaveTypeDetails?.value(forKey: "customerName") as? String{
				strLeavetypeName = temp
				print("strLeavetypeName...",strLeavetypeName)
				//Expensecell.lbl.text = strLeavetypeName
				
			}
			
			if let temp1 = leaveTypeDetails?.value(forKey: "empExpClaimId") as? Int{
				strLeavetypeName = String(temp1)
				print("strLeavetypeName...",strLeavetypeName)
				Expensecell.lbl.text = strLeavetypeName
				
			}
			
			
			let predict = NSPredicate(format: "leaveType = %@", strLeavetypeName)
			let arrFilter = arrLeaveHistory.filtered(using: predict) as NSArray
			if arrFilter.count > 0{
				let dictLeaveHistory = arrFilter.object(at: indexPath.row) as? NSDictionary
				//LeaveHistorycell.Leavetypename.text = dictEmp?.value(forKey: "leaveType") as? String
				
				var Fromdatestr = ""
				Fromdatestr = (dictLeaveHistory?.value(forKey: "leaveType") as? String)!
				var Todatestr = ""
				Todatestr = (dictLeaveHistory?.value(forKey: "leaveType") as? String)!
				
				//var Datestr = Fromdatestr + Todatestr
//				var Datestr = Fromdatestr + " To " + Todatestr
//				LeaveHistorycell.DateLbl.text = Datestr
//
//
//				var Noofdayscount = Int()
//
//				Noofdayscount = (dictLeaveHistory?.value(forKey: "empLeaveDaysCount") as? NSInteger)!
//				let ConvertstNoofdayscountr2 = String(Noofdayscount)
//				LeaveHistorycell.NoofdaysLbl.text = ConvertstNoofdayscountr2
//
//
//				LeaveHistorycell.LeavetypeLbl.text = (dictLeaveHistory?.value(forKey: "leaveType") as? String)!
//				LeaveHistorycell.Remarktxtview.text = (dictLeaveHistory?.value(forKey: "empLeaveRemarks") as? String)!
//
//
//
//				LeaveHistorycell.LeaveHistorycellBackview.layer.borderWidth = 1
//				LeaveHistorycell.LeaveHistorycellBackview.layer.borderColor = UIColor.lightGray.cgColor
			}
			return Expensecell
		}
		func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
			return 230;//Choose your custom row height
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
