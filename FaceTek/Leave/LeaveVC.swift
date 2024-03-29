//
//  LeaveVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/6/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LeaveVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate {
    var RetrivedcustId = Int()
    var RetrivedempId = Int()
    var custLeaveId = Int()
	var empIsGPSTrackEnabled = Int()
	var custIsTaskManagementEnabled = Int()


    var customView = UIView()
    var customSubView = UIView()
    var validation = ()

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var timer = Timer()
    @IBOutlet weak var SelectLeaveTypeTxtfield: UITextField!
    @IBOutlet weak var LeavesLbl: UILabel!
    @IBOutlet weak var DropdownBackview: UIView!
    //private var Drpdowntbl: UITableView!
    
    @IBOutlet weak var Dropdowntbl: UITableView!
    var LeavetypeDropdownArray:NSMutableArray = NSMutableArray()
	var empIsGPSTrackEnabledArray:NSMutableArray = NSMutableArray()
    var MainDict:NSMutableDictionary = NSMutableDictionary()
    var custLeaveNamestr:String?
    var RetrivedMobileNumber = String()
    var Employeenamestr = String()
    var Todatestr = String()
    var Fromdatestr = String()
    var brNamestr = String()
    private var isAlreadyLoaddropdowndata = false
    private var cleardata = false
    var RefreshemployeeNam : String = ""
    var RefreshbrName : String = ""
    var RetrivedCustmercode : String = ""
	var timesheet : String = ""

	
	@IBOutlet weak var CompanyNameLbl: UILabel!
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var MobilenumberLbl: UILabel!
    @IBOutlet weak var FromView: UIView!
    @IBOutlet weak var Toview: UIView!
    @IBOutlet weak var LeaveTypeview: UIView!
    @IBOutlet weak var LeaveNavigationtbl: UITableView!
	
	@IBOutlet weak var menutblheight: NSLayoutConstraint!
	
//     //var LeaveNavigationMenuArray = ["Holiday Calender","FAQ","Contact Us"]
//    var LeaveNavigationMenuArray = ["Holiday Calender","Time Sheet","Attendance History","Field Visit","My Team","Expense Claim","Leave History","FAQ","Contact Us"]
//
//	var TimesheetHomeDashboardNavigationMenuArray = ["Holiday Calender","Attendance History","Field Visit","My Team","Expense Claim","Leave History","FAQ","Contact Us",""]
//
//	var TimesheetLeaveNavigationMenuImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navvisitor.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!,]
//
//
//
//
//	var LeaveNavigationMenuImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navtimesheet.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navvisitor.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!]
//
//
//	var LeaveNavigationMenuGPSFalseArray = ["Holiday Calender","Attendance History","My Team","Expense Claim","Leave History","FAQ","Contact Us","",""]
//	var HomeDashboardGPSFalseImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!]
//
//
//
//
//
	// GPS and timemanagement true
	var HomeDashboardNavigationMenuArray = ["Holiday Calender","Time Sheet","Attendance History","Field Visit","My Team","Expense Claim","Leave History","FAQ","Contact Us"]
	// GPS and timemanagement false
	var HomeDashboardGPSFalseArray = ["Holiday Calender","Attendance History","My Team","Expense Claim","Leave History","FAQ","Contact Us","",""]

	
	//GPS True and timemanagement false
	var HomeDashboardTimemanagementFalseArray = ["Holiday Calender","Attendance History","Field Visist","My Team","Expense Claim","Leave History","FAQ","Contact Us",""]
	var HomeDashboardTimemanagementimagesFalseArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navvisitor.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!,]
	
	
	//Timemanagement true and GPS false
	var TimesheetHomeDashboardNavigationMenuArray = ["Holiday Calender","Attendance History","Timesheet","My Team","Expense Claim","Leave History","FAQ","Contact Us",""]
	//Timemanagement true and GPS false
	var TimesheetLeaveNavigationMenuImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navtimesheet.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!,]

	// GPS and timemanagement true
	var HomeDashboardNavigationMenuImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navtimesheet.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navvisitor.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!]

	// GPS and timemanagement false
	var HomeDashboardGPSFalseImagesArray: [UIImage] = [UIImage(named: "Navcalendar.png")!,UIImage(named: "Navattendance_history.png")!,UIImage(named: "Navnetwork.png")!,UIImage(named: "Navclaim.png")!,UIImage(named: "Navhistory.png")!,UIImage(named: "Navquestionnaire.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!,UIImage(named: "Navcall.png")!]


	
	
	
	
	
	
	

    var isMenuVisible:Bool!
    @IBOutlet weak var hamburgerView: UIView!
	@IBOutlet weak var AppliedLeavePopup: UIView!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var ContactUsView: UIView!
    @IBOutlet weak var ContactUsadrstextview: UITextView!
    @IBOutlet weak var RemarkTextview: UITextView!
    @IBOutlet weak var Fromtxt: UITextField!
    @IBOutlet weak var Totxt: UITextField!
    // @IBOutlet weak var LeaveTypetxt: UITextField!
    @IBOutlet weak var LeaveTypetxt: UILabel!
    @IBOutlet weak var FromBtn: UIButton!
    @IBOutlet weak var ToBtn: UIButton!
    var button: HamburgerButton! = nil
	@IBOutlet weak var CompanyPowerLbl: UILabel!
	
    let FromdatePicker = UIDatePicker()
    let TodatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
		
		LeaveNavigationtbl.rowHeight = 39
		Dropdowntbl.rowHeight = 50


		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		let statusBarColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 0.9680276113)
			statusBarView.backgroundColor = statusBarColor
		view.addSubview(statusBarView)
		
		//Tableview Empty row lines removed
		LeaveNavigationtbl.tableFooterView = UIView()

		
		CompanyPowerLbl.font = UIFont(name: "Verdana", size: 10.0)!
		let Datetxtattributes :Dictionary = [NSAttributedStringKey.font :CompanyPowerLbl.font]
		CompanyPowerLbl.textColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)

		
			AppliedLeavePopup.isHidden = true
	startLoadingSpinner()
	timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
	RefreshLoadingData()
	ContactUsadrstextview.isEditable = false
	NotificationCenter.default.addObserver(self, selector: #selector(LeaveVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	NotificationCenter.default.addObserver(self, selector: #selector(LeaveVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	DropdownBackview.isHidden = true
	LeavesLbl.isHidden = true
	customActivityIndicatory(self.view, startAnimate: false)
	menu.layer.shadowOffset = .zero
	menu.layer.shadowColor = UIColor.gray.cgColor
	menu.layer.shadowRadius = 0
	menu.layer.shadowOpacity = 1
	menu.layer.shadowPath = UIBezierPath(rect: menu.bounds).cgPath
	let shadowPath = UIBezierPath(rect: view.bounds)
	menu.layer.masksToBounds = false
	menu.layer.shadowColor = UIColor.gray.cgColor
	menu.layer.shadowOffset = CGSize(width: 0, height: 0.5)
	menu.layer.shadowOpacity = 0.2
	menu.layer.shadowPath = shadowPath.cgPath
	self.DropdownBackview.layer.masksToBounds = false
	self.DropdownBackview.layer.cornerRadius = 5
	self.DropdownBackview.layer.shadowColor = UIColor.black.cgColor
	self.DropdownBackview.layer.shadowPath = UIBezierPath(roundedRect: self.DropdownBackview.bounds, cornerRadius: self.DropdownBackview.layer.cornerRadius).cgPath
	self.DropdownBackview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
	self.DropdownBackview.layer.shadowOpacity = 0.1
	self.DropdownBackview.layer.shadowRadius = 1.0
	self.Dropdowntbl.layer.masksToBounds = false
	self.Dropdowntbl.layer.cornerRadius = 5
	self.Dropdowntbl.layer.shadowColor = UIColor.black.cgColor
	self.Dropdowntbl.layer.shadowPath = UIBezierPath(roundedRect:self.Dropdowntbl.bounds, cornerRadius: self.Dropdowntbl.layer.cornerRadius).cgPath
	self.Dropdowntbl.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
	self.Dropdowntbl.layer.shadowOpacity = 0.1
	self.Dropdowntbl.layer.shadowRadius = 1.0
	let tap = UITapGestureRecognizer(target: self, action: #selector(LeaveVC.tapFunction))
	SelectLeaveTypeTxtfield.isUserInteractionEnabled = true
	SelectLeaveTypeTxtfield.addGestureRecognizer(tap)
	isMenuVisible = true
	menu.isHidden = true
	ContactUsView.isHidden = true
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	print("RetrivedcustId----",RetrivedcustId)
	RetrivedempId = defaults.integer(forKey: "empId")
	print("RetrivedempId----",RetrivedempId)
	Dropdowntbl.isHidden = true
	RemarkTextview.text = "  Remarks"
	RemarkTextview.textColor = UIColor.lightGray
	RemarkTextview.font = UIFont(name: "verdana", size: 13.0)
	RemarkTextview.returnKeyType = .done
	RemarkTextview.delegate = self
	LeaveNavigationtbl.register(UINib(nibName: "LeaveNavigationcell", bundle: nil), forCellReuseIdentifier: "LeaveNavigationcell")
	Dropdowntbl.register(UINib(nibName: "Dropdowncell", bundle: nil), forCellReuseIdentifier: "Dropdowncell")
		LeaveNavigationtbl.isScrollEnabled = false
	RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
	MobilenumberLbl.text = RetrivedMobileNumber
	self.MobilenumberLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
	let Mobnumbattributes :Dictionary = [NSAttributedStringKey.font : self.MobilenumberLbl.font]
		self.MobilenumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//		self.MobilenumberLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
//		let Usernameatributes :Dictionary = [NSAttributedStringKey.font : self.MobilenumberLbl.font]
//		self.MobilenumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		self.ContactUsadrstextview.font = UIFont(name: "Verdana", size: 12.0)!
		let contactusattributes :Dictionary = [NSAttributedStringKey.font : self.ContactUsadrstextview.font]
		self.ContactUsadrstextview.textColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)


        
//        Employeenamestr = defaults.string(forKey: "employeeName") ?? ""
//        UserNameLbl.text = Employeenamestr
//
//        brNamestr = defaults.string(forKey: "brName") ?? ""
       // print("brNamestr-----",brNamestr)
	CompanyNameLbl.text = brNamestr
	self.button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
	self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
	self.hamburgerView.addSubview(button)
	FromView.layer.borderWidth = 1
	FromView.layer.borderColor = UIColor.darkGray.cgColor
	Toview.layer.borderWidth = 1
	Toview.layer.borderColor = UIColor.darkGray.cgColor
	LeaveTypeview.layer.borderWidth = 1
	LeaveTypeview.layer.borderColor = UIColor.darkGray.cgColor
	RemarkTextview.layer.borderWidth = 1
	RemarkTextview.layer.borderColor = UIColor.darkGray.cgColor
	FromDatesetDatePicker()
	ToDatesetDatePicker()
	FromBtn.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchUpInside)
	Totxt.isUserInteractionEnabled = false
		
		//For empIsGPSTrackEnabled
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		
		var empIsGPSTrackEnabledStartPoint = Baseurl.shared().baseURL
		var empIsGPSTrackEnabledEndpoint = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboardNew"
		
		let url: NSURL = NSURL(string:"\(empIsGPSTrackEnabledStartPoint)\(empIsGPSTrackEnabledEndpoint)")!
		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboardNew")!
		
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
				
				DispatchQueue.main.async
				{ [self] in
						
						var MainDict:NSMutableDictionary = NSMutableDictionary()
						self.empIsGPSTrackEnabled = (responseJSON["empIsGPSTrackEnabled"] as? Int)!
						MainDict.setObject(self.empIsGPSTrackEnabled, forKey: "empIsGPSTrackEnabled" as NSCopying)
						self.empIsGPSTrackEnabledArray.add(self.MainDict)
					self.custIsTaskManagementEnabled = (responseJSON["custIsTaskManagementEnabled"] as? Int)!
				
					print("Leave time...",custIsTaskManagementEnabled)

					
					if (responseJSON["custIsTaskManagementEnabled"] != nil) == true {
						self.timesheet = "success"
							print("leave Login Successful",self.timesheet)
						} else {
							self.timesheet = "failure"

							
							print("leave Login attempt failed",self.timesheet)
						}
					
					
					
					
						self.LeaveNavigationtbl.reloadData()

						
				}
				
			}

			
			
		}
		task.resume()

        
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
	if Dropdowntbl.isHidden {
	Dropdowntbl.isHidden = false
	DropdownBackview.isHidden = false
	LeavesLbl.isHidden = false
    APIDropdowntabledata()
        } else {
	Dropdowntbl.isHidden = true
	DropdownBackview.isHidden = true
	LeavesLbl.isHidden = true
            
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
	if RemarkTextview.text == " Remarks" {
	RemarkTextview.text = ""
	RemarkTextview.textColor = UIColor.black
	RemarkTextview.font = UIFont(name: "verdana", size: 14.0)
			
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            RemarkTextview.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
	if RemarkTextview.text == "" {
	RemarkTextview.text = " Remarks"
	RemarkTextview.textColor = UIColor.lightGray
	RemarkTextview.font = UIFont(name: "verdana", size: 14.0)
	RemarkTextview.resignFirstResponder()

        }
    }
    @objc func toggle(_ sender: AnyObject!) {
        self.toggleComparision()
        menu.isHidden = false
        self.button.showsMenu = !self.button.showsMenu
    }
    //Menu code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        self.view.endEditing(true)
        //        isMenuVisible = false;
        //        self.button.showsMenu = !self.button.showsMenu
        //        self.toggleComparision()
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        toggle(sender as AnyObject)
    }
    
    func toggleComparision()
    {
	if (isMenuVisible)
	{
	UIView.transition(with: menu, duration: 0.3, options: .beginFromCurrentState, animations: {
	var frame = self.menu.frame
	frame.origin.x = 0
	self.menu.frame = frame
	self.isMenuVisible = false;
	self.menu.isHidden = false
            })
	} else {
	UIView.transition(with: menu, duration: 0.3, options: .beginFromCurrentState, animations: {
	var frame = self.menu.frame
	frame.origin.x = -self.view.frame.size.width
	self.menu.frame = frame
	}) { (finished) in
	if finished {
	self.isMenuVisible = true
	self.menu.isHidden = true
                }
            }
        }
    }
    
    
    @IBAction func FromBtnclk(_ sender: UIButton) {
        FromDatesetDatePicker()
        
    }
    
    @objc func FromDatesetDatePicker() {
        //Format Date
	FromdatePicker.datePickerMode = .date
        //ToolBar
	let toolbar = UIToolbar();
	toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
	let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
	let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
	toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
	Fromtxt.inputAccessoryView = toolbar
	Fromtxt.inputView = FromdatePicker
        
    }
    
    @objc func doneDatePicker(){
	let formatter = DateFormatter()
	formatter.dateFormat = "dd-MMM-yyyy"
	Fromtxt.text = formatter.string(from: FromdatePicker.date)
	Totxt.text = formatter.string(from: FromdatePicker.date)
	Totxt.isUserInteractionEnabled = true
	Fromdatestr = formattedDateFromString(dateString: Fromtxt.text!, withFormat: "yyyy-MM-dd")!
	print("Fromdatestr---",Fromdatestr)
	Todatestr = formattedDateFromString(dateString: Totxt.text!, withFormat: "yyyy-MM-dd")!
	print("Todatestr---",Todatestr)
	self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func ToDatesetDatePicker() {
        //Format Date
	TodatePicker.datePickerMode = .date
        //ToolBar
	let toolbar = UIToolbar();
	toolbar.sizeToFit()
	let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TodatedoneDatePicker));
	let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
	let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
	Totxt.inputAccessoryView = toolbar
	Totxt.inputView = TodatePicker
        
    }
    @objc func TodatedoneDatePicker(){
	let formatter = DateFormatter()
	formatter.dateFormat = "dd-MMM-yyyy"
	Totxt.text = formatter.string(from: TodatePicker.date)
	Todatestr = formattedDateFromString(dateString: Totxt.text!, withFormat: "yyyy-MM-dd")!
	print("Todatestr---",Todatestr)
	self.view.endEditing(true)
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
	let inputFormatter = DateFormatter()
	inputFormatter.dateFormat = "dd/MM/yyyy"
	if let date = inputFormatter.date(from: dateString) {
	let outputFormatter = DateFormatter()
	outputFormatter.dateFormat = format
	return outputFormatter.string(from: date)
        }
        
	return nil
    }
    
    @IBAction func DropdownBtnclk(_ sender: Any) {
	if Dropdowntbl.isHidden {
	Dropdowntbl.isHidden = false
	DropdownBackview.isHidden = false
	LeavesLbl.isHidden = false
	APIDropdowntabledata()
        } else {
	Dropdowntbl.isHidden = false
	DropdownBackview.isHidden = false
	LeavesLbl.isHidden = false
        }
    }
    
    func APIDropdowntabledata()
    {
        if isAlreadyLoaddropdowndata {
            return
        }
        
	isAlreadyLoaddropdowndata = true
	print("calling API Dropdown data")
	let parameters = [
            "custId": RetrivedcustId] as [String : Any]
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getLeaveListByCustId"
		
	let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint1)")!
	customActivityIndicatory(self.view, startAnimate: true)
	let session = URLSession.shared
	var request = URLRequest(url: url as URL)
	request.httpMethod = "POST" //set http method as POST
	do {
	request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
	print("Json Response",responseJSON)
	DispatchQueue.main.async {
	let custLeaveTypeDtoListDict = responseJSON["custLeaveTypeDtoList"] as! NSArray
	print("Array values----",custLeaveTypeDtoListDict)
	for LeaveTypesubDictionary in custLeaveTypeDtoListDict as! [[String:Any]]
	{
	var MainDict:NSMutableDictionary = NSMutableDictionary()
	self.custLeaveNamestr = LeaveTypesubDictionary["custLeaveName"] as? String
	print("custLeaveName-------",self.custLeaveNamestr)
	MainDict.setObject(self.custLeaveNamestr, forKey: "custLeaveName" as NSCopying)
	self.custLeaveId = (LeaveTypesubDictionary["custLeaveId"] as? NSInteger)!
	print("custLeaveId-------",self.custLeaveId)
	MainDict.setObject(self.custLeaveNamestr, forKey: "custLeaveName" as NSCopying)
	MainDict.setObject(self.custLeaveId, forKey: "custLeaveId" as NSCopying)
	self.LeavetypeDropdownArray.add(MainDict)
	self.Dropdowntbl.reloadData()
	}
	self.customActivityIndicatory(self.view, startAnimate: false)
	}
}
}
task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	var count:Int?
	if tableView == self.LeaveNavigationtbl {
	count = HomeDashboardNavigationMenuArray.count
	return count!
        }
	else{
		if tableView == self.LeaveNavigationtbl {
		count = HomeDashboardGPSFalseArray.count
		return count!
		
		}
		}
		
		
            //if tableView == self.Dropdowntbl {
	if tableView == self.Dropdowntbl {
	count =  LeavetypeDropdownArray.count
        }
	return count!
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		print("Leave empIsGPSTrackEnabled-------",self.empIsGPSTrackEnabled)

	var cellToReturn = UITableViewCell() // Dummy value
	if tableView == self.LeaveNavigationtbl {
		
//		//if (timesheet == "failure")
//
//
//			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
//			//cell.accessoryType = .disclosureIndicator
//			// set the text from the data model
//
//
//			cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
//			//cell.LeaveNavigationLbl.font = UIFont(name: "verdana", size: 18.0)
//
//			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
//			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//
//			cell.LeaveNavigationLbl?.text = self.TimesheetHomeDashboardNavigationMenuArray[indexPath.row]
//
//			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
//			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
//			let image = TimesheetLeaveNavigationMenuImagesArray[indexPath.row]
//			cell.LeaveNavigationimg.image = image
//
//			customActivityIndicatory(self.view, startAnimate: false)
//			cellToReturn = cell
//				print("timesheet calling in ",timesheet)
//
//
//
//		 if(empIsGPSTrackEnabled == 1)
//		{
//	let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell") as! LeaveNavigationcell
//	//cell.accessoryType = .disclosureIndicator
//
//
//		cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
//		let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
//		cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
//	cell.LeaveNavigationLbl?.text = self.HomeDashboardNavigationMenuArray[indexPath.row]
//
//			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
//			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
//
//			let image = HomeDashboardNavigationMenuImagesArray[indexPath.row]
//			cell.LeaveNavigationimg.image = image
//	cellToReturn = cell
//		}
//		else
//		{
//			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell") as! LeaveNavigationcell
//			//cell.accessoryType = .disclosureIndicator
//
//
//				cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
//				let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
//				cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
//			cell.LeaveNavigationLbl?.text = self.HomeDashboardGPSFalseArray[indexPath.row]
//			let image = HomeDashboardGPSFalseImagesArray[indexPath.row]
//			cell.LeaveNavigationimg.image = image
//
//			cellToReturn = cell
//
//		}
		
		if (empIsGPSTrackEnabled == 1 && custIsTaskManagementEnabled == 1)
			{
			self.menutblheight?.constant = 300

			
			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			//cell.accessoryType = .disclosureIndicator
			// set the text from the data model
			
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
			//cell.LeaveNavigationLbl.font = UIFont(name: "verdana", size: 18.0)
			
			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
			
			cell.LeaveNavigationLbl?.text = self.HomeDashboardNavigationMenuArray[indexPath.row]
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			let image = HomeDashboardNavigationMenuImagesArray[indexPath.row]
			cell.LeaveNavigationimg.image = image

			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
				print("timesheet calling in ",timesheet)

			}
		
		else if (empIsGPSTrackEnabled != 1 && custIsTaskManagementEnabled == 1)
		{
			self.menutblheight?.constant = 270

			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			//cell.accessoryType = .disclosureIndicator
			// set the text from the data model


			cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
			//cell.LeaveNavigationLbl.font = UIFont(name: "verdana", size: 18.0)

			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

			cell.LeaveNavigationLbl?.text = self.TimesheetHomeDashboardNavigationMenuArray[indexPath.row]

			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			let image = TimesheetLeaveNavigationMenuImagesArray[indexPath.row]
			cell.LeaveNavigationimg.image = image

			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
				print("timesheet calling in ",timesheet)

		}
		else if (empIsGPSTrackEnabled == 1 && custIsTaskManagementEnabled != 1)
		{
			self.menutblheight?.constant = 270
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			//cell.accessoryType = .disclosureIndicator
			// set the text from the data model
			
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
			//cell.LeaveNavigationLbl.font = UIFont(name: "verdana", size: 18.0)
			
			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
			
			cell.LeaveNavigationLbl?.text = self.HomeDashboardTimemanagementFalseArray[indexPath.row]
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			let image = HomeDashboardTimemanagementimagesFalseArray[indexPath.row]
			cell.LeaveNavigationimg.image = image

			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
				print("timesheet calling in ",timesheet)

		}


		else
		{
			self.menutblheight?.constant = 280

			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			//cell.accessoryType = .disclosureIndicator
			// set the text from the data model
			
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Verdana", size: 15.0)!
			//cell.LeaveNavigationLbl.font = UIFont(name: "verdana", size: 18.0)
			
			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
			
			cell.LeaveNavigationLbl?.text = self.HomeDashboardGPSFalseArray[indexPath.row]
			
			cell.LeaveNavigationLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let LeavesMenuattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			let image = HomeDashboardGPSFalseImagesArray[indexPath.row]
			cell.LeaveNavigationimg.image = image

			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
				print("timesheet calling in ",timesheet)

			
		}
		
		
		
    } else if tableView == self.Dropdowntbl {
	let cell = tableView.dequeueReusableCell(withIdentifier: "Dropdowncell") as! Dropdowncell
	let responseDict = self.LeavetypeDropdownArray[indexPath.row] as! NSMutableDictionary
			            _ = LeavetypeDropdownArray[indexPath.row]
	print("Retrived data",responseDict)
	self.LeavetypeDropdownArray.add(MainDict)
	print("Leave Type Array",LeavetypeDropdownArray)
	var custLeaveNamestr : String?
	custLeaveNamestr = responseDict["custLeaveName"] as? String
	print("custLeaveNamestr",custLeaveNamestr)
	cell.DropdownLbl!.text = custLeaveNamestr
	cellToReturn = cell
		   }
	return cellToReturn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
		
		
//			if indexPath.row == 0 {
//				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//				let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//				self.present(CalendarVC, animated:true, completion:nil)
//
//
//			}
//
//				else if indexPath.item == 1 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
//					self.present(AttendanceHistoryVC, animated:true, completion:nil)
//
//
//				}
//
//				else if indexPath.item == 2 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let FieldVisitVC = storyBoard.instantiateViewController(withIdentifier: "FieldVisitVC") as! FieldVisitVC
//					self.present(FieldVisitVC, animated:true, completion:nil)
//
//
//				}
//				else if indexPath.item == 3 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
//					self.present(MyTeamVC, animated:true, completion:nil)
//
//
//				}
//				else if indexPath.item == 4 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
//					self.present(ExpenseClaimVC, animated:true, completion:nil)
//
//
//				}
//
//				else if indexPath.item == 5 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
//					self.present(LeaveHistoryVC, animated:true, completion:nil)
//
//
//				}
//				else if indexPath.item == 6 {
//					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//					let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
//					self.present(FaqVC, animated:true, completion:nil)
//
//
//				}
//
		
		
		
		
		 if (tableView == LeaveNavigationtbl)
			
		{
			
			if (empIsGPSTrackEnabled == 1 && custIsTaskManagementEnabled == 1)

			{
				
				
						if indexPath.row == 0 {
							let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
							let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
							self.present(CalendarVC, animated:true, completion:nil)
				
				
				
				
						}
				
							else if indexPath.item == 1 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let TimesheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetVC") as! TimesheetVC
								self.present(TimesheetVC, animated:true, completion:nil)
				
				
							}
				
							else if indexPath.item == 2 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
								self.present(AttendanceHistoryVC, animated:true, completion:nil)
				
				
							}
				
				
							else if indexPath.item == 3 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let FieldVisitVC = storyBoard.instantiateViewController(withIdentifier: "FieldVisitVC") as! FieldVisitVC
								self.present(FieldVisitVC, animated:true, completion:nil)
				
				
							}
							else if indexPath.item == 4 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
								self.present(MyTeamVC, animated:true, completion:nil)
				
				
							}
							else if indexPath.item == 5 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
								self.present(ExpenseClaimVC, animated:true, completion:nil)
				
				
							}
				
							else if indexPath.item == 6 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
								self.present(LeaveHistoryVC, animated:true, completion:nil)
				
				
							}
				
						else if indexPath.item == 7 {
							let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
							let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
							self.present(FaqVC, animated:true, completion:nil)
				
				
						}
	//					else if indexPath.item == 8 {
	//
	//						if ContactusText.isHidden {
	//							//ContactUsView.isHidden = false
	//							ContactusText.isHidden = false
	//						} else {
	//							//ContactUsView.isHidden = true
	//							ContactusText.isHidden = true
	//						}
	//
	//					}
						}
			
			else if (empIsGPSTrackEnabled != 1 && custIsTaskManagementEnabled == 1)
			{
				if indexPath.row == 0 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
					self.present(CalendarVC, animated:true, completion:nil)
					}
				else if indexPath.item == 1 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
					self.present(AttendanceHistoryVC, animated:true, completion:nil)


				}
				else if indexPath.item == 2 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let TimesheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetVC") as! TimesheetVC
					self.present(TimesheetVC, animated:true, completion:nil)


				}
				else if indexPath.item == 3 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
					self.present(MyTeamVC, animated:true, completion:nil)


				}
				else if indexPath.item == 4 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
					self.present(ExpenseClaimVC, animated:true, completion:nil)


				}

				else if indexPath.item == 5 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
					self.present(LeaveHistoryVC, animated:true, completion:nil)


				}
				else if indexPath.item == 6 {
					let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

					let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
					self.present(FaqVC, animated:true, completion:nil)


				}
	//			else if indexPath.item == 7 {
	//
	//				if ContactusText.isHidden {
	//					//ContactUsView.isHidden = false
	//					ContactusText.isHidden = false
	//				} else {
	//					//ContactUsView.isHidden = true
	//					ContactusText.isHidden = true
	//				}
	//
	//			}


		}
			
			else if (empIsGPSTrackEnabled == 1 && custIsTaskManagementEnabled != 1)
			
			{
				print("GPS values working")
				
							if indexPath.row == 0 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
								self.present(CalendarVC, animated:true, completion:nil)
								}
							else if indexPath.item == 1 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
								self.present(AttendanceHistoryVC, animated:true, completion:nil)
				
				
							}
							else if indexPath.item == 2 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let FieldVisitVC = storyBoard.instantiateViewController(withIdentifier: "FieldVisitVC") as! FieldVisitVC
								self.present(FieldVisitVC, animated:true, completion:nil)
				
				
							}
							else if indexPath.item == 3 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
								self.present(MyTeamVC, animated:true, completion:nil)
				
				
							}
							else if indexPath.item == 4 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
								self.present(ExpenseClaimVC, animated:true, completion:nil)
				
				
							}
				
							else if indexPath.item == 5 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
								self.present(LeaveHistoryVC, animated:true, completion:nil)
				
				
							}
				
						else if indexPath.item == 6 {
							let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
							let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
							self.present(FaqVC, animated:true, completion:nil)
						}
					}
			
			else{
				print("gps and timemanagement false")
				if indexPath.row == 0 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
								self.present(CalendarVC, animated:true, completion:nil)
				
				
							}
				
								else if indexPath.item == 1 {
									let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
									let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
									self.present(AttendanceHistoryVC, animated:true, completion:nil)
				
				
								}
				
				
				
								else if indexPath.item == 2 {
									let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
									let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
									self.present(MyTeamVC, animated:true, completion:nil)
				
				
								}
								else if indexPath.item == 3 {
									let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
									let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
									self.present(ExpenseClaimVC, animated:true, completion:nil)
				
				
								}
				
								else if indexPath.item == 4 {
									let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
									let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
									self.present(LeaveHistoryVC, animated:true, completion:nil)
				
				
								}
				
							else if indexPath.item == 5 {
								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				
								let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
								self.present(FaqVC, animated:true, completion:nil)
				
				
							}
	//						else if indexPath.item == 6 {
	//
	//							if ContactusText.isHidden {
	//								//ContactUsView.isHidden = false
	//								ContactusText.isHidden = false
	//							} else {
	//								//ContactUsView.isHidden = true
	//								ContactusText.isHidden = true
	//							}
	//
	//
	//
	//						}
				
			}

			
			
			
			//if(empIsGPSTrackEnabled == 1)
//			{
//				if indexPath.row == 0 {
//						let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//						let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//						self.present(CalendarVC, animated:true, completion:nil)
//					   }
//							else if indexPath.item == 1 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let TimesheetVC = storyBoard.instantiateViewController(withIdentifier: "TimesheetVC") as! TimesheetVC
//								self.present(TimesheetVC, animated:true, completion:nil)
//
//
//							}
//
//					else if indexPath.item == 2 {
//									let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//									let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
//									self.present(AttendanceHistoryVC, animated:true, completion:nil)
//
//
//								}
//
//					   else if indexPath.item == 3 {
//					   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//					   let FieldVisitVC = storyBoard.instantiateViewController(withIdentifier: "FieldVisitVC") as! FieldVisitVC
//						self.present(FieldVisitVC, animated:true, completion:nil)
//						}
//							else if indexPath.item == 4 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
//								self.present(MyTeamVC, animated:true, completion:nil)
//
//
//							}
//
//							else if indexPath.item == 5 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
//								self.present(ExpenseClaimVC, animated:true, completion:nil)
//
//
//							}
//
//							else if indexPath.item == 6 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
//								self.present(LeaveHistoryVC, animated:true, completion:nil)
//
//
//							}
//
//
//						else if indexPath.item == 7 {
//						let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//						let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
//						self.present(FaqVC, animated:true, completion:nil)
//						}
//						else if indexPath.item == 8 {
//						if ContactUsView.isHidden {
//						ContactUsView.isHidden = false
//						} else {
//						ContactUsView.isHidden = true
//						}
//					}
//		}
//			else{
//				if indexPath.row == 0 {
//						let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//						let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//						self.present(CalendarVC, animated:true, completion:nil)
//					   }
//							else if indexPath.item == 1 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let AttendanceHistoryVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceHistoryVC") as! AttendanceHistoryVC
//								self.present(AttendanceHistoryVC, animated:true, completion:nil)
//
//
//							}
//
//							else if indexPath.item == 2 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let MyTeamVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamVC") as! MyTeamVC
//								self.present(MyTeamVC, animated:true, completion:nil)
//
//
//							}
//
//							else if indexPath.item == 3 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
//								self.present(ExpenseClaimVC, animated:true, completion:nil)
//
//
//							}
//
//							else if indexPath.item == 4 {
//								let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//								let LeaveHistoryVC = storyBoard.instantiateViewController(withIdentifier: "LeaveHistoryVC") as! LeaveHistoryVC
//								self.present(LeaveHistoryVC, animated:true, completion:nil)
//
//
//							}
//
//
//						else if indexPath.item == 5 {
//						let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//						let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
//						self.present(FaqVC, animated:true, completion:nil)
//						}
//						else if indexPath.item == 6 {
//						if ContactUsView.isHidden {
//						ContactUsView.isHidden = false
//						} else {
//						ContactUsView.isHidden = true
//						}
//					}
//
//			}

		}
		else
		{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Dropdowncell") as! Dropdowncell
		let responseDict = self.LeavetypeDropdownArray[indexPath.row] as! NSMutableDictionary
				_ = LeavetypeDropdownArray[indexPath.row]
		print("Retrived data",responseDict)
		self.LeavetypeDropdownArray.add(MainDict)
		print("Leave Type Array",LeavetypeDropdownArray)
		var custLeaveNamestr : String?
		custLeaveNamestr = responseDict["custLeaveName"] as? String
		print("custLeaveNamestr",custLeaveNamestr as Any)
				//cell.textLabel!.text = custLeaveNamestr
		SelectLeaveTypeTxtfield.text = "" + " " + custLeaveNamestr!
		cell.DropdownLbl!.text = custLeaveNamestr
				//LeaveTypetxt.text = custLeaveNamestr!
		tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
		self.custLeaveId = (responseDict["custLeaveId"] as? NSInteger)!
		print("Selected Customer Id",custLeaveId)
		Dropdowntbl.isHidden = true
		DropdownBackview.isHidden = true
		LeavesLbl.isHidden = true
				
			}
		}
	
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    @IBAction func SubmitBtnclk(_ sender: Any) {
	let Fromtxt = self.Fromtxt.text
	let Totxt = self.Totxt.text
	let Leaveselect = self.SelectLeaveTypeTxtfield.text
	let Remark = self.RemarkTextview.text
	if (Fromtxt == "")
         {
       // if (Fromtxt == "" || Totxt == "" || SelectLeaveTypeTxtfield.text == "" ){
	let alert = UIAlertController(title: "Error", message: "Fill up  all mandatory fields", preferredStyle: UIAlertController.Style.alert)
	alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
	self.present(alert, animated: true, completion: nil)
               return
           }
    else if (SelectLeaveTypeTxtfield.text == "")
         {
            
	let alert = UIAlertController(title: "Error", message: "Select Leave Type", preferredStyle: UIAlertController.Style.alert)
	alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
	self.present(alert, animated: true, completion: nil)
	return
}
   else {
	let parameters = ["empId": RetrivedempId as Any,"custLeaveId": custLeaveId as Any,"empLeaveFrom": Fromdatestr as Any,"empLeaveTo": Todatestr as Any,"empLeaveRemarks":RemarkTextview.text as Any] as [String : Any]
            
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint2 = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/apply"
	let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint2)")!
	self.customActivityIndicatory(self.view, startAnimate: true)
	let session = URLSession.shared
	var request = URLRequest(url: url as URL)
	request.httpMethod = "POST" //set http method as POST
	do {
	request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
	print("Json Response",responseJSON)
	DispatchQueue.main.async {
	let code = responseJSON["code"]! as! NSInteger
	print("code---",code)
	if(code == 200)
	{
    let code = responseJSON["code"]! as! NSInteger
	let message = responseJSON["message"]! as! NSString
	//Leave PopUp method calling
	//self.LeavePopUp()
	self.AppliedLeavePopup.isHidden = false
	self.RemarkTextview.resignFirstResponder()
		
	}
	else
	{
	let message = responseJSON["message"]! as! NSString
	let alert = UIAlertController(title: "Alert", message: message as String, preferredStyle: UIAlertController.Style.alert)
	alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
	self.present(alert, animated: true, completion: nil)
	}
    self.customActivityIndicatory(self.view, startAnimate: false)
            
	}
	}
}
task.resume()
		
		}
    }
    
    
	@IBAction func LeaveOkBtnclk(_ sender: Any) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
	let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
	self.present(UITabBarController, animated:true, completion:nil)
        
	}
	@objc func buttonAction(_ sender:UIButton!)
    {
	let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
	let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
	self.present(UITabBarController, animated:true, completion:nil)
        
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        Fromtxt.text = ""
        
    }
    
    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
        mainContainer.alpha = 0.5
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.darkGray
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate!{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        }else{
            for subview in viewContainer.subviews{
                if subview.tag == 789456123{
                    subview.removeFromSuperview()
                }
            }
        }
        return activityIndicatorView
    }
	
	
	@objc func keyboardWillShow(sender: NSNotification) {
		 self.view.frame.origin.y = -200 // Move view 150 points upward
	}

	@objc func keyboardWillHide(sender: NSNotification) {
		 self.view.frame.origin.y = 0 // Move view to original position
	}
	
//    @objc func keyboardWillShow(notification: Notification) {
//	if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//	print("notification: Keyboard will show")
//	if self.view.frame.origin.y == 0{
//	self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    @objc func keyboardWillHide(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    func LeavePopUp()
    {
        self.customView.frame = CGRect.init(x: 0, y: 0, width: 230, height: 300)
        self.customView.backgroundColor = UIColor.white     //give color to the view
        self.customView.center = self.view.center
        self.view.addSubview(self.customView)
        self.customSubView.frame = CGRect.init(x: 0, y: 0, width: 230, height: 150)
        self.customSubView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        let shadowPath = UIBezierPath(rect: self.customView.bounds)
        self.customView.layer.masksToBounds = false
        self.customView.layer.shadowColor = UIColor.darkGray.cgColor
        self.customView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.customView.layer.shadowOpacity = 0.8
        self.customView.layer.shadowPath = shadowPath.cgPath
        self.customView.addSubview(self.customSubView)
        //image
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 65, y: 10, width: 100, height: 100));
        imageView.image = UIImage(named:"conform.png")
        self.customView.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 55, y: 110, width: 200, height: 21));
        label.text = "Thank you!"
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textColor = UIColor.white
        self.customView.addSubview(label)
        let label1 = UILabel(frame: CGRect(x: 20, y: 175, width: 400, height: 21))
        label1.text = "Leave Applied Successfully"
        label1.textColor = UIColor.darkGray
        label1.shadowColor = UIColor.gray
        label1.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        self.customView.addSubview(label1)
        let myButton = UIButton(type: .system)
        myButton.frame = CGRect(x: 70, y: 210, width: 100, height: 50)
        // Set text on button
        myButton.setTitle("OK", for: .normal)
        myButton.setTitle("Pressed + Hold", for: .highlighted)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        myButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        self.customView.addSubview(myButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
	if cleardata {
	Fromtxt.text = nil
    Fromtxt.placeholder = "From"
	Totxt.text = nil
	Totxt.placeholder = "To"
		SelectLeaveTypeTxtfield.text = nil
		SelectLeaveTypeTxtfield.placeholder = "Leave Type"
		
	RemarkTextview.text = nil
	RemarkTextview.text = " Remarks"
    RemarkTextview.textColor = UIColor.lightGray
	RemarkTextview.font = UIFont(name: "verdana", size: 14.0)
	startLoadingSpinner()
	timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
            return
        }
	cleardata = true
	RemarkTextview.text = nil
	RemarkTextview.text = " Remarks"
	RemarkTextview.textColor = UIColor.lightGray
	RemarkTextview.font = UIFont(name: "verdana", size: 14.0)
		
    }
    func RefreshLoadingData()
    {
	RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
	print("RetrivedMobileNumber-----",RetrivedMobileNumber)
	RetrivedCustmercode = UserDefaults.standard.string(forKey: "Custmercode") ?? ""
	print("RetrivedCustmercode-----",RetrivedCustmercode)
	let parameters = ["custCode":RetrivedCustmercode as Any,
                          "empMobile":RetrivedMobileNumber as Any] as [String : Any]
		
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint3 = "/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile"
	let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint3)")!
	self.customActivityIndicatory(self.view, startAnimate: true)
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
    DispatchQueue.main.async
	{
//		self.CompanyNameLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
//		let Companynameatributes :Dictionary = [NSAttributedStringKey.font : self.CompanyNameLbl.font]
		
		self.CompanyNameLbl.font = UIFont(name: "Montserrat-Medium", size: 16.0)!
		let companynameattributes :Dictionary = [NSAttributedStringKey.font : self.CompanyNameLbl.font]
		self.CompanyNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		self.UserNameLbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
		let Usernameatributes :Dictionary = [NSAttributedStringKey.font : self.UserNameLbl.font]
		self.UserNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
//
//		self.UserNameLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
//		let Usernameatributes :Dictionary = [NSAttributedStringKey.font : self.UserNameLbl.font]
//		self.UserNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
		
	let ItemsDict = responseJSON["employeeDataDto"] as! NSDictionary
	self.RefreshemployeeNam = (ItemsDict["employeeName"] as? String)!
	self.RefreshbrName = (ItemsDict["brName"] as? String)!
	self.UserNameLbl.text = self.RefreshemployeeNam
	self.CompanyNameLbl.text = self.RefreshbrName
		}
            }    }
        task.resume()
        
    }
    
    func startLoadingSpinner(){
        activityIndicator.frame = self.view.frame
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = .clear
        activityIndicator.alpha = 0.8
        activityIndicator.color = .gray
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    @objc func stopLoadingSpinner() {
        self.activityIndicator.stopAnimating()
    }
    
	
}
