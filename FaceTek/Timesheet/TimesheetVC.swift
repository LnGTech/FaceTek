//
//  TimesheetVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/28/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class TimesheetVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
	var SubtaskArray:NSMutableArray = NSMutableArray()
	var workedhoursArray:NSMutableArray = NSMutableArray()
	var subtasknameArray:NSMutableArray = NSMutableArray()
	var empTaskId_Array:NSMutableArray = NSMutableArray()
	
	var SubtaskData = NSMutableDictionary()
	var SubtasklistArray = NSMutableArray()





    var SelectCustArray:NSMutableArray = NSMutableArray()
    var SelecttaskArray:NSMutableArray = NSMutableArray()
    var MainDict:NSMutableDictionary = NSMutableDictionary()
	private var isAlreadyclientdropdown = false
	private var isAlreadytaskdropdown = false
	private var isAlreadysubtaskdropdown = false

	var selectedclientId = Int()
	var selectedempTaskId_h = Int()
	var empTaskId_d : Int?

	var index = IndexPath()
	var Selectedhrsstr = String()
	var selecteddate = String()


	@IBOutlet weak var Topdatebckview: UIView!
	@IBOutlet weak var datetxtlbl: UILabel!
	
	@IBOutlet weak var ContentView: UIView!
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
	
	@IBOutlet weak var Workedhrsview: UIView!
	
	@IBOutlet weak var scroll: UIScrollView!
	
	@IBOutlet weak var tblbackview: UIView!
	
	@IBOutlet weak var tblsubtaskbckview: UIView!
	
	
	@IBOutlet weak var Remarklbl: UILabel!
	
	@IBOutlet weak var nofoundremarklbl: UILabel!
	@IBOutlet weak var Remarkspopuplbl: UILabel!
	@IBOutlet weak var taskcompltedlbl: UILabel!
	
	@IBOutlet weak var RemarksBackview: UIView!
	
	@IBOutlet weak var NoremarksBackview: UIView!
	
	@IBOutlet weak var submitbtn: UIButton!
	
	@IBOutlet weak var timesheettbl: UITableView!
	
	@IBOutlet weak var selectcustDrpdownbckview: UIView!
	
	@IBOutlet weak var selectcusttitlelbl: UILabel!
	@IBOutlet weak var Selectcusttbl: UITableView!
	
	@IBOutlet weak var hrsminutestbl: UITableView!
	@IBOutlet weak var SelecttaskDrpdownbckview: UIView!
	
	@IBOutlet weak var selecttasktbl: UITableView!
	
	@IBOutlet weak var selecttasktitlelbl: UILabel!
	
	@IBOutlet weak var provideworkhrslbl: UILabel!
	
	@IBOutlet weak var Workhrslbl: UILabel!
	
	@IBOutlet weak var hrslistlbl: UILabel!
	@IBOutlet weak var cancellbl: UILabel!
	
	@IBOutlet weak var oklbl: UILabel!
	
	@IBOutlet weak var checkBoxBtn: UIButton!
	
	
	let MyAccountArray: [String] = ["GST filling and other paper related activities.filling other paper related activities", "Financial documents", "Employee Extra training certification." , "Client deal clouser and visiting." , "Financial new documents" , "Employee Extra training certification"]
	
	let hoursArray: [String] = ["00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","24:00"]

	let Datepicker = UIDatePicker()
	override func viewDidLoad() {
        super.viewDidLoad()
		RemarksBackview.isHidden = true
		NoremarksBackview.isHidden = true

		datetxtfld.delegate = self
		datetxtfld.delegate = self
		tblbackview.isHidden = true
		submitbtn.isHidden = true
		self.scroll.isScrollEnabled = false
		Selectcusttbl.rowHeight = 40
		selecttasktbl.rowHeight = 40
		hrsminutestbl.rowHeight = 35
		timesheettbl.rowHeight = 55
		timesheettbl.register(UINib(nibName: "timesheettblcell", bundle: nil), forCellReuseIdentifier: "timesheettblcell")
		
		Selectcusttbl.register(UINib(nibName: "Selectcustcell", bundle: nil), forCellReuseIdentifier: "Selectcustcell")
		selecttasktbl.register(UINib(nibName: "Selectcustcell", bundle: nil), forCellReuseIdentifier: "Selectcustcell")
		
		hrsminutestbl.register(UINib(nibName: "hrsminutescell", bundle: nil), forCellReuseIdentifier: "hrsminutescell")


		selectcustDrpdownbckview.isHidden = true
		SelecttaskDrpdownbckview.isHidden = true
		Workedhrsview.isHidden = true
		hrsminutestbl.isHidden = true
		Topdatebckview.layer.shadowColor = UIColor.lightGray.cgColor
		Topdatebckview.layer.shadowOpacity = 3
		Topdatebckview.layer.shadowOffset = .zero
		Topdatebckview.layer.shadowRadius = 4
		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
		Topdatebckview.layer.borderWidth = 0.30
		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
		
		
		Workedhrsview.layer.shadowColor = UIColor.black.cgColor
		Workedhrsview.layer.shadowOpacity = 1
		Workedhrsview.layer.shadowOffset = .zero
		Workedhrsview.layer.shadowRadius = 5
		
		
//		Selectcustview.layer.borderWidth = 0.30
//		SelectTaskview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		SelectTaskview.layer.borderWidth = 0.30
//		tblbackview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblbackview.layer.borderWidth = 0.30
//		tblsubtaskbckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblsubtaskbckview.layer.borderWidth = 0.20
		
		
		
		selectcusttitlelbl.font = UIFont(name: "Montserrat-Medium", size: 18.0)!
		let selectcusttitlelblatributes :Dictionary = [NSAttributedStringKey.font : selectcusttitlelbl.font]
		selectcusttitlelbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		
		selecttasktitlelbl.font = UIFont(name: "Montserrat-Medium", size: 18.0)!
		let selecttasktitlelblatributes :Dictionary = [NSAttributedStringKey.font : selecttasktitlelbl.font]
		selecttasktitlelbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.55)
		
		datetxtlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let datetextattributes :Dictionary = [NSAttributedStringKey.font : datetxtlbl.font]
		datetxtlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		datetxtfld.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let dateattributes :Dictionary = [NSAttributedStringKey.font : datetxtfld.font]
		datetxtfld.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		custlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let custattributes :Dictionary = [NSAttributedStringKey.font : custlbl.font]
		custlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		selecttasklbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let selecttaskattributes :Dictionary = [NSAttributedStringKey.font : selecttasklbl.font]
		selecttasklbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		subtasklbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let subtasksatributes :Dictionary = [NSAttributedStringKey.font : subtasklbl.font]
		subtasklbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
		hourslbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let hoursattributes :Dictionary = [NSAttributedStringKey.font : hourslbl.font]
		hourslbl.textColor = #colorLiteral(red: 0.9689681155, green: 0.6426868715, blue: 0.1272936669, alpha: 1)
		
		
		
		
		provideworkhrslbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let providehrslblatributes :Dictionary = [NSAttributedStringKey.font : provideworkhrslbl.font]
		provideworkhrslbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		Workhrslbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let hourslblatributes :Dictionary = [NSAttributedStringKey.font : Workhrslbl.font]
		Workhrslbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7385385273)
		
		hrslistlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let hrslistlblatributes :Dictionary = [NSAttributedStringKey.font : hrslistlbl.font]
		hrslistlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7385385273)
		
		cancellbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let cancellblatributes :Dictionary = [NSAttributedStringKey.font : cancellbl.font]
		cancellbl.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		
		oklbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let oklblatributes :Dictionary = [NSAttributedStringKey.font : oklbl.font]
		oklbl.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		
		
		Remarklbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let remarklblatributes :Dictionary = [NSAttributedStringKey.font : Remarklbl.font]
		Remarklbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		
		taskcompltedlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let taskcompltedlblatributes :Dictionary = [NSAttributedStringKey.font : taskcompltedlbl.font]
		taskcompltedlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		//Remarks Popup label
		
		Remarkspopuplbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let Remarkspopuplblatributes :Dictionary = [NSAttributedStringKey.font : Remarkspopuplbl.font]
		Remarkspopuplbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			//No remarks found label
	
		nofoundremarklbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
		let nofoundremarklblatributes :Dictionary = [NSAttributedStringKey.font : nofoundremarklbl.font]
		nofoundremarklbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)


		
		
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
		
		
		//Remark view shadow color
		RemarksBackview.layer.cornerRadius = 5
		RemarksBackview.layer.shadowColor = UIColor.darkGray.cgColor
		RemarksBackview.layer.shadowOpacity = 5
		RemarksBackview.layer.shadowOffset = .zero
		RemarksBackview.layer.shadowRadius = 6
		//No Remarks found label
		NoremarksBackview.layer.cornerRadius = 5
		NoremarksBackview.layer.shadowColor = UIColor.darkGray.cgColor
		NoremarksBackview.layer.shadowOpacity = 5
		NoremarksBackview.layer.shadowOffset = .zero
		NoremarksBackview.layer.shadowRadius = 6
		
		//Select custmor Action label
		let selecttap = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.SelectcustFunc))
		custlbl.isUserInteractionEnabled = true
		custlbl.addGestureRecognizer(selecttap)
		
		let selecttask = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.SelecttaskFunc))
		selecttasklbl.isUserInteractionEnabled = true
		selecttasklbl.addGestureRecognizer(selecttask)
		
		
		Datepicker.datePickerMode = UIDatePicker.Mode.date
		datetxtfld.inputView = Datepicker
		 //let formatter = DateFormatter()
		let dateFormatter = DateFormatter()

		dateFormatter.dateFormat = "dd-MM-yyyy"
		datetxtfld.text = dateFormatter.string(from: Datepicker.date)
		let datestr = dateFormatter.string(from: Datepicker.date)
		print("datetxtfld.text...",datetxtfld.text)
		print("datestr...",datestr)

		
//		if (datetxtfld.text != datestr)
//		{
//			print("date selection true")
//			tblbackview.isHidden = false
//
//		}
//		else
//		{
//			print("date selection false")
//			tblbackview.isHidden = false
//
//
//		}
		
		FromDatesetDatePicker()
		
		//horus and minute tableview and label action
		let hrsminutstap = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.hoursminutestapFunction))
			   hrslistlbl.isUserInteractionEnabled = true
		hrslistlbl.addGestureRecognizer(hrsminutstap)
		
		//Okay label action
		let okaylbl = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.okaylblaction))
		oklbl.isUserInteractionEnabled = true
		oklbl.addGestureRecognizer(okaylbl)
		
		let Cancellabel = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.CancellabelAction))
		cancellbl.isUserInteractionEnabled = true
		cancellbl.addGestureRecognizer(Cancellabel)
		
		//datetxtfld.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)
		
         //Press on ContentView hide cust and taskdropdown
//		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.ContentViewAction))
//		self.ContentView.addGestureRecognizer(gesture)
		
    }
	
	@objc func okaylblaction(sender:UITapGestureRecognizer) {
		Workedhrsview.isHidden = true
		if let cell = timesheettbl.cellForRow(at:index) as? timesheettblcell
		{
			cell.hrslbl?.text = hrslistlbl.text
			Selectedhrsstr = hrslistlbl.text!
			
		}

	}
	@objc func CancellabelAction(sender:UITapGestureRecognizer) {
		Workedhrsview.isHidden = true
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//return self.MyAccountArray.count
		
		var count:Int?
		if tableView == self.timesheettbl {
		count = SubtasklistArray.count
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
			
		return count!
		}
		else
		{
		if tableView == self.hrsminutestbl {
		count =  hoursArray.count
			}
		return count!
		}
	}
	
		
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		var cellToReturn = UITableViewCell() // Dummy value
		if tableView == self.timesheettbl {
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "timesheettblcell", for: indexPath) as! timesheettblcell
			let dicsubtaskDetails = SubtasklistArray.object(at: indexPath.row) as? NSDictionary
			cell.subtasktbllbl.text = dicsubtaskDetails?.value(forKey: "subTaskName") as? String
			

			cell.hrslbl.text = dicsubtaskDetails?.value(forKey: "workedHours") as? String
			var empTaskId_d : Int?
			empTaskId_d = dicsubtaskDetails?.value(forKey: "empTaskId_d") as? Int


			//cell.subtasktbllbl.text = dicsubtaskDetails?.value(forKey: "empTaskId_d") as? Int

			
			
			
			
//			var subTaskNamestr : String?
//			subTaskNamestr = responseDict["subTaskName"] as? String
//			print("subTaskNamestr",subTaskNamestr)
//			cell.subtasktbllbl.text = subTaskNamestr
//
//			var Workedhrsstr : String?
//			Workedhrsstr = responseDict["workedHours"] as? String
//			print("Workedhrsstr",Workedhrsstr)
//			cell.hrslbl.text = Workedhrsstr
//
//			var empTaskId_d : Int?
//			empTaskId_d = responseDict["empTaskId_d"] as? Int
//			print("empTaskId_d.,",empTaskId_d)
//			cell.subtasktbllbl.text = subTaskNamestr
//
			cell.tableviewsubtaskcellbackview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
			cell.tableviewsubtaskcellbackview.layer.borderWidth = 0.30

			cell.subtasktbllbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
			let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : cell.subtasktbllbl.font]
			cell.subtasktbllbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
			
			cell.hrslbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
			let hrsattributes :Dictionary = [NSAttributedStringKey.font : cell.hrslbl.font]
			cell.hrslbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
			
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
				
				let clientId : NSInteger
				clientId = responseDict["clientId"] as! NSInteger
				print("clientId",clientId)
				
				
				cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
				let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
				cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				
				
				cellToReturn = cell
				
			}
		else if tableView == self.selecttasktbl
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
			let empTaskId_h : NSInteger
			empTaskId_h = responseDict["empTaskId_h"] as! NSInteger
			print("empTaskId_h",empTaskId_h)
			cell.selectcustlbl.text = taskNamestr
			cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
			let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
			cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			
			cellToReturn = cell
			
		}
		
		 if tableView == self.hrsminutestbl
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "hrsminutescell") as! hrsminutescell
			
			cell.minutslbl?.text = self.hoursArray[indexPath.row]
			
			cellToReturn = cell
			
		}
		

		
		return cellToReturn
	}
	
	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		
		var cellToReturn = UITableViewCell() // Dummy value
		if tableView == self.timesheettbl {
			
			index = indexPath
			
//
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "timesheettblcell", for: indexPath) as! timesheettblcell
			let dicShiftDetails = SubtasklistArray.object(at: indexPath.row) as? NSDictionary
			cell.subtasktbllbl.text = dicShiftDetails?.value(forKey: "subTaskName") as? String
			
			
			empTaskId_d = dicShiftDetails?.value(forKey: "empTaskId_d") as? Int
			
						Workedhrsview.isHidden = false

			cell.tableviewsubtaskcellbackview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
			cell.tableviewsubtaskcellbackview.layer.borderWidth = 0.30

			cell.subtasktbllbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
			let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : cell.subtasktbllbl.font]
			cell.subtasktbllbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
			
			cell.hrslbl.font = UIFont(name: "Montserrat-Medium", size: 12.0)!
			let hrsattributes :Dictionary = [NSAttributedStringKey.font : cell.hrslbl.font]
			cell.hrslbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
			
			
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
				
				//let clientId : NSInteger
				selectedclientId = responseDict["clientId"] as! NSInteger
				print("selected id ",selectedclientId)
				
				custlbl.text = clientNamestr
				selectcustDrpdownbckview.isHidden = true

				
				cell.selectcustlbl.text = clientNamestr
				cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
				let dateattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
				cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				
				
				
				cellToReturn = cell
				
			}
		 else if tableView == self.selecttasktbl
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
			selectedempTaskId_h = responseDict["empTaskId_h"] as! NSInteger
			print("selected selectedempTaskId_h ",selectedempTaskId_h)
			cell.selectcustlbl.text = taskNamestr
		selecttasklbl.text = taskNamestr
			SelecttaskDrpdownbckview.isHidden = true
			submitbtn.isHidden = false
			subtasklist()
			cell.selectcustlbl.text = taskNamestr
			cell.selectcustlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
			let selecttaskatributesattributes :Dictionary = [NSAttributedStringKey.font : cell.selectcustlbl.font]
			cell.selectcustlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			
			cellToReturn = cell
			
		}
		if tableView == self.hrsminutestbl
	   {
		   let cell = tableView.dequeueReusableCell(withIdentifier: "hrsminutescell") as! hrsminutescell
		   
		   cell.minutslbl?.text = self.hoursArray[indexPath.row]
			var hoursminutesstr = NSString()
			hrslistlbl?.text = cell.minutslbl?.text
			hrsminutestbl.isHidden = true
		   
		   cellToReturn = cell
		
	}
	}
	
	
	//hours and minutes functionality method
	
	@objc
		func hoursminutestapFunction(sender:UITapGestureRecognizer) {
			print(" hours and minutes tap working")
			hrsminutestbl.isHidden = false
			
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
		print("selection date",datetxtfld.text)
		
		tblbackview.isHidden = true
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
	
//	@objc func ContentViewAction(sender : UITapGestureRecognizer) {
//		selectcustDrpdownbckview.isHidden = true
//		SelecttaskDrpdownbckview.isHidden = true
//
//	}
	
	//date conversion
	func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = currentFomat

		let date : Date = dateFormatterGet.date(from: strDate) ?? Date()

		dateFormatterGet.dateFormat = expectedFromat
		return dateFormatterGet.string(from: date)
	}
	
	
	func SelectCustDtpdown()
	{
	let defaults = UserDefaults.standard

	var RetrivedempId = defaults.integer(forKey: "empId")

	let parameters = ["empId": 80 as Any] as [String : Any]

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
		
		let clientId = Dic["clientId"] as! NSInteger
			MainDict.setObject(clientId, forKey: "clientId" as NSCopying)
		
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
					
		print("Retrived selected id ",selectedclientId)

		let parameters = ["clientId": selectedclientId , "empId": 80 as Any] as [String : Any]
							   
		
								
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
				let empTaskId_h = Dic["empTaskId_h"] as! NSInteger
				MainDict.setObject(empTaskId_h, forKey: "empTaskId_h" as NSCopying)
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
		
		selecteddate = self.getFormattedDate(strDate: datetxtfld.text!, currentFomat: "dd-MMM-yyyy", expectedFromat: "yyyy-MM-dd")
		print("selecteddate...",selecteddate)
		
//		let parameters = [  "date":"2021-05-19",
//							"empId":80,
//	  "empTaskId_h":176 as Any] as [String : Any]
		
				let parameters = ["date":selecteddate,"empId": 80 , "empTaskId_h": selectedempTaskId_h as Any] as [String : Any]

			   
				var StartPoint = "http://122.166.248.191:8080/"
				var Endpoint1 = "attnd-api-gateway-service/api/customer/EmpTimeSheet/EmployeeSubtaskInfoByEmpTaskId"
				let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint1)")!
				
				//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmpPendingLeaveByCustIdAndEmpId")!
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
						DispatchQueue.main.async { [self] in
				let statusDic = responseJSON["status"]! as! NSDictionary
				let LeavePendingCode = statusDic["code"] as? NSInteger
				print("subtask list-----",LeavePendingCode as Any)
							 if (LeavePendingCode == 200)
							{
								
								print("success")
								self.tblbackview.isHidden = false

								timesheettbl.isHidden = false


								
							 }
							else
							{
								print("Failure")

		 
							  print("Not   Leaves")
								//self.Nodataview.isHidden = false
							 }
										 
							
							 self.SubtaskData = NSMutableDictionary()
							if responseJSON != nil{
								self.SubtaskData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
								
								if let temp = self.SubtaskData.value(forKey: "subtasks") as? NSArray{
									self.SubtasklistArray = temp.mutableCopy() as! NSMutableArray
								
									
								}
							}
						self.timesheettbl.reloadData()
		//                }
						}
					}
				}
				task.resume()
	
}
	
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 76
//
//	}
	
	
	
	@IBAction func Checkunchekcbtn(_ sender: Any) {
		
		if checkBoxBtn.isSelected {
			checkBoxBtn.setBackgroundImage(UIImage(named: "check.png"), for: .normal)
			RemarksBackview.isHidden = false


			
			print("unchek button")

		} else {
					//checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "ic_signup_checked"), for:.normal)
					//checkBoxBtn.setImage(UIImage(named:"check.png"), for: .selected)
			//checkBoxBtn.setImage(UIImage(named: "check.png"), for: UIControlState.normal)
			
			checkBoxBtn.setBackgroundImage(UIImage(named: "uncheck.png"), for: .normal)
			RemarksBackview.isHidden = true


			print("chek button")


					
				}
				checkBoxBtn.isSelected = !checkBoxBtn.isSelected
	}
	
	@IBAction func Yesbtnclk(_ sender: Any) {
		let alert = UIAlertController(title: "Alert", message: "Task will be marked as completed on submit", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
		RemarksBackview.isHidden = true

	}
	
	@IBAction func Nobtnclk(_ sender: Any) {
		RemarksBackview.isHidden = true
		checkBoxBtn.setBackgroundImage(UIImage(named: "uncheck.png"), for: .normal)


	}

	
	
	@IBAction func clickherebtnclk(_ sender: Any) {
		NoremarksBackview.isHidden = false
		
	}
	
	@IBAction func Noremarksokbtnclk(_ sender: Any) {
		NoremarksBackview.isHidden = true

	}
	
	@IBAction func Remarksnobtnclk(_ sender: Any) {
		NoremarksBackview.isHidden = true

	}
	
	@IBAction func subBtn(_ sender: Any) {
		
		let okaylbl = UITapGestureRecognizer(target: self, action: #selector(TimesheetVC.okaylblaction))
		oklbl.isUserInteractionEnabled = true
		oklbl.addGestureRecognizer(okaylbl)
		print("update hour list",Selectedhrsstr)
		print("selected empTaskId_d.,",empTaskId_d)

		
//		var postParameters = "name=\(teamName)&member=\(member)"
//		let arr = ["aaa", "wassd", "wesdsd"]
//		var index = 0
//
//		for param in arr{
//			postParameters += "&arr\(index)=\(item)"
//			index++
//		}
//		print(postParameters)
		
		
		let defaults = UserDefaults.standard
		var RetrivedempId = defaults.integer(forKey: "empId")
		print("Retrived empTaskId_Array",empTaskId_Array)

//	let parameters = [["empTaskId_d":285,
//					   "hoursWorked":"12:00",
//		"date":"2021-05-19"],["empTaskId_d":286,
//							  "hoursWorked":"01:00",
//		 "date":"2021-05-19"],["empTaskId_d":288,
//							   "hoursWorked":"02:00","date":"2021-05-19"]]
		let empTaskId_dAry = ["285", "286", "288"]
		let hoursWorkedAry = ["A","B","C"]
		let ints = empTaskId_dAry.map { $0.count }
		print("ints..",ints)

		let datearr = ["2021-05-19", "2021-05-19", "2021-05-19"]

		
//		let parameters = [["empTaskId_d":empTaskId_d,
//						   "hoursWorked":Selectedhrsstr,
//						   "date":selecteddate]]
		
		let parameters = ["empTaskId_h":56,
						  "isTaskClosed":"false",
						  "timeSheet":[["empTaskId_d":empTaskId_d,"hoursWorked":Selectedhrsstr,"date":selecteddate]]] as [String : Any]
		
		
		
		let url: NSURL = NSURL(string:"http://122.166.248.191:8080/attnd-api-gateway-service/api/customer/EmpTimeSheet/EmployeeTimesheetUpdate")!
							
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

		//let statusDic = responseJSON["status"]! as! NSDictionary
		let SelectCustcode = responseJSON["code"] as? NSInteger
			print("SelectCustcode...",SelectCustcode)
		if (SelectCustcode == 200)
		{
			let uiAlert = UIAlertController(title: "success", message: "successfully send to server", preferredStyle: UIAlertControllerStyle.alert)
			self.present(uiAlert, animated: true, completion: nil)

			uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
												
			let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
			self.present(UITabBarController, animated:true, completion:nil)			  }))
		}
		else
		{
		}
									
		}
	}
}
task.resume()

		
	}
	 
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)

		
	}
	
}



