//
//  TimesheetVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/28/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class TimesheetVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    var SelectCustArray:NSMutableArray = NSMutableArray()
    var SelecttaskArray:NSMutableArray = NSMutableArray()
    var MainDict:NSMutableDictionary = NSMutableDictionary()
	private var isAlreadyclientdropdown = false
	private var isAlreadytaskdropdown = false


	
	@IBOutlet weak var Topdatebckview: UIView!
	@IBOutlet weak var datetxtlbl: UILabel!
	//@IBOutlet weak var datetxtfld: UITextField!
	@IBOutlet weak var Dateselectionlbl: UILabel!
	@IBOutlet weak var datetxtfld: UITextField!
	@IBOutlet weak var custlbl: UILabel!
	
	@IBOutlet weak var selecttasklbl: UILabel!
	
	@IBOutlet weak var subtasklbl: UILabel!
	
	@IBOutlet weak var hourslbl: UILabel!
	@IBOutlet weak var Datetimeview: UIView!
	
	@IBOutlet weak var Selectcustview: UIView!
	
	@IBOutlet weak var SelectTaskview: UIView!
	
	
	@IBOutlet weak var tblbackview: UIView!
	
	@IBOutlet weak var tblsubtaskbckview: UIView!
	
	@IBOutlet weak var timesheettbl: UITableView!
	
	@IBOutlet weak var selectcustDrpdownbckview: UIView!
	
	@IBOutlet weak var selectcusttitlelbl: UILabel!
	@IBOutlet weak var Selectcusttbl: UITableView!
	@IBOutlet weak var SelecttaskDrpdownbckview: UIView!
	
	@IBOutlet weak var selecttasktbl: UITableView!
	
	@IBOutlet weak var selecttasktitlelbl: UILabel!
	let MyAccountArray: [String] = ["GST filling and other paper related activities.filling other paper related activities", "Financial documents", "Employee Extra training certification." , "Client deal clouser and visiting." , "Financial new documents" , "Employee Extra training certification"]
	let Datepicker = UIDatePicker()
	override func viewDidLoad() {
        super.viewDidLoad()
		datetxtfld.delegate = self
		datetxtfld.delegate = self
		tblbackview.isHidden = true



		Selectcusttbl.rowHeight = 40
		selecttasktbl.rowHeight = 40
		timesheettbl.rowHeight = 76
		timesheettbl.register(UINib(nibName: "timesheettblcell", bundle: nil), forCellReuseIdentifier: "timesheettblcell")
		
		Selectcusttbl.register(UINib(nibName: "Selectcustcell", bundle: nil), forCellReuseIdentifier: "Selectcustcell")
		selecttasktbl.register(UINib(nibName: "Selectcustcell", bundle: nil), forCellReuseIdentifier: "Selectcustcell")

		selectcustDrpdownbckview.isHidden = true
		SelecttaskDrpdownbckview.isHidden = true
		Topdatebckview.layer.shadowColor = UIColor.lightGray.cgColor
		Topdatebckview.layer.shadowOpacity = 3
		Topdatebckview.layer.shadowOffset = .zero
		Topdatebckview.layer.shadowRadius = 4
		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
		Topdatebckview.layer.borderWidth = 0.30
		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		Selectcustview.layer.borderWidth = 0.30
//		SelectTaskview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		SelectTaskview.layer.borderWidth = 0.30
//		tblbackview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblbackview.layer.borderWidth = 0.30
//		tblsubtaskbckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblsubtaskbckview.layer.borderWidth = 0.20
		
		
		
		selectcusttitlelbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let selectcusttitlelblatributes :Dictionary = [NSAttributedStringKey.font : selectcusttitlelbl.font]
		selectcusttitlelbl.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
		
		selecttasktitlelbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let selecttasktitlelblatributes :Dictionary = [NSAttributedStringKey.font : selecttasktitlelbl.font]
		selecttasktitlelbl.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
		
		datetxtlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let datetextattributes :Dictionary = [NSAttributedStringKey.font : datetxtlbl.font]
		datetxtlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		datetxtfld.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let dateattributes :Dictionary = [NSAttributedStringKey.font : datetxtfld.font]
		datetxtfld.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		custlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let custattributes :Dictionary = [NSAttributedStringKey.font : custlbl.font]
		custlbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		selecttasklbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let selecttaskattributes :Dictionary = [NSAttributedStringKey.font : selecttasklbl.font]
		selecttasklbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		subtasklbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let subtasksatributes :Dictionary = [NSAttributedStringKey.font : subtasklbl.font]
		subtasklbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		hourslbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let hoursattributes :Dictionary = [NSAttributedStringKey.font : hourslbl.font]
		hourslbl.textColor = #colorLiteral(red: 0.9689681155, green: 0.6426868715, blue: 0.1272936669, alpha: 1)
		
		tblbackview.layer.shadowColor = UIColor.lightGray.cgColor
		tblbackview.layer.shadowOpacity = 5
		tblbackview.layer.shadowOffset = .zero
		tblbackview.layer.shadowRadius = 6
		
		selectcustDrpdownbckview.layer.cornerRadius = 5
		selectcustDrpdownbckview.layer.shadowColor = UIColor.lightGray.cgColor
		selectcustDrpdownbckview.layer.shadowOpacity = 5
		selectcustDrpdownbckview.layer.shadowOffset = .zero
		selectcustDrpdownbckview.layer.shadowRadius = 6
		
		SelecttaskDrpdownbckview.layer.cornerRadius = 5
		SelecttaskDrpdownbckview.layer.shadowColor = UIColor.lightGray.cgColor
		SelecttaskDrpdownbckview.layer.shadowOpacity = 5
		SelecttaskDrpdownbckview.layer.shadowOffset = .zero
		SelecttaskDrpdownbckview.layer.shadowRadius = 6
		
		
		//Select custmor Action label
		let selecttap = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.SelectcustFunc))
		custlbl.isUserInteractionEnabled = true
		custlbl.addGestureRecognizer(selecttap)
		
		let selecttask = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.SelecttaskFunc))
		selecttasklbl.isUserInteractionEnabled = true
		selecttasklbl.addGestureRecognizer(selecttask)
		
		
		Datepicker.datePickerMode = UIDatePicker.Mode.date
		datetxtfld.inputView = Datepicker
		 let formatter = DateFormatter()
	   formatter.dateFormat = "dd-MMM-yyyy"
		datetxtfld.text = formatter.string(from: Datepicker.date)
		
		FromDatesetDatePicker()
		//datetxtfld.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)

		
    }
	
	//@objc func FromDatesetDatePicker() {
		 func FromDatesetDatePicker() {


		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
		
		toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
		
		datetxtfld.inputAccessoryView = toolbar
		datetxtfld.inputView = Datepicker
		print("datetxtfld .",datetxtfld.text as Any)
		
	}
	
	@objc func doneDatePicker(){
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MMM-yyyy"
		datetxtfld.text = formatter.string(from: Datepicker.date)
		 //var ConvertedDatestr = ""
		//ConvertedCurrentDatestr = formattedDateFromString(dateString:
			//DatetxtFld.text!, withFormat: "yyyy-MM-dd")! as NSString
		//print("ConvertedCurrentDatestr---",ConvertedCurrentDatestr)
//AbsentAPIMethod()
		self.view.endEditing(true)
	}
	
	@objc func cancelDatePicker(){
		self.view.endEditing(true)
};
	
	
	
	
	
	@objc func SelectcustFunc(sender:UITapGestureRecognizer) {

		print("SelectcustFunc tap working")
		selectcustDrpdownbckview.isHidden = false
		
		if isAlreadyclientdropdown {
			return
		}
		isAlreadyclientdropdown = true
		SelectCustDtpdown()

	}
	
	@objc func SelecttaskFunc(sender:UITapGestureRecognizer) {

		print("select task tap working")
		SelecttaskDrpdownbckview.isHidden = false
		if isAlreadytaskdropdown {
			return
		}
		isAlreadytaskdropdown = true
		selecttask()


	}
	

	
	
	
	func SelectCustDtpdown()
	{
	let defaults = UserDefaults.standard

	var RetrivedempId = defaults.integer(forKey: "empId")

	let parameters = ["empId": 3938 as Any] as [String : Any]

//						var StartPoint = Baseurl.shared().baseURL
//						var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getMyTeamDetails"
//						let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint1)")!

	let url: NSURL = NSURL(string:"http://122.166.248.191:8080/attnd-api-gateway-service/api/customer/EmpTimeSheet/ClientListByEmpId")!

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
						//create dataTask using the ses
						//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
	let task = URLSession.shared.dataTask(with: request) { data, response, error in
	guard let data = data, error == nil else {
	print(error?.localizedDescription ?? "No data")
	return
	}
	let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
	if let responseJSON = responseJSON as? [String: Any] {
	DispatchQueue.main.async {
	let statusDic = responseJSON["status"]! as! NSDictionary
	let SelectCustcode = statusDic["code"] as? NSInteger
	if (SelectCustcode == 200)
	{

	let clientdetailsArray = responseJSON["clientdetails"] as! NSArray
	for Dic in clientdetailsArray as! [[String:Any]]

	{
		var MainDict:NSMutableDictionary = NSMutableDictionary()
	var clientNamestr = Dic["clientName"] as! NSString
		MainDict.setObject(clientNamestr, forKey: "clientName" as NSCopying)
		self.SelectCustArray.add(MainDict)
		self.Selectcusttbl.reloadData()

	}

	}
	else
	{
	print("Not   Leaves")
	}

								}
							}
						}
						task.resume()
	}
	
	func selecttask()
	{
		
			let defaults = UserDefaults.standard
					
			var RetrivedempId = defaults.integer(forKey: "empId")
					
		let parameters = ["clientId": 18 , "empId": 3938 as Any] as [String : Any]
							   
		
								
			let url: NSURL = NSURL(string:"http://122.166.248.191:8080/attnd-api-gateway-service/api/customer/EmpTimeSheet/TaskListByEmployeeId")!
								
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
								//create dataTask using the ses
								//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
			print(error?.localizedDescription ?? "No data")
			return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
			DispatchQueue.main.async {
			let statusDic = responseJSON["status"]! as! NSDictionary
			let SelectCustcode = statusDic["code"] as? NSInteger
			if (SelectCustcode == 200)
			{
												
			let clientdetailsArray = responseJSON["taskDetails"] as! NSArray
			for Dic in clientdetailsArray as! [[String:Any]]

			{
				var MainDict:NSMutableDictionary = NSMutableDictionary()
			var clientNamestr = Dic["taskName"] as! NSString
				MainDict.setObject(clientNamestr, forKey: "taskName" as NSCopying)
				self.SelecttaskArray.add(MainDict)
				self.selecttasktbl.reloadData()

			}
												
			}
			else
			{
			}
										
										}
									}
								}
								task.resume()
			}
	
	func subtasklist()
	{
		
			let defaults = UserDefaults.standard
					
			var RetrivedempId = defaults.integer(forKey: "empId")
					
		let parameters = ["empId": 3938 , "empTaskId_h": 162 as Any] as [String : Any]
							   
		
								
			let url: NSURL = NSURL(string:"http://122.166.248.191:8080/attnd-api-gateway-service/api/customer/EmpTimeSheet/EmployeeSubtaskInfoByEmpTaskId")!
								
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
								//create dataTask using the ses
								//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
		let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
			guard let data = data, error == nil else {
			print(error?.localizedDescription ?? "No data")
			return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {

			DispatchQueue.main.async {
				tblbackview.isHidden = true

			let statusDic = responseJSON["status"]! as! NSDictionary
			let SelectCustcode = statusDic["code"] as? NSInteger
			if (SelectCustcode == 200)
			{
												
			let clientdetailsArray = responseJSON["subtasks"] as! NSArray
			for Dic in clientdetailsArray as! [[String:Any]]

			{
				var MainDict:NSMutableDictionary = NSMutableDictionary()
			var subTaskNamestr = Dic["subTaskName"] as! NSString
				MainDict.setObject(subTaskNamestr, forKey: "subTaskName" as NSCopying)
				//self.SelecttaskArray.add(MainDict)
				//self.selecttasktbl.reloadData()

			}
				print("its false")
				self.tblbackview.isHidden = false


												
			}
			else
			{
			}
										
										}
									}
								}
								task.resume()
			}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//return self.MyAccountArray.count
		
		var count:Int?
		if tableView == self.timesheettbl {
		count = MyAccountArray.count
		return count!
			}
		else{
			if tableView == self.Selectcusttbl {
			count = SelectCustArray.count
			return count!
			
			}
			}
		if tableView == self.selecttasktbl {
		count =  SelecttaskArray.count
			}
		return count!
	}
	
		
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		var cellToReturn = UITableViewCell() // Dummy value
		if tableView == self.timesheettbl {
			let cell = tableView.dequeueReusableCell(withIdentifier: "timesheettblcell") as! timesheettblcell
			
				cell.subtasktbllbl.text = self.MyAccountArray[indexPath.row]
			
					cell.tableviewsubtaskcellbackview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
					cell.tableviewsubtaskcellbackview.layer.borderWidth = 0.30
			
					cell.subtasktbllbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
					let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : cell.subtasktbllbl.font]
					cell.subtasktbllbl.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
			
			
				//let image = MyAccountIconImgs[indexPath.row]
				//cell.img.image = image
				//return cell
		cellToReturn = cell
			}
			else if tableView == self.Selectcusttbl
			{
				let cell = tableView.dequeueReusableCell(withIdentifier: "Selectcustcell") as! Selectcustcell
				let responseDict = self.SelectCustArray[indexPath.row] as! NSMutableDictionary
									_ = SelectCustArray[indexPath.row]
				print("Retrived data",responseDict)
				self.SelectCustArray.add(MainDict)
				print("cust Type Array",SelectCustArray)
				var clientNamestr : String?
				clientNamestr = responseDict["clientName"] as? String
				print("clientName",clientNamestr)
				cell.selectcustlbl.text = clientNamestr
				cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
				let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
				cell.selectcustlbl.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
				
				
				cellToReturn = cell
				
			}
		 if tableView == self.selecttasktbl
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Selectcustcell") as! Selectcustcell
			let responseDict = self.SelecttaskArray[indexPath.row] as! NSMutableDictionary
								_ = SelecttaskArray[indexPath.row]
			print("Retrived data",responseDict)
			self.SelecttaskArray.add(MainDict)
			print("SelecttaskArray Type Array",SelecttaskArray)
			var taskNamestr : String?
			taskNamestr = responseDict["taskName"] as? String
			print("taskName",taskNamestr)
			cell.selectcustlbl.text = taskNamestr
			cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
			let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
			cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			
			cellToReturn = cell
			
		}
		
		return cellToReturn
	}
	
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		
		var cellToReturn = UITableViewCell() // Dummy value
		if tableView == self.timesheettbl {
			let cell = tableView.dequeueReusableCell(withIdentifier: "timesheettblcell") as! timesheettblcell
			
				cell.subtasktbllbl.text = self.MyAccountArray[indexPath.row]
			
					cell.tableviewsubtaskcellbackview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
					cell.tableviewsubtaskcellbackview.layer.borderWidth = 0.30
			
					cell.subtasktbllbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
					let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : cell.subtasktbllbl.font]
					cell.subtasktbllbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			
			
				//let image = MyAccountIconImgs[indexPath.row]
				//cell.img.image = image
				//return cell
		cellToReturn = cell
			}
			else if tableView == self.Selectcusttbl
			{
				let cell = tableView.dequeueReusableCell(withIdentifier: "Selectcustcell") as! Selectcustcell
				let responseDict = self.SelectCustArray[indexPath.row] as! NSMutableDictionary
									_ = SelectCustArray[indexPath.row]
				print("Retrived data",responseDict)
				self.SelectCustArray.add(MainDict)
				print("cust Type Array",SelectCustArray)
				var clientNamestr : String?
				clientNamestr = responseDict["clientName"] as? String
				print("clientName",clientNamestr)
				
				custlbl.text = clientNamestr
				selectcustDrpdownbckview.isHidden = true

				
				cell.selectcustlbl.text = clientNamestr
				cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
				let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
				cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				
				
				
				cellToReturn = cell
				
			}
		 if tableView == self.selecttasktbl
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Selectcustcell") as! Selectcustcell
			let responseDict = self.SelecttaskArray[indexPath.row] as! NSMutableDictionary
								_ = SelecttaskArray[indexPath.row]
			print("Retrived data",responseDict)
			self.SelecttaskArray.add(MainDict)
			print("SelecttaskArray Type Array",SelecttaskArray)
			var taskNamestr : String?
			taskNamestr = responseDict["taskName"] as? String
			print("taskName",taskNamestr)
			cell.selectcustlbl.text = taskNamestr
		selecttasklbl.text = taskNamestr
			SelecttaskDrpdownbckview.isHidden = true
			subtasklist()

			cell.selectcustlbl.text = taskNamestr
			cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
			let selecttaskatributesattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
			cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			
			cellToReturn = cell
			
		}
		
	}
	
	
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 76
//
//	}
    

	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)

		
	}
	
}



