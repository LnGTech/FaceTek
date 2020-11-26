//
//  HomeDashboardVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/6/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class HomeDashboardVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var timer = Timer()
    
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var hamburgerView: UIView!
	
	@IBOutlet weak var CompanyPowerLbl: UILabel!
	@IBOutlet weak var CompanyNameLbl: UILabel!
	@IBOutlet weak var UserNameLbl: UILabel!
	@IBOutlet weak var MobilenumberLbl: UILabel!
	
	var button: HamburgerButton! = nil
	
	@IBOutlet weak var OfficeInLbl: UILabel!
	@IBOutlet weak var PendingLbl: UILabel!
	@IBOutlet weak var OfficeOutLbl: UILabel!
	@IBOutlet weak var LeaveFromLbl: UILabel!
	@IBOutlet weak var LeaveToLbl: UILabel!
	@IBOutlet weak var LeavePendingLbl: UILabel!
	@IBOutlet weak var menu: UIView!
	
	
	var customView = UIView()
	var label = UILabel()
	var CancelBtnButton = UIButton()
	var ProceedButton = UIButton()
	
	var imageview = UIImageView()
	
	var empLeaveId : Int? = 0
	
	@IBOutlet weak var ContactUsView: UIView!
	@IBOutlet weak var ContactusText: UITextView!
	@IBOutlet weak var HomeDashboatdtbl: UITableView!
    private var FrefeshAttendanceScreen = false

	var isMenuVisible:Bool!
	var IntimedateString : String = ""
	var empAttndInDateTime : String = ""
	var empAttndOutDateTime : String = ""
	var RetrivedMobileNumber : String = ""
    var RetrivedCustmercode : String = ""

	var Employeenamestr : String = ""
	var brNamestr : String = ""
    var RefreshemployeeNam : String = ""
    var RefreshbrName : String = ""
	var empIsGPSTrackEnabled = Int()


    
	var name : String = ""
	var Facename : String = ""
	
	@IBOutlet weak var ManagerView: UIView!
	
	@IBOutlet weak var LeaveApplicationPendingview: UIView!
	
	@IBOutlet weak var PendingLeavesview: UIView!
	@IBOutlet weak var Absentview: UIView!
	
	@IBOutlet weak var Leavesview: UIView!
	
	@IBOutlet weak var Latecomersview: UIView!
	
	
	@IBOutlet weak var EarlyLeaversview: UIView!
	//Manager Dashboard Label Outlets
	
	
	@IBOutlet weak var AbsentLbl: UILabel!
	
	@IBOutlet weak var Absentimg: UIImageView!
	
	@IBOutlet weak var LeavesLbl: UILabel!
	
	@IBOutlet weak var Leavesimg: UIImageView!
	
	@IBOutlet weak var LateComersLbl: UILabel!
	
	@IBOutlet weak var LateComersimg: UIImageView!
	@IBOutlet weak var EarlyLeaversLbl: UILabel!
	
	@IBOutlet weak var EarlyLeaversimg: UIImageView!
	@IBOutlet weak var LeaveApplicationPendingLbl: UILabel!
	
	@IBOutlet weak var LeavePendingimg: UIImageView!
	
	@IBOutlet weak var OfficeInBtn: UIButton!
	@IBOutlet weak var OfficeOutBtn: UIButton!
	
	@IBOutlet weak var LeaveStatusBtn: UIButton!
	
	var RetrivedcustId = Int()
	var RetrivedempId = Int()
    var empIsGPSTrackEnabledArray:NSMutableArray = NSMutableArray()
    var MainDict:NSMutableDictionary = NSMutableDictionary()

	
	    //var HomeDashboardNavigationMenuArray = ["Holiday Calender","FAQ","Contact Us"]
	var HomeDashboardNavigationMenuArray = ["Holiday Calender","Attendance History","Field Visit","My Team","Expense Claim","Leave History","FAQ","Contact Us"]
	
	var HomeDashboardGPSFalseArray = ["Holiday Calender","Attendance History","My Team","Expense Claim","Leave History","FAQ","Contact Us",""]
	
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		let statusBarColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 0.9680276113)
			statusBarView.backgroundColor = statusBarColor
		view.addSubview(statusBarView)
		
		//Tableview Empty row lines removed
		HomeDashboatdtbl.tableFooterView = UIView()

        startLoadingSpinner()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
		CompanyPowerLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)!
		let Datetxtattributes :Dictionary = [NSAttributedStringKey.font :CompanyPowerLbl.font]
		CompanyPowerLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		
        
        //Loading Mobile number and company name
        RefreshLoadingData()
        
		ContactusText.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
		let ContactusTextattributes1 :Dictionary = [NSAttributedStringKey.font : ContactusText.font]
		ContactusText.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
        ContactusText.isEditable = false
		

		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size:14)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

		
		LeaveStatusBtn.isHidden = true
		//        self.LeaveStatusBtn.setImage(UIImage(named: "cancel.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
		//
		//
		
		let defaults = UserDefaults.standard
		if let RetrivedempPresistedFaceId = defaults.string(forKey: "empPresistedFaceId") {
			print(" Retrived empPresistedFaceId----",RetrivedempPresistedFaceId)
			
			defaults.set(self.RetrivedempId, forKey: "RetrivedFaceid")
			
			
		}
		
		defaults.set(self.RetrivedempId, forKey: "RetrivedFaceid")
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
		
		//Manager view screen design
		
		self.Absentview.layer.masksToBounds = false
		self.Absentview.layer.cornerRadius = 1
		self.Absentview.layer.shadowColor = UIColor.black.cgColor
		self.Absentview.layer.shadowPath = UIBezierPath(roundedRect: self.Absentview.bounds, cornerRadius: self.Absentview.layer.cornerRadius).cgPath
		self.Absentview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
		self.Absentview.layer.shadowOpacity = 0.1
		self.Absentview.layer.shadowRadius = 1.0
		
		
		self.Leavesview.layer.masksToBounds = false
		self.Leavesview.layer.cornerRadius = 1
		self.Leavesview.layer.shadowColor = UIColor.black.cgColor
		self.Leavesview.layer.shadowPath = UIBezierPath(roundedRect: self.Leavesview.bounds, cornerRadius: self.Leavesview.layer.cornerRadius).cgPath
		self.Leavesview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
		self.Leavesview.layer.shadowOpacity = 0.1
		self.Leavesview.layer.shadowRadius = 1.0
		
		
		self.Latecomersview.layer.masksToBounds = false
		self.Latecomersview.layer.cornerRadius = 1
		self.Latecomersview.layer.shadowColor = UIColor.black.cgColor
		self.Latecomersview.layer.shadowPath = UIBezierPath(roundedRect: self.Latecomersview.bounds, cornerRadius: self.Latecomersview.layer.cornerRadius).cgPath
		self.Latecomersview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
		self.Latecomersview.layer.shadowOpacity = 0.1
		self.Latecomersview.layer.shadowRadius = 1.0
		
		
		self.EarlyLeaversview.layer.masksToBounds = false
		self.EarlyLeaversview.layer.cornerRadius = 1
		self.EarlyLeaversview.layer.shadowColor = UIColor.black.cgColor
		self.EarlyLeaversview.layer.shadowPath = UIBezierPath(roundedRect: self.EarlyLeaversview.bounds, cornerRadius: self.EarlyLeaversview.layer.cornerRadius).cgPath
		self.EarlyLeaversview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
		self.EarlyLeaversview.layer.shadowOpacity = 0.1
		self.EarlyLeaversview.layer.shadowRadius = 1.0
		
		
		self.LeaveApplicationPendingview.layer.masksToBounds = false
		self.LeaveApplicationPendingview.layer.cornerRadius = 1
		self.LeaveApplicationPendingview.layer.shadowColor = UIColor.black.cgColor
		self.LeaveApplicationPendingview.layer.shadowPath = UIBezierPath(roundedRect: self.LeaveApplicationPendingview.bounds, cornerRadius: self.LeaveApplicationPendingview.layer.cornerRadius).cgPath
		self.LeaveApplicationPendingview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
		self.LeaveApplicationPendingview.layer.shadowOpacity = 0.1
		self.LeaveApplicationPendingview.layer.shadowRadius = 1.0
		
		
		
		
		
		UserDefaults.standard.set(self.IntimedateString, forKey: "LuxandIntime") //String
		
		
		_ = customActivityIndicatory(self.view, startAnimate: false)
		
		
		LeaveApplicationPendingview.isHidden = true
		ManagerView.isHidden = true
		
		
		//let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
		
		
		
		
		
		isMenuVisible = true
		menu.isHidden = true
		//		ContactUsView.isHidden = true
		ContactusText.isHidden = true
		//
		OfficeOutLbl.layer.cornerRadius = 5
		OfficeOutLbl.layer.borderWidth = 0
		//OfficeOutLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
		
		
		
		HomeDashboatdtbl.register(UINib(nibName: "LeaveNavigationcell", bundle: nil), forCellReuseIdentifier: "LeaveNavigationcell")
		
		
		
		//        RetrivedMobileNumber = defaults.string(forKey: "Mobilenum")!
		//        print("RetrivedMobileNumber-----",RetrivedMobileNumber)
		//
		
		RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
		print("RetrivedMobileNumber-----",RetrivedMobileNumber)
        RetrivedCustmercode = UserDefaults.standard.string(forKey: "Custmercode") ?? ""
        print("RetrivedCustmercode-----",RetrivedCustmercode)
        
		ContactusText.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
		let ContactusTextattributes :Dictionary = [NSAttributedStringKey.font : ContactusText.font]
		ContactusText.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		
        
		self.MobilenumberLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
		let Mobilenumberattributes :Dictionary = [NSAttributedStringKey.font : self.MobilenumberLbl.font]
		self.MobilenumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
		MobilenumberLbl.text = RetrivedMobileNumber
		Employeenamestr = defaults.string(forKey: "employeeName") ?? ""
		
        
        
        
        
        
        
		self.button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
		self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
		self.hamburgerView.addSubview(button)
		EmployeeDashboardDetails()
		
		//image circle code
		Absentimg.layer.borderWidth = 1
		Absentimg.layer.masksToBounds = false
		Absentimg.layer.borderColor = UIColor.clear.cgColor
		Absentimg.layer.cornerRadius = Absentimg.frame.height/2
		Absentimg.clipsToBounds = true
		
		
		Absentimg.tintColor = UIColor.black
		Leavesimg.layer.borderWidth = 1
		Leavesimg.layer.masksToBounds = false
		Leavesimg.layer.borderColor = UIColor.clear.cgColor
		Leavesimg.layer.cornerRadius = Leavesimg.frame.height/2
		Leavesimg.clipsToBounds = true
		
		
		LateComersimg.layer.borderWidth = 1
		LateComersimg.layer.masksToBounds = false
		LateComersimg.layer.borderColor = UIColor.clear.cgColor
		LateComersimg.layer.cornerRadius = LateComersimg.frame.height/2
		LateComersimg.clipsToBounds = true
		
		EarlyLeaversimg.layer.borderWidth = 1
		EarlyLeaversimg.layer.masksToBounds = false
		EarlyLeaversimg.layer.borderColor = UIColor.clear.cgColor
		EarlyLeaversimg.layer.cornerRadius = EarlyLeaversimg.frame.height/2
		EarlyLeaversimg.clipsToBounds = true
		
		
		LeavePendingimg.layer.borderWidth = 1
		LeavePendingimg.layer.masksToBounds = false
		LeavePendingimg.layer.borderColor = UIColor.clear.cgColor
		LeavePendingimg.layer.cornerRadius = LeavePendingimg.frame.height/2
		LeavePendingimg.clipsToBounds = true
		
		
		
		
		//Manager view Absent , Leaves , Latecomers and EarlyLeavers
		
		let Absentviewtap = UITapGestureRecognizer(target: self, action: #selector(self.AbsenttouchTapped(_:)))
		self.Absentview.addGestureRecognizer(Absentviewtap)
		
		
		let Leavesviewtap = UITapGestureRecognizer(target: self, action: #selector(self.LeavestouchTapped(_:)))
		self.Leavesview.addGestureRecognizer(Leavesviewtap)
		
		
		
		
		let LatecomersviewTap = UITapGestureRecognizer(target: self, action: #selector(self.LatecomersTapped(_:)))
		self.Latecomersview.addGestureRecognizer(LatecomersviewTap)
		
		
		let EarlyLeaversviewTap = UITapGestureRecognizer(target: self, action: #selector(self.EarlyLeaversTapped(_:)))
		self.EarlyLeaversview.addGestureRecognizer(EarlyLeaversviewTap)
		
		
		let PendingLeavesTap = UITapGestureRecognizer(target: self, action: #selector(self.PendingLeavesTap(_:)))
		self.PendingLeavesview.addGestureRecognizer(PendingLeavesTap)
		
		
		
		
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint2 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint2)")!
		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
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
					{
						
						var MainDict:NSMutableDictionary = NSMutableDictionary()
						self.empIsGPSTrackEnabled = (responseJSON["empIsGPSTrackEnabled"] as? Int)!
						print("empIsGPSTrackEnabled-------",self.empIsGPSTrackEnabled)
						MainDict.setObject(self.empIsGPSTrackEnabled, forKey: "empIsGPSTrackEnabled" as NSCopying)
						self.empIsGPSTrackEnabledArray.add(self.MainDict)
						self.HomeDashboatdtbl.reloadData()

						
				}
				
			}

			
			
		}
		task.resume()
		
		// Do any additional setup after loading the view.
	}
	
	
	@objc func AbsenttouchTapped(_ sender: UITapGestureRecognizer) {
		print("Absent view is calling.......")
		
		
		//    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		//    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
		//
		
		let AbsentVC = storyboard?.instantiateViewController(withIdentifier: "AbsentVC") as! AbsentVC
		
		
		//    //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
		//
		//    var Managerstr = ""
		//
		//ManagerVC.Managerstr = "Absent Details"
		//
		
		
		self.present(AbsentVC, animated:true, completion:nil)
		
	}
	
	
	@objc func LeavestouchTapped(_ sender: UITapGestureRecognizer) {
		print("Absent view is calling.......")
		
		
		
		//    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		//    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
		//
		
		let ManagerLeavesVC = storyboard?.instantiateViewController(withIdentifier: "ManagerLeavesVC") as! ManagerLeavesVC
		//
		//
		//           //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
		//
		//           var Managerstr = ""
		//
		//       ManagerVC.Managerstr = "Leave Details"
		//
		
		
		self.present(ManagerLeavesVC, animated:true, completion:nil)
		
	}
	
	
	@objc func LatecomersTapped(_ sender: UITapGestureRecognizer) {
		print("Absent view is calling.......")
		
		
		
		//    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		//    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
		//
		
		let LatecomersVC = storyboard?.instantiateViewController(withIdentifier: "LatecomersVC") as! LatecomersVC
		
		
		//self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
		
		//           var Managerstr = ""
		//
		//       ManagerVC.Managerstr = "Late comers"
		//
		
		
		self.present(LatecomersVC, animated:true, completion:nil)
		
	}
	
	
	
	@objc func EarlyLeaversTapped(_ sender: UITapGestureRecognizer) {
		print("Absent view is calling.......")
		
		
		
		//    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
		//    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
		//
		
		let EarlyLeaversVC = storyboard?.instantiateViewController(withIdentifier: "EarlyLeaversVC") as! EarlyLeaversVC
		
		
		//self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
		
		//         var Managerstr = ""
		//
		//     ManagerVC.Managerstr = "Early Leavers"
		//
		
		
		self.present(EarlyLeaversVC, animated:true, completion:nil)
		
	}
	
	
	
	@objc func PendingLeavesTap(_ sender: UITapGestureRecognizer) {
		print("Absent view is calling.......")
		
		
		
		let PendingLeavesVC = storyboard?.instantiateViewController(withIdentifier: "PendingLeavesVC") as! PendingLeavesVC
		
		self.present(PendingLeavesVC, animated:true, completion:nil)
		
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
	
	
	func EmployeeDashboardDetails()
	{
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		
		
		
		
		//http://122.166.152.106:8080/serenityuat/inmatesignup/validateMobileNo
		
		customActivityIndicatory(self.view, startAnimate: true)
		
		
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
				print("Employee ---- Json Response",responseJSON)
				
				//var empIsSupervisor_Manager: Bool?
				let empIsSupervisor_Manager = responseJSON["empIsSupervisor_Manager"] as? Int
				print("empIsSupervisor_Manager ------------", empIsSupervisor_Manager as Any)
				
				
				
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
				
				//Employee Upcoming Leaves and Office In ,Office Out
				let empLeaveData = responseJSON["empLeaveData"] as? [String:Any]
				let statusDic = empLeaveData?["status"] as? [String:Any]
				let empcode = statusDic?["code"] as? NSInteger
				let empSummary = responseJSON["empSummary"] as? [String:Any]
				let empSummarystatusDic = empSummary?["status"] as? [String:Any]
				let empSummarycode = empSummarystatusDic?["code"] as? NSInteger
				
				DispatchQueue.main.async {
					
					//Manager screen calling code
					//------******---------------------********--------//
					if (empIsSupervisor_Manager == 1)
					{
						
						self.ManagerView.isHidden = false
						
						self.LeaveApplicationPendingview.isHidden = false
						print("Manager screen----")
						
						
						if (empSummarycode == 200)
						{
							
							let empsummaryDetailsDic = empSummary?["summaryDetails"] as? [String:Any]
							let absent = empsummaryDetailsDic?["absent"] as? NSInteger
							self.AbsentLbl.text = absent?.description
							
							let totalAppLeave = empsummaryDetailsDic?["totalAppLeave"] as? NSInteger
							self.LeavesLbl.text = totalAppLeave?.description
							
							let totalLateComers = empsummaryDetailsDic?["totalLateComers"] as? NSInteger
							self.LateComersLbl.text = totalLateComers?.description
							
							let totalEarlyLeavers = empsummaryDetailsDic?["totalEarlyLeavers"] as? NSInteger
							self.EarlyLeaversLbl.text = totalEarlyLeavers?.description
							
							let totalPendingLeave = empsummaryDetailsDic?["totalPendingLeave"] as? NSInteger
							self.LeaveApplicationPendingLbl.text = totalPendingLeave?.description
						}
					}
					
					if(empcode == 200)
					{
						let Empdata = empLeaveData?["data"] as? [String:Any]
						self.empLeaveId = Empdata?["empLeaveId"] as? Int
						
						var empLeaveFrom = Empdata?["empLeaveFrom"] as? String
						var empLeaveTo = Empdata?["empLeaveTo"] as? String
						var empLeaveStatus = Empdata?["empLeaveStatus"] as? String
						self.LeaveFromLbl.text = empLeaveFrom
						self.LeaveToLbl.text = empLeaveTo
						var LeaveApproved = "App"
						var LeaveRejected = "Rej"
						
						if (empLeaveStatus == "")
						{
							self.LeaveStatusBtn.isHidden = false
							self.LeaveStatusBtn.setImage(UIImage(named: "cancel.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
							self.LeavePendingLbl.layer.cornerRadius = 2
							self.LeavePendingLbl.layer.borderWidth = 1
							self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
							self.LeavePendingLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
							self.LeavePendingLbl.text = "Pending"
						} else if (LeaveApproved == empLeaveStatus) {
							self.LeavePendingLbl.layer.cornerRadius = 2
							self.LeavePendingLbl.layer.borderWidth = 1
							self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 0.1368455306, green: 0.5300007931, blue: 0.2386429882, alpha: 1)
							self.LeavePendingLbl.textColor = #colorLiteral(red: 0.1368455306, green: 0.5300007931, blue: 0.2386429882, alpha: 1)
							self.LeavePendingLbl.text = "Approved"
							self.LeaveStatusBtn.isHidden = true
						} else if (LeaveRejected == empLeaveStatus)
						{
							self.LeaveStatusBtn.isHidden = true
							self.LeavePendingLbl.layer.cornerRadius = 2
							self.LeavePendingLbl.layer.borderWidth = 1
							self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
							self.LeavePendingLbl.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
							self.LeavePendingLbl.text = "Rejected"
						}
						
						self.LeaveStatusBtn.addTarget(self, action: #selector(self.CancelLeave(_:)), for: .touchUpInside)
					}
					
					var empAttndDate = ItemsDict?["empAttndDate"] as? String
					self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
					self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
					if (self.empAttndInDateTime == "NA") {
						self.OfficeInLbl.text = self.empAttndInDateTime
						self.OfficeInLbl.layer.cornerRadius = 5
						self.OfficeInLbl.layer.borderWidth = 0
						//self.OfficeInLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						self.OfficeInLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						self.OfficeInLbl.text = "Pending"
						self.OfficeInBtn.setImage(UIImage(named: "pending.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
					} else {
						//InTime Code
						if self.empAttndInDateTime.count > 0 {
							let dateFormatter = DateFormatter()
							let tempLocale = dateFormatter.locale // save locale temporarily
							dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
							dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
							let Intimedate = dateFormatter.date(from: self.empAttndInDateTime)
							dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format
							dateFormatter.locale = tempLocale // reset the locale
							let IntimedateString = dateFormatter.string(from: Intimedate!)
							self.OfficeInLbl.text = IntimedateString
							self.OfficeInLbl.layer.cornerRadius = 5
							self.OfficeInLbl.layer.borderWidth = 2
							self.OfficeInLbl.layer.borderColor = UIColor.clear.cgColor
							self.OfficeInLbl.textColor = UIColor.darkGray
							self.OfficeInBtn.setImage(UIImage(named: "pass.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
						}
					}
					
					if (self.empAttndOutDateTime == "NA") {
						self.OfficeOutLbl.text = self.empAttndOutDateTime
						self.OfficeOutLbl.layer.cornerRadius = 5
						self.OfficeOutLbl.layer.borderWidth = 0
						//self.OfficeOutLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						self.OfficeOutLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						self.OfficeOutLbl.text = "Pending"
						self.OfficeOutBtn.setImage(UIImage(named: "pending.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
					} else {
						//Outtime Conversion Code
						if self.empAttndOutDateTime.count > 0 {
							let OuttimedateFormatter = DateFormatter()
							let tempLocale = OuttimedateFormatter.locale // save locale temporarily
							OuttimedateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
							OuttimedateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
							let Outtimedate = OuttimedateFormatter.date(from: self.empAttndOutDateTime)
							OuttimedateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format
							OuttimedateFormatter.locale = tempLocale // reset the locale
							let OuttimedateString = OuttimedateFormatter.string(from: Outtimedate!)
							self.OfficeOutLbl.text = OuttimedateString
							self.OfficeOutLbl.layer.cornerRadius = 5
							self.OfficeOutLbl.layer.borderWidth = 0
							self.OfficeOutLbl.layer.borderColor = UIColor.clear.cgColor
							self.OfficeOutLbl.textColor = UIColor.darkGray
							self.OfficeOutBtn.setImage(UIImage(named: "pass.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
						}
					}
					_ = self.customActivityIndicatory(self.view, startAnimate: false)
				}
			}
		}
		task.resume()
	}
	
	@objc func CancelLeave(_ sender:UIButton!)
	{
		self.customView.frame = CGRect.init(x: 0, y: 0, width: 350, height: 350)
		//self.customView.backgroundColor = UIColor.white     //give color to the view
		
		self.customView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)
		
		
		
		self.customView.center = self.view.center
		self.view.addSubview(self.customView)
		
		
		
		label = UILabel(frame: CGRect(x: 50, y: 50, width: 350, height: 21))
		//label.center = CGPoint(x: 160, y: 285)
		//label.textAlignment = .center
		label.text = "Do you want to cancel your leave?"
		
		label.textColor = UIColor.white
		label.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
		self.customView.addSubview(label)
		
		
		
		//var imageView : UIImageView
		imageview  = UIImageView(frame:CGRect(x: 150, y: 90, width: 60, height: 60));
		imageview.image = UIImage(named:"selectmode.png")
		self.customView.addSubview(imageview)
		
		
		
		ProceedButton = UIButton(type: .system)
		
		// Position Button
		ProceedButton.frame = CGRect(x: 37.5, y: 170, width: 275, height: 55)
		// Set text on button
		ProceedButton.setTitle("PROCEED", for: .normal)
		//myButton.setTitle("Pressed + Hold", for: .highlighted)
		
		ProceedButton.backgroundColor = UIColor.clear
		
		
		ProceedButton.layer.borderWidth = 1
		
		
		ProceedButton.layer.borderColor = UIColor.white.cgColor
		
		ProceedButton.setTitleColor(UIColor.white, for: .normal)
		
		// Set button action
		ProceedButton.addTarget(self, action: #selector(self.LeaveProceedBtn(_:)), for: .touchUpInside)
		
		self.customView.addSubview(ProceedButton)
		
		
		
		CancelBtnButton = UIButton(type: .system)
		
		// Position Button
		CancelBtnButton.frame = CGRect(x: 37.5, y: 240, width: 275, height: 55)
		// Set text on button
		CancelBtnButton.setTitle("CANCEL", for: .normal)
		//myButton.setTitle("Pressed + Hold", for: .highlighted)
		
		CancelBtnButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
		
		CancelBtnButton.setTitleColor(UIColor.white, for: .normal)
		
		// Set button action
		CancelBtnButton.addTarget(self, action: #selector(self.CancelLeaveBtn(_:)), for: .touchUpInside)
		
		
		customView.isHidden = false
		imageview.isHidden = false
		ProceedButton.isHidden = false
		CancelBtnButton.isHidden = false
		
		label.isHidden = false
		
		
		self.customView.addSubview(CancelBtnButton)
	}
	
	@objc func LeaveProceedBtn(_ sender:UIButton!)
	{
		let parameters = ["custId": RetrivedcustId as Any,"empLeaveId": empLeaveId as Any] as [String : Any]
		
		
		//    var RetrivedcustId : Int = 0r
		//
		//
		//
		//    let parameters = ["custId": RetrivedcustId] as [String : Any]
		//
		
		//create the url with URL
		//let url = URL(string: "https://www.webliststore.biz/app_api/api/authenticate_user")! //change the url
		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8081/attnd-api-gateway-service/api/customer/employee/setup/updateEmpAppStatus ")!
		
		
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint1 = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/cancel"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint1)")!
		
		
		
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
				print("Json Response",responseJSON)
				
				
				
				DispatchQueue.main.async {
					
					let code = responseJSON["code"] as? NSInteger
					print("face code-----",code as Any)
					
					
					
					if(code == 200)
					{
						
						var message = (responseJSON["message"] as? String)!
						let alert = UIAlertController(title: "Succesful", message: "Leave Cancelled successfully!", preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
							let UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "UITabBarController")
							
							self.present(UITabBarController, animated:true, completion:nil)
						}))
						self.present(alert, animated: true)
					}
				}
			}
		}
		task.resume()
	}
	
	@objc func CancelLeaveBtn(_ sender:UIButton!)
	{
		customView.isHidden = true
		imageview.isHidden = true
		ProceedButton.isHidden = true
		CancelBtnButton.isHidden = true
		label.isHidden = true
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if section == 0
        {
            return HomeDashboardNavigationMenuArray.count
        }
        else  {
            return HomeDashboardGPSFalseArray.count
        }
		
//		var count:Int?
//
//		if tableView == self.HomeDashboatdtbl {
//			count = HomeDashboardNavigationMenuArray.count
//		}
////		else
////		{
////			count =  HomeDashboardGPSFalseArray.count
////			}
//		return count!
		
	}
	
	// create a cell for each table view row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cellToReturn = UITableViewCell() // Dummy value


		if (empIsGPSTrackEnabled == 1)
		{
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			cell.accessoryType = .disclosureIndicator
			// set the text from the data model
			
			
			cell.LeaveNavigationLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
			let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
			cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
			cell.LeaveNavigationLbl?.text = self.HomeDashboardNavigationMenuArray[indexPath.row]
			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
		}
		else
		{
		let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
		cell.accessoryType = .disclosureIndicator
		cell.LeaveNavigationLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
		let PendingLeavesrejectattributes :Dictionary = [NSAttributedStringKey.font : cell.LeaveNavigationLbl.font]
		cell.LeaveNavigationLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
		cell.LeaveNavigationLbl?.text = self.HomeDashboardGPSFalseArray[indexPath.row]
			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
			
			

		}
		
		return cellToReturn
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		
		if (empIsGPSTrackEnabled == 1)
		{
		if indexPath.row == 0 {
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

			let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
			self.present(CalendarVC, animated:true, completion:nil)


			//
			//            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
			//            let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
			//            self.navigationController?.pushViewController(CalendarVC, animated:false)
			//



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
		else if indexPath.item == 7 {

			if ContactusText.isHidden {
				//ContactUsView.isHidden = false
				ContactusText.isHidden = false
			} else {
				//ContactUsView.isHidden = true
				ContactusText.isHidden = true
			}



		}
		}
		else
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
			else if indexPath.item == 6 {

				if ContactusText.isHidden {
					//ContactUsView.isHidden = false
					ContactusText.isHidden = false
				} else {
					//ContactUsView.isHidden = true
					ContactusText.isHidden = true
				}



			}
			
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 34
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
		// viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
		
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
	
	
    
    func RefreshLoadingData()
    {
        
        RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
        print("RetrivedMobileNumber-----",RetrivedMobileNumber)
        RetrivedCustmercode = UserDefaults.standard.string(forKey: "Custmercode") ?? ""
        print("RetrivedCustmercode-----",RetrivedCustmercode)
        
        
        let parameters = ["custCode":RetrivedCustmercode as Any,
                          "empMobile":RetrivedMobileNumber as Any] as [String : Any]
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint2 = "/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint2)")!
		
        
        self.customActivityIndicatory(self.view, startAnimate: true)
        
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Refresh Json Response",responseJSON)
                
                DispatchQueue.main.async
                    {
                        let ItemsDict = responseJSON["employeeDataDto"] as! NSDictionary
                        self.RefreshemployeeNam = (ItemsDict["employeeName"] as? String)!
                        print("Refresh employeeName",self.RefreshemployeeNam)
                        
                        self.RefreshbrName = (ItemsDict["brName"] as? String)!
                        print("Refresh brName",self.RefreshbrName)
                        self.UserNameLbl.text = self.RefreshemployeeNam
                        
                        print("brNamestr-----",self.brNamestr)
                        self.CompanyNameLbl.text = self.RefreshbrName
						
						self.CompanyNameLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
						let Companynameatributes :Dictionary = [NSAttributedStringKey.font : self.CompanyNameLbl.font]
						self.CompanyNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
						
						self.UserNameLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
						let Usernameatributes :Dictionary = [NSAttributedStringKey.font : self.UserNameLbl.font]
						self.UserNameLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
						
                }
            }    }
        task.resume()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        if FrefeshAttendanceScreen {
            startLoadingSpinner()
                   timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
            return
        }
        FrefeshAttendanceScreen = true

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
