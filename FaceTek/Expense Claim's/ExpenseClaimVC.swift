//
//  ExpenseClaimVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseClaimVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var ExpenseClaimtitleLbl: UILabel!
	var ExpenseHistoryData = NSMutableDictionary()
    var marLeavesData = NSMutableArray()
	@IBOutlet weak var NoDatafoundview: UIView!
	var ExpensetblArray:NSMutableArray = NSMutableArray()
    var MainDict:NSMutableDictionary = NSMutableDictionary()
	@IBOutlet weak var SelectedDateLbl: UILabel!
	var Currentdatestr : String = ""
	var SelectedDatestr : String = ""
	var empExpClaimId : String = ""

	


	@IBOutlet weak var Expensetbl: UITableView!
	@IBOutlet weak var DateView: UIView!
	
	@IBOutlet weak var DeleteView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.DeleteView.isHidden = true
		self.Expensetbl.isHidden = true
		self.Expensetbl.rowHeight = 240.0
		ExpenseClaimtitleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)!
		let ExpenseClaimtitleLblattributes :Dictionary = [NSAttributedStringKey.font : ExpenseClaimtitleLbl.font]
		ExpenseClaimtitleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		SelectedDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let SelectedDateLblattributes :Dictionary = [NSAttributedStringKey.font : SelectedDateLbl.font]
		SelectedDateLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
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
		//Delete view shadow color
		DeleteView.layer.cornerRadius = 1
		DeleteView.clipsToBounds = true
		DeleteView.layer.masksToBounds = false
		DeleteView.layer.shadowRadius = 20
		DeleteView.layer.shadowOpacity = 0.6
		DeleteView.layer.shadowOffset = CGSize(width: 0, height: 20)
		DeleteView.layer.shadowColor = UIColor.darkGray.cgColor
		
        ExpenseClaimAPI_Integration()
    }
	@objc func DateselectedViewAction(sender : UITapGestureRecognizer) {
		print("Selected date...")
		AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		AKMonthYearPickerView.sharedInstance.previousYear = 4
			   AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
	}
	func ExpenseClaimAPI_Integration()
		{
		let defaults = UserDefaults.standard
		var RetrivedempId = defaults.integer(forKey: "empId")
		var RetrivedcustId = defaults.integer(forKey: "custId")
		let parameters = ["refCustId": RetrivedcustId as Any, "refEmpId": RetrivedempId as Any , "empExpClaimDate": Currentdatestr as Any] as [String : Any]

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: Currentdatestr)!
		dateFormatter.dateFormat = "MMM yyyy"
		let Convertdate = dateFormatter.string(from: myDate)
		print("Convertdate",Convertdate)
		SelectedDateLbl.text = Convertdate
		SelectedDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let SelectedDateLblattributes :Dictionary = [NSAttributedStringKey.font : SelectedDateLbl.font]
		SelectedDateLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/getEmpExpenseClaimMob"
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		let session = URLSession.shared
		var request = URLRequest(url: url as URL)
	    request.httpMethod = "POST" //set http method as POST
		do {
		request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
		} catch let error {
		print(error.localizedDescription)
							}
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
		guard let data = data, error == nil else {
		print(error?.localizedDescription ?? "No data")
	    return
		}
	    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
		if let responseJSON = responseJSON as? [String: Any] {
		print("Expense History Json Response",responseJSON)
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
	var temp = Int()
	temp = 1
	return temp
	}
					return 0
				}
				return 0

		}
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
	let headerCell = tableView.dequeueReusableCell(withIdentifier: "ExpenseHeadercell") as! ExpenseHeadercell
	var arrSectionsData = NSArray()
	if let temp = ExpenseHistoryData.value(forKey: "expenseClaimDto") as? NSArray{
				arrSectionsData = temp
			}
			
	if arrSectionsData.count > 0{
	let dict = arrSectionsData.object(at: section) as? NSDictionary
	headerCell.HeadercellBackVieew.layer.borderWidth = 1
	headerCell.HeadercellBackVieew.layer.borderColor = UIColor.lightGray.cgColor
	headerCell.ExpenseClaimLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseClaimLblattributes :Dictionary = [NSAttributedStringKey.font : headerCell.ExpenseClaimLbl.font]
	headerCell.ExpenseClaimLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	if let temp = dict?.value(forKey: "empExpClaimStatus") as? String{
	var empExpClaimStatus = ""
	empExpClaimStatus = temp
		
		
		
		
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(ExpenseClaimVC.tappedMe))
		headerCell.cancelimg.addGestureRecognizer(tap)
		headerCell.cancelimg.isUserInteractionEnabled = true
		
		print("selected id empExpClaimId 210")
print("selected suresh")
		print("empExpClaimId...",empExpClaimId)

		
		
	if (empExpClaimStatus == "App")
    {
	headerCell.statusLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let statusLblattributes :Dictionary = [NSAttributedStringKey.font : headerCell.statusLbl.font]
	headerCell.statusLbl.text = "Approved"
	headerCell.cancelimg.isHidden = true
	headerCell.statusLbl.isHidden = true
	headerCell.statusLbl.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
								}
	if (empExpClaimStatus == "Rej")
	{
	headerCell.statusLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let statusLblattributes :Dictionary = [NSAttributedStringKey.font : headerCell.statusLbl.font]
	headerCell.statusLbl.text = "Rejected"
	headerCell.cancelimg.isHidden = true
	headerCell.statusLbl.isHidden = false
	headerCell.statusLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
	}
	if (empExpClaimStatus == "")
	{
	headerCell.statusLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let statusLblattributes :Dictionary = [NSAttributedStringKey.font : headerCell.statusLbl.font]
	headerCell.statusLbl.text = "Pending"
	headerCell.statusLbl.isHidden = false
	headerCell.statusLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
	headerCell.cancelimg.isHidden = false
									
								}
								
							}
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
	Expensecell.ClaimDatetxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ClaimDatetxtLbl.font]
	Expensecell.ClaimDatetxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	Expensecell.ExpenseDatetxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseDatetxtLbl.font]
	Expensecell.ExpenseDatetxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	Expensecell.ExpenseAmounttxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseAmounttxtLblattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseAmounttxtLbl.font]
	Expensecell.ExpenseAmounttxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	Expensecell.ExpenseAprovedtxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseAprovedtxtLblattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseAprovedtxtLbl.font]
	Expensecell.ExpenseAprovedtxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	Expensecell.ExpenseTypetxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseTypetxtLblattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseTypetxtLbl.font]
	Expensecell.ExpenseTypetxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	Expensecell.ClaimDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseClaimattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ClaimDateLbl.font]
	Expensecell.ClaimDateLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
	Expensecell.ExpenseDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseDateattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseDateLbl.font]
	Expensecell.ExpenseDateLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
	Expensecell.ExpenseAmtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseAmtattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseAmtLbl.font]
	Expensecell.ExpenseAmtLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
	Expensecell.ExpenseApprovedAmtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
    let ExpenseApprovedAmtattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseApprovedAmtLbl.font]
	Expensecell.ExpenseApprovedAmtLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
	Expensecell.ExpenseTypeLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let ExpenseTypeattributes :Dictionary = [NSAttributedStringKey.font : Expensecell.ExpenseTypeLbl.font]
	Expensecell.ExpenseTypeLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
		
        let sectionTitle = ExpenseHistoryData[indexPath.section]
		print("sectionTitle",sectionTitle)

		
				
			}
			return Expensecell
		}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
		
		let Expensecell = tableView.dequeueReusableCell(withIdentifier: "Expensecell", for: indexPath) as! Expensecell
		let arrLeaveHistory =  ExpenseHistoryData.value(forKey: "expenseClaimDto") as! NSArray
		let ExpenseTypeDetails = arrLeaveHistory.object(at: indexPath.section) as? NSDictionary
		if let temp = ExpenseTypeDetails?.value(forKey: "empExpClaimId") as? Int{
		empExpClaimId = String(temp)

			
		}
		
	}
	
	
	
		func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
			return 250;//Choose your custom row height
		}
	
	 @IBAction func Btnclk(_ sender: Any) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let ExpensesClaimFormVC = storyBoard.instantiateViewController(withIdentifier: "ExpensesClaimFormVC") as! ExpensesClaimFormVC
		self.present(ExpensesClaimFormVC, animated:true, completion:nil)
        
	}
	@objc func tappedMe(tapGestureRecognizer: UITapGestureRecognizer)
	{
print("cancel button clickd")

		DeleteView.isHidden = false
	}
	
	func selected_date_DoneMethod()
	{
	let defaults = UserDefaults.standard
	var RetrivedempId = defaults.integer(forKey: "empId")
	let parameters = ["empId": RetrivedempId as Any, "monthYear": SelectedDatestr as Any] as [String : Any]
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd"
	let myDate = dateFormatter.date(from: SelectedDatestr)!
	dateFormatter.dateFormat = "MMM yyyy"
	let Convertdate = dateFormatter.string(from: myDate)
	print("Convertdate",Convertdate)
	SelectedDateLbl.text = Convertdate
	SelectedDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
	let SelectedDateLblattributes :Dictionary = [NSAttributedStringKey.font : SelectedDateLbl.font]
	SelectedDateLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmployeeLeaveList"
	let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
	let session = URLSession.shared
	var request = URLRequest(url: url as URL)
    request.httpMethod = "POST"
    do {
	request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
		
	} catch let error {
				print(error.localizedDescription)
			}
	request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	request.addValue("application/json", forHTTPHeaderField: "Accept")
	let task = URLSession.shared.dataTask(with: request) { data, response, error in
	guard let data = data, error == nil else {
	print(error?.localizedDescription ?? "No data")
					return
				}
	let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
	if let responseJSON = responseJSON as? [String: Any] {
	print("Expense History Json Response",responseJSON)
	DispatchQueue.main.async {
	if let absentShiftDetailsid = responseJSON["empLeaveList"] as? NSNull {
	self.NoDatafoundview.isHidden = false
											}
				else
				{
	self.Expensetbl.isHidden = true
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
