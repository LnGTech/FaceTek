//
//  AttendanceVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/6/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

class AttendanceVC: UIappViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
	var timer = Timer()
	
	var MainDict:NSMutableDictionary = NSMutableDictionary()
	
	var locationManager = CLLocationManager()
	var LattitudestrData = String()
	var LongitudestrData = String()
	var empAttendanceInLatLongstr = String()
	var address: String = ""
	var RetrivedcustId = Int()
	var RetrivedempId = Int()
	var ConvertShiftstartTime = Int()
	var ConvertshiftEndTime = Int()
	var ConvertoutPermissibleTime = Int()
	var empAttndInDateTime : String = ""
	var empAttndOutDateTime : String = ""
	var currentDatestr : String = ""
	var RetrivedMobileNumber : String = ""
	var RetrivedCustmercode : String = ""
	var RefreshemployeeNam : String = ""
	var RefreshbrName : String = ""
	private var FrefeshAttendanceScreen = false
	
	var Employeenamestr : String = ""
	var brNamestr : String = ""
	var Facename : String = ""
	var VisitTextField = UITextField()
	var customView = UIView()
	var customSubView = UIView()
	@IBOutlet weak var hamburgerView: UIView!
	@IBOutlet weak var EmergencyTimeoutview: UIView!
	@IBOutlet weak var Attentionview: UIView!
	@IBOutlet weak var Permitedview: UIView!
	@IBOutlet weak var Emergencybuttonview: UIView!
	
	var CancelBtnButton = UIButton()
	var submitButton = UIButton()
	var DrpdownBtn = UIButton()
	
	@IBOutlet weak var EmergencyoutBtn: UIButton!
	var label = UILabel()
	
	//label.ishidden = true
	
	@IBOutlet weak var OutPermissionLbl: UILabel!
	
	var persistedFaceId = String()
	//       var RetrivedcustId = Int()
	//       var RetrivedempId = Int()
	//
	//var IntimedateString = String.self
	
	var shiftStartTime = String()
	var shiftEndTime = String()
	var outPermissibleTime = String()
	@IBOutlet weak var CompanyNameLbl: UILabel!
	@IBOutlet weak var UserNameLbl: UILabel!
	@IBOutlet weak var MobilenumberLbl: UILabel!
	@IBOutlet weak var menu: UIView!
	@IBOutlet weak var ContactUsView: UIView!
	
	@IBOutlet weak var ContactTextView: UITextView!
	var isMenuVisible:Bool!
	@IBOutlet weak var AttendanceNavigationtbl: UITableView!
	 //var AttendanceNavigationMenuArray = ["Holiday Calender","FAQ","Contact Us"]
	
	var AttendanceNavigationMenuArray = ["Holiday Calender","Attendance History","Field Visit","My Team","Expense Claim","Leave History","FAQ","Contact Us"]
	
	var MovementoutDrpTbl: UITableView  =   UITableView()
	//var MovementOutDrpArray: [String] = ["One", "Two", "Three"]
	
	var MovementOutDrpArray:NSMutableArray = NSMutableArray()
	var button: HamburgerButton! = nil
	let reuseIdentifier = "AttendanceDashboardCell" // also
	var DashboardArray = ["Office IN","Office OUT","Movement IN","Movement OUT"]
	
	var DashboardIconImgs: [UIImage] = [UIImage(named: "office_in.png")!,UIImage(named: "office_out.png")!,UIImage(named: "track_movement.png")!,UIImage(named: "track_movement.png")!]
	
	//     var DashboardIconImgs: [UIImage] = [UIImage(named: "office_in.png")!,UIImage(named: "office_out.png")!,UIImage(named: "qrcode.png")!,UIImage(named: "qrcode.png")!,UIImage(named: "office_in.png")!,UIImage(named: "office_out.png")!]
	//
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		startLoadingSpinner()
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopLoadingSpinner), userInfo: nil, repeats: false)
		
		RefreshLoadingData()
		
		ContactTextView.isEditable = false
		customActivityIndicatory(self.view, startAnimate: false)
		EmergencyTimeoutview.isHidden = true
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
		
		MovementoutDrpTbl.isHidden = true
		//ContactUsView.isHidden = true
		ContactTextView.isHidden = true
		isMenuVisible = true
		menu.isHidden = true
		AttendanceNavigationtbl.register(UINib(nibName: "LeaveNavigationcell", bundle: nil), forCellReuseIdentifier: "LeaveNavigationcell")
		//programatical Tableview code
		
		let screenSize: CGRect = UIScreen.main.bounds
		let screenWidth = screenSize.width
		let screenHeight = screenSize.height
		MovementoutDrpTbl.frame = CGRect(x: 30, y: 20, width: 300, height: 150);
		MovementoutDrpTbl.dataSource = self
		MovementoutDrpTbl.delegate = self
		MovementoutDrpTbl.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
		self.customView.addSubview(MovementoutDrpTbl)
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
		RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
		print("RetrivedMobileNumber-----",RetrivedMobileNumber)
		
		//        RetrivedMobileNumber = defaults.string(forKey: "Mobilenum")!
		//        print("RetrivedMobileNumber-----",RetrivedMobileNumber)
		MobilenumberLbl.text = RetrivedMobileNumber
		//Employeenamestr = defaults.string(forKey: "employeeName") ?? ""
		//		UserNameLbl.text = Employeenamestr
		//		brNamestr = defaults.string(forKey: "brName") ?? ""
		//		print("brNamestr-----",brNamestr)
		//		CompanyNameLbl.text = brNamestr
		self.button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
		self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
		
		self.hamburgerView.addSubview(button)
		
		
		
		
		//Latlong method
		locationManager.requestWhenInUseAuthorization()
		var currentLoc: CLLocation!
		if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
			CLLocationManager.authorizationStatus() == .authorizedAlways) {
			currentLoc = locationManager.location
			LattitudestrData = String(currentLoc.coordinate.latitude)
			print("curent Latitude string value",LattitudestrData)
			LongitudestrData = String(currentLoc.coordinate.longitude)
			print("curent longitude string value",LongitudestrData)
			//empAttendanceInLatLongstr = "\(LattitudestrData) \(LongitudestrData)"
			empAttendanceInLatLongstr = LattitudestrData + ", " + LongitudestrData
			
		}
		
		getAddress { (address) in
			print(" Attendance Location------",address)
		}
		
		
		
		
		
		
		//----------------------------
		BeconeMethodaAPI()
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		//let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		
		
		let urlstring = "\(StartPoint)\(Endpoint1)"
		print("First",urlstring)
		let url = NSURL(string: urlstring)
		
		let URL:NSURL = NSURL(string: urlstring)!
		//let request: NSURLRequest = NSURLRequest(url: URL as URL)
		var request = URLRequest(url: URL as URL)
		request.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				return
			}
			if error != nil {
				//error
			} else {
				do {
					//let data = json.data(using: .utf8)!
					let jsonDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
					print("Json Data -----------",jsonDict)
					DispatchQueue.main.async {
						self.currentDatestr = (jsonDict["currentDate"] as? String)!
						//
					}
					
				}
			}
		}
		task.resume()
		
		
		
	}
	
	//Beconlist
	
	
	
	
	
	
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
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.DashboardArray.count
		
	}
	
	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		customActivityIndicatory(self.view, startAnimate: true)
		
		// get a reference to our storyboard cell
		let AttendanceDashboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AttendanceDashboardCell
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		AttendanceDashboardCell.AttendanceDashboardLbl.text = self.DashboardArray[indexPath.item]
		let image = DashboardIconImgs[indexPath.row]
		AttendanceDashboardCell.Attendanceimage.image = image
		//AttendanceDashboardCell.layer.borderWidth = 1.0
		//AttendanceDashboardCell.layer.borderColor = UIColor.blue.cgColor
		customActivityIndicatory(self.view, startAnimate: false)
		return AttendanceDashboardCell
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
		if indexPath.item == 0 {
			BeaconListAttendance_IN()
		}
		else if indexPath.item == 1 {
			BeaconListAttendance_OUT()
		}
		else if indexPath.item == 2{
			//MovementIn()
			MovementInUpdate()
		}
		else if indexPath.item == 3{
			MovementOUT_Update()		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let noOfCellsInRow = 2
		
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
		return CGSize(width: size, height: 110)
	}
	
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		var count:Int?
		if tableView == self.AttendanceNavigationtbl {
			count = AttendanceNavigationMenuArray.count
		}
		else
		{
			count = MovementOutDrpArray.count
		}
		return count!
		
	}
	
	// create a cell for each table view row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cellToReturn = UITableViewCell() // Dummy value
		
		if tableView == AttendanceNavigationtbl
		{
			
			// create a new cell if needed or reuse an old one
			let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
			cell.accessoryType = .disclosureIndicator
			// set the text from the data model
			cell.LeaveNavigationLbl?.text = self.AttendanceNavigationMenuArray[indexPath.row]
			customActivityIndicatory(self.view, startAnimate: false)
			cellToReturn = cell
			
		}
			
		else if tableView == MovementoutDrpTbl
		{
			let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
			
			var responseDict = self.MovementOutDrpArray[indexPath.row] as! NSMutableDictionary
			var maindata = MovementOutDrpArray[indexPath.row]
			print("Retrived data",responseDict)
			self.MovementOutDrpArray.add(MainDict)
			print("VisitList Type Array",MovementOutDrpArray)
			var VisitPlaceListstr : String?
			VisitPlaceListstr = responseDict["empPlaceOfVisit"] as? String
			print("VisitPlaceListstr",VisitPlaceListstr)
			cell.textLabel?.text = VisitPlaceListstr
			cellToReturn = cell
			
		}
		
		return cellToReturn
		
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
		
	{
		if tableView == AttendanceNavigationtbl
		{
			if indexPath.row == 0 {
				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
				self.present(CalendarVC, animated:true, completion:nil)
				
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
			
			else if indexPath.item == 6 {
				let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
				let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
				self.present(FaqVC, animated:true, completion:nil)
				
			}
			else if indexPath.item == 7 {
				
				if ContactTextView.isHidden {
					ContactTextView.isHidden = false
				} else {
					ContactTextView.isHidden = true
				}
			}
		}
		else
		{
			print("calling movement table")
			let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
			var responseDict = self.MovementOutDrpArray[indexPath.row] as! NSMutableDictionary
			var maindata = MovementOutDrpArray[indexPath.row]
			print("Retrived data",responseDict)
			self.MovementOutDrpArray.add(MainDict)
			print("VisitList Type Array",MovementOutDrpArray)
			
			var VisitPlaceListstr : String?
			VisitPlaceListstr = responseDict["empPlaceOfVisit"] as? String
			print("VisitPlaceListstr",VisitPlaceListstr)
			cell.textLabel!.text = VisitPlaceListstr
			VisitTextField.text = VisitPlaceListstr
			MovementoutDrpTbl.isHidden = true
			customSubView.isHidden = false
			DrpdownBtn.isHidden = false
			VisitTextField.isHidden = false
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	func BeconeMethodaAPI()
	{
		
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint2 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint2)")!
		
		
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
				print("Employee ---- Json Response",responseJSON)
				var empIsSupervisor_Manager: Bool?
				empIsSupervisor_Manager = (responseJSON["empIsSupervisor_Manager"] as? Bool)!
				print("empIsSupervisor_Manager ------------",empIsSupervisor_Manager as Any)
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
				
				//Employee Upcoming Leaves and Office In ,Office Out
				var empBeaconsDic = responseJSON["empBeacons"]! as! NSDictionary
				print("empBeaconsDic------",empBeaconsDic)
				var isempBeacons: Bool?
				let statusDic = empBeaconsDic["status"]! as! NSDictionary
				print("status------",statusDic)
				let empBeacons = statusDic["code"] as? NSInteger
				print("empBeacons-----",empBeacons as Any)
				//Checking Becone
				
				//Employee Shift details
				
				var empShiftDetailsDic = responseJSON["empShiftDetails"]! as! NSDictionary
				print("empShiftDetailsDic------",empShiftDetailsDic)
				DispatchQueue.main.async {
					var empShiftDetailsDic = responseJSON["empShiftDetails"]! as! NSDictionary
					print("empShiftDetailsDic------",empShiftDetailsDic)
					
					let detailsDtoDic = empShiftDetailsDic["detailsDto"]! as! NSDictionary
					let shiftType = detailsDtoDic["shiftType"] as? NSString
					print("shiftType----",shiftType as Any)
					
					if (shiftType == shiftType)
					{
						self.shiftStartTime = detailsDtoDic["shiftStartTime"] as? NSString as! String
						print("shiftStartTime----",self.shiftStartTime as Any)
						self.ConvertShiftstartTime = (self.shiftStartTime as NSString).integerValue
						
						self.shiftEndTime = detailsDtoDic["shiftEndTime"] as? NSString as! String
						print("shiftEndTime----",self.shiftEndTime as Any)
						let dateFormatter = DateFormatter()
						dateFormatter.dateFormat = "h:mm a"
						let date = dateFormatter.date(from: self.shiftEndTime)
						dateFormatter.dateFormat = "HH:mm"
						let date24 = dateFormatter.string(from: date!)
						self.ConvertshiftEndTime = (date24 as NSString).integerValue
						print("ConvertshiftEndTime-----",self.ConvertshiftEndTime)
						self.outPermissibleTime = detailsDtoDic["outPermissibleTime"] as? NSString as! String
						print("outPermissibleTime----",self.outPermissibleTime as Any)
						self.ConvertoutPermissibleTime = (self.outPermissibleTime as NSString).integerValue
						
						print("ConvertoutPermissibleTime-----",self.ConvertoutPermissibleTime)
						
					}
					else
					{
						print("shifttype2 details")
						
					}
					
				}
			}
			
		}
		task.resume()
		
	}
	
	
	//Beaconlist
	func BeaconListAttendance_IN()
	{
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("Beacon list RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("Beacon list RetrivedempId----",RetrivedempId)
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
						
						let statusDic = responseJSON["status"]! as! NSDictionary
						print("Beacon status------",statusDic)
						let code = (statusDic["code"] as? NSInteger)!
						print("Beacon status------",code)
						self.AttendanceIntime()
						
						let defaults = UserDefaults.standard
						UserDefaults.standard.set("GeneralMode", forKey: "Mode")
						
						
						if(code == 200)
							
						{
							let ssid = self.fetchSSIDInfo()
							print("SSID----: \(ssid)")
							let ItemsDict = responseJSON["empBeacons"] as! NSDictionary
							print("empBeacons...",ItemsDict)
							
							if let absentEmpShiftDetails = ItemsDict["beaconMapDtolist"] as? NSNull {
								
								print("null values printed.....")
								
								self.AttendanceIntime()
								
								
							}
							else
							{
								
								print("Normal values...")
								let beaconMapDtolistArray = ItemsDict["beaconMapDtolist"] as! NSArray
								print("beaconMapDtolist---",beaconMapDtolistArray)
								for beaconMapDtolistDic in beaconMapDtolistArray as! [[String:Any]]
								{
									var MainDict:NSMutableDictionary = NSMutableDictionary()
									var beaconCode = ""
									beaconCode = (beaconMapDtolistDic["beaconCode"] as? String)!
									print(" beaconCode--",beaconCode)
									if (beaconCode == ssid)
									{
										self.AttendanceIntime()
										
									}
									else
									{
										
										let alert = UIAlertController(title: "Alert", message: "You seems to be Out of Office range", preferredStyle: UIAlertControllerStyle.alert)
										alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
										self.present(alert, animated: true, completion: nil)
									}
								}
								
							}
						}
				}
				
			}
			
			
		}
		task.resume()
	}
	
	
	
	//Beaconlist AttendanceOUT
	
	func BeaconListAttendance_OUT()
	{
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("Beacon list RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("Beacon list RetrivedempId----",RetrivedempId)
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint3 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint3)")!
		
		
		
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
						
						let statusDic = responseJSON["status"]! as! NSDictionary
						print("Beacon status------",statusDic)
						let code = (statusDic["code"] as? NSInteger)!
						print("Beacon status------",code)
						
						
						self.AttendanceOutime()
						let defaults = UserDefaults.standard
						//UserDefaults.standard.set("GeneralMode", forKey: "Mode")
						
						
						
						if(code == 200)
							
						{
							
							let ssid = self.fetchSSIDInfo()
							print("SSID----: \(ssid)")
							let ItemsDict = responseJSON["empBeacons"] as! NSDictionary
							print("empBeacons...",ItemsDict)
							
							if let absentEmpShiftDetails = ItemsDict["beaconMapDtolist"] as? NSNull {
								
								print("null values printed.....")
								
								self.AttendanceOutime()
								
								
							}
							else
							{
								
								print("Normal values...")
								let beaconMapDtolistArray = ItemsDict["beaconMapDtolist"] as! NSArray
								print("beaconMapDtolist---",beaconMapDtolistArray)
								for beaconMapDtolistDic in beaconMapDtolistArray as! [[String:Any]]
								{
									var MainDict:NSMutableDictionary = NSMutableDictionary()
									var beaconCode = ""
									beaconCode = (beaconMapDtolistDic["beaconCode"] as? String)!
									print(" beaconCode--",beaconCode)
									if (beaconCode == ssid)
									{
										self.AttendanceOutime()
										UserDefaults.standard.set("BeaconeMode", forKey: "Mode")
										
										
									}
									else
									{
										
										let alert = UIAlertController(title: "Alert", message: "You seems to be Out of Office range", preferredStyle: UIAlertControllerStyle.alert)
										alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
										self.present(alert, animated: true, completion: nil)
									}
								}
								
							}
						}
				}
				
			}
			
			
		}
		task.resume()
	}
	
	func fetchSSIDInfo() -> String? {
		var ssid: String?
		if let interfaces = CNCopySupportedInterfaces() as NSArray? {
			for interface in interfaces {
				if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
					ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
					break
				}
			}
		}
		return ssid
	}
	
	
	
	
	
	func AttendanceIntime() {
		let isInternet: Bool = true
		if(isInternet == true) {
			
			BeconeMethodaAPI()
			EmployeeSignInChecking()
		}
		else
		{
					DispatchQueue.main.async {
						print("Office IN Internet Unavailable")
						
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let OfficeInVC = storyBoard.instantiateViewController(withIdentifier: "OfficeInVC") as! OfficeInVC
			self.present(OfficeInVC, animated:true, completion:nil)
					}

		}
			
			
//			if(AppManager.sharedInstance.isReachability) {
//				BeconeMethodaAPI()
//				EmployeeSignInChecking()
//			} else {
//				DispatchQueue.main.async {
//					print("Office IN Internet Unavailable")
//
//		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//		let OfficeInVC = storyBoard.instantiateViewController(withIdentifier: "OfficeInVC") as! OfficeInVC
//		self.present(OfficeInVC, animated:true, completion:nil)
//				}
//			}
//		}
	}
	
	
	func AttendanceOutime() {
		
		let isInternet: Bool = true
		if(isInternet == true) {
			
			EmployeeSignOut_Checking()
			BeconeMethodaAPI()
		}
		else
		{
					DispatchQueue.main.async {
						print("Office IN Internet Unavailable")
						
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let OfficeInVC = storyBoard.instantiateViewController(withIdentifier: "OfficeInVC") as! OfficeInVC
			self.present(OfficeInVC, animated:true, completion:nil)
					}

		}
	}
		
		
	
	
	func EmployeeSignInChecking()
	{
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint4 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint4)")!
		
		
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
				var empIsSupervisor_Manager: Bool?
				empIsSupervisor_Manager = (responseJSON["empIsSupervisor_Manager"] as? Bool)!
				print("empIsSupervisor_Manager ------------",empIsSupervisor_Manager as Any)
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
				
				DispatchQueue.main.async {
					let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
					print("Employee signdata ",ItemsDict)
					self.empAttndInDateTime = (ItemsDict["empAttndInDateTime"] as? String)!
					print("empAttndInDateTime ------------",self.empAttndInDateTime as Any)
					if (self.empAttndInDateTime == "NA")
					{
						self.SpecificTimeRange_SignIn()
						
					}
					else
					{
						let alert = UIAlertController(title: "Office IN",
													  message: "Attendance IN is already marked for the day",
													  preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
						self.present(alert, animated: true, completion: nil)
						print("Failure---")
					}
				}
			}
		}
		task.resume()
		
	}
	func SpecificTimeRange_SignIn()
		
	{
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint5 = "/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		//let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		let urlstring = "\(StartPoint)\(Endpoint5)"
		//let urlstring = "http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		let url = NSURL(string: urlstring)
		
		let URL:NSURL = NSURL(string: urlstring)!
		//let request: NSURLRequest = NSURLRequest(url: URL as URL)
		var request = URLRequest(url: URL as URL)
		request.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				return
			}
			if error != nil {
				//error
			} else {
				do {
					//let data = json.data(using: .utf8)!
					let jsonDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
					print("Json Data -----------",jsonDict)
					DispatchQueue.main.async {
						self.currentDatestr = (jsonDict["currentDate"] as? String)!
						
						
						let dateFormatter = DateFormatter()
						let tempLocale = dateFormatter.locale // save locale temporarily
						dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
						dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
						let Intimedate = dateFormatter.date(from: self.currentDatestr)!
						dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format
						dateFormatter.locale = tempLocale // reset the locale
						let IntimedateString = dateFormatter.string(from: Intimedate)
						
						
						print("current date time",IntimedateString)
						
						UserDefaults.standard.set(self.currentDatestr, forKey: "SignIncurrentDate")
						UserDefaults.standard.set(IntimedateString, forKey: "SignIntimedate")
						UserDefaults.standard.set(self.Facename, forKey: "Facename")
						UserDefaults.standard.synchronize()
						
						let loginvc = LogINVC.init(screen: UIScreen.main)
						//self.navigationController?.pushViewController(loginvc, animated: true)
						loginvc.modalPresentationStyle = .fullScreen
						self.present(loginvc, animated: true, completion: nil)
						
					}
					
				}
			}
		}
		task.resume()
		
	}
	
	func EmployeeSignOut_Checking()
	{
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint6 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint6)")!
		
		
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
				var empIsSupervisor_Manager: Bool?
				empIsSupervisor_Manager = (responseJSON["empIsSupervisor_Manager"] as? Bool)!
				print("empIsSupervisor_Manager ------------",empIsSupervisor_Manager as Any)
				let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
				
				DispatchQueue.main.async {
					let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
					print("Employee signdata ",ItemsDict)
					self.empAttndOutDateTime = (ItemsDict["empAttndOutDateTime"] as? String)!
					print("empAttndOutDateTime ------------",self.empAttndOutDateTime as Any)
					
					if (self.empAttndOutDateTime == "NA")
					{
						self.SpecificTimeRange_SignOut()
					}
					else
					{
						var alert = UIAlertController(title: "Office OUT", message:
							"Attendance OUT is already marked for the day" as! String, preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
						self.present(alert, animated: true, completion: nil)
						print("Failure---")
						
					}
				}
				
			}
		}
		task.resume()
	}
	
	
	
	func SpecificTimeRange_SignOut()
		
	{
		
		//let urlstring = "http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint7 = "/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		//let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		let urlstring = "\(StartPoint)\(Endpoint7)"
		
		let url = NSURL(string: urlstring)
		
		let URL:NSURL = NSURL(string: urlstring)!
		//let request: NSURLRequest = NSURLRequest(url: URL as URL)
		var request = URLRequest(url: URL as URL)
		request.httpMethod = "GET"
		//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				return
			}
			if error != nil {
			} else {
				do {
					//let data = json.data(using: .utf8)!
					let jsonDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
					print("Json Data -----------",jsonDict)
					
					
					
					DispatchQueue.main.async {
						self.currentDatestr = (jsonDict["currentDate"] as? String)!
						print("currentDatestr out -------",self.currentDatestr)
						let dateFormatter = DateFormatter()
						let tempLocale = dateFormatter.locale // save locale temporarily
						dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
						dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
						let outimedate = dateFormatter.date(from: self.currentDatestr)!
						dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format
						dateFormatter.locale = tempLocale // reset the locale
						let outtimedateString = dateFormatter.string(from: outimedate)
						print("luxan outtime EXACT_DATE : \(outtimedateString)")
						let calendar = Calendar.current
						let startTimeComponent = DateComponents(calendar: calendar, hour:self.ConvertoutPermissibleTime)
						print("startTimeComponent------",startTimeComponent)
						//print("endTimeComponent------",endTimeComponent)
						
						let now = Date()
						let startOfToday = calendar.startOfDay(for: now)
						let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
						//let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!
						
						if startTime <= now  {
							
							print("between 9 AM and 6 PM Signin")
							let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							UserDefaults.standard.set(self.currentDatestr, forKey: "currentDate")
							
							UserDefaults.standard.set(outtimedateString, forKey: "outtimedate")
							let objRecVC = LogOutVC(screen:  UIScreen.main)
							objRecVC.modalPresentationStyle = .fullScreen
							self.present(objRecVC, animated:true, completion:nil)
							
						}
						else
						{
							self.EmergencyTimeoutview.isHidden = false
							self.tabBarController?.tabBar.isHidden = true
							self.EmergencyoutBtn.layer.cornerRadius = 12
							let dateAsString = self.outPermissibleTime
							let dateFormatter = DateFormatter()
							dateFormatter.dateFormat = "HH:mm:ss"
							
							let date = dateFormatter.date(from: dateAsString)
							dateFormatter.dateFormat = "hh:mma"
							let Date12 = dateFormatter.string(from: date!)
							print("12 hour formatted Date:",Date12)
							var PermissionFirststr = "OUT is not permitted till"
							var PermissionSecondstr = Date12
							
							self.OutPermissionLbl.text = "\("OUT is not permitted till")  -  \(PermissionSecondstr)"
							
							let shadowPath = UIBezierPath(rect: self.view.bounds)
							self.EmergencyTimeoutview.layer.masksToBounds = false
							self.EmergencyTimeoutview.layer.shadowColor = UIColor.darkGray.cgColor
							self.EmergencyTimeoutview.layer.shadowOffset = CGSize(width: 0, height: 0.5)
							self.EmergencyTimeoutview.layer.shadowOpacity = 0.2
							self.EmergencyTimeoutview.layer.shadowPath = shadowPath.cgPath
							
						}
						
					}
					
				} catch {
				}
			}
		}
		task.resume()
		
	}
	
	func EmergencyExitOutime() {
		var isInternet: Bool = true
		if(isInternet == true)
		{
			
			EmergencyOuttime_Checking()
			BeconeMethodaAPI()
		}
		
		else
		{
			print("Makesure connect with wifi Network Unavailable")
			
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let OfficeInVC = storyBoard.instantiateViewController(withIdentifier: "OfficeInVC") as! OfficeInVC
			self.present(OfficeInVC, animated:true, completion:nil)
			//Show Alert
			
		}
			
	}
	
	func EmergencyOuttime_Checking()
	{
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint8 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint8)")!
		
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
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				return
			}
			
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print("Employee ---- Json Response",responseJSON)
				var empIsSupervisor_Manager: Bool?
				empIsSupervisor_Manager = (responseJSON["empIsSupervisor_Manager"] as? Bool)!
				print("empIsSupervisor_Manager ------------",empIsSupervisor_Manager as Any)
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
				DispatchQueue.main.async {
					let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
					print("Employee signdata ",ItemsDict)
					self.empAttndOutDateTime = (ItemsDict["empAttndOutDateTime"] as? String)!
					print("empAttndOutDateTime ------------",self.empAttndOutDateTime as Any)
					//
					//
					//                    if (self.empAttndOutDateTime == "NA")
					//                    {
					
					self.EmergencyExitOutTimeAPI()
					
					
					//                    }
					//                    else
					//                    {
					//
					//                        var alert = UIAlertController(title: "SignOut", message: "Attendance OUT is Alreday Apply for day" as! String, preferredStyle: UIAlertController.Style.alert)
					//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
					//                        self.present(alert, animated: true, completion: nil)
					//                        print("Failure---")
					//
					//                    }
					
				}
			}
			
		}
		task.resume()
		
	}
	
	
	func EmergencyExitOutTimeAPI()
		
	{
		
		//let urlstring = "http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint9 = "/attnd-api-gateway-service/api/customer/employee/mark/attendance/getCurrentDate"
		
		//let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		let urlstring = "\(StartPoint)\(Endpoint9)"
		
		
		
		let url = NSURL(string: urlstring)
		
		let URL:NSURL = NSURL(string: urlstring)!
		//let request: NSURLRequest = NSURLRequest(url: URL as URL)
		var request = URLRequest(url: URL as URL)
		request.httpMethod = "GET"
		//request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				return
			}
			if error != nil {
			} else {
				do {
					//let data = json.data(using: .utf8)!
					let jsonDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
					print("Json Data -----------",jsonDict)
					DispatchQueue.main.async {
						self.currentDatestr = (jsonDict["currentDate"] as? String)!
						print("currentDatestr out -------",self.currentDatestr)
						let dateFormatter = DateFormatter()
						let tempLocale = dateFormatter.locale // save locale temporarily
						dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
						dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
						let outimedate = dateFormatter.date(from: self.currentDatestr)!
						dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format
						dateFormatter.locale = tempLocale // reset the locale
						let outtimedateString = dateFormatter.string(from: outimedate)
						print("luxan outtime EXACT_DATE : \(outtimedateString)")
						let calendar = Calendar.current
						let startTimeComponent = DateComponents(calendar: calendar, hour:15, minute: 30)
						
						//ConvertShiftstartTime
						let endTimeComponent   = DateComponents(calendar: calendar, hour: 23, minute: 30)
						//let endTimeComponent   = DateComponents(calendar: calendar, hour: self.ConvertshiftEndTime)
						//ConvertshiftEndTime
						print("startTimeComponent------",startTimeComponent)
						print("endTimeComponent------",endTimeComponent)
						
						let now = Date()
						let startOfToday = calendar.startOfDay(for: now)
						let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
						let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!
						
						//if startTime <= now && now <= endTime {
						//self.PopupView.isHidden = false
						
						print("between 9 AM and 6 PM Signin")
						
						let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
						UserDefaults.standard.set(self.currentDatestr, forKey: "currentDate")
						
						UserDefaults.standard.set(outtimedateString, forKey: "outtimedate")
						let objRecVC = LogOutVC(screen:  UIScreen.main)
						objRecVC.modalPresentationStyle = .fullScreen
						self.present(objRecVC, animated:true, completion:nil)
						
					}
					
				} catch {
				}
			}
		}
		task.resume()
		
	}
	
	@IBAction func EmergencyExitBtn(_ sender: Any) {
		
		EmergencyExitOutime()
	}
	
	@IBOutlet weak var EmergencyTimeoutCancelBtn: UIView!
	
	@IBAction func EmergencyTimeOutBtn(_ sender: Any) {
		//Emergencybuttonview.isHidden = true
		EmergencyTimeoutview.isHidden = true
	}
	
	
	
	//MovementIn
	
	func MovementInUpdate()
		
	{
		
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint10 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint10)")!
		
		
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
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
				DispatchQueue.main.async
					{
						self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
						self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
						
						
						if (self.empAttndInDateTime == "NA" && self.empAttndOutDateTime == "NA") {
							
							let alert = UIAlertController(title: "Alert", message: "Movement is permitted during office hours only", preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)                            }                             else if (self.empAttndInDateTime != "NA" && self.empAttndOutDateTime == "NA") {
							
							self.MovementIn()
							
						}
						else
						{
							let alert = UIAlertController(title: "Alert", message: "Movement is permitted during office hours only", preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)
							
						}
						
				}
			}
		}
		task.resume()
	}
	
	
	func MovementOUT_Update()
	{
		let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint11 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint11)")!
		
		
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
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
				DispatchQueue.main.async
					{
						self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
						self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
						if (self.empAttndInDateTime == "NA" && self.empAttndOutDateTime == "NA") {
							
							let alert = UIAlertController(title: "Alert", message: "Movement is permitted during office hours only", preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)                            }                             else if (self.empAttndInDateTime != "NA" && self.empAttndOutDateTime == "NA") {
							
							self.MovementOut()
							
						}
						else
						{
							let alert = UIAlertController(title: "Alert", message: "Movement is permitted during office hours only", preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)
							
						}
						
						
						
						
						
				}
			}
		}
		task.resume()
		
		
		
	}
	
	
	func MovementIn() {
		
		BeconeMethodaAPI()
		MovementIn_API()
		
	}
	
	
	
	func MovementOut() {
		
		BeconeMethodaAPI()
		MovementOut_API()
		
			
	}
	
	
	func getAddress(handler: @escaping (String) -> Void)
	{
		
		
		let Locationlatitude = (LattitudestrData as NSString).doubleValue
		
		let Locationlongitude = (LongitudestrData as NSString).doubleValue
		let geoCoder = CLGeocoder()
		let location = CLLocation(latitude: Locationlatitude, longitude: Locationlongitude)
		
		
		print("latlanvalues------",location)
		
		//selectedLat and selectedLon are double values set by the app in a previous process
		
		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
			
			// Place details
			var placeMark: CLPlacemark?
			placeMark = placemarks?[0]
			
			// Address dictionary
			//print(placeMark.addressDictionary ?? "")
			
			// Location name
			if let locationName = placeMark?.addressDictionary?["Name"] as? String {
				self.address += locationName + ", "
			}
			
			// Street address
			if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
				self.address += street + ", "
			}
			
			// City
			if let city = placeMark?.addressDictionary?["City"] as? String {
				self.address += city + ", "
			}
			
			// Zip code
			if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
				self.address += zip + ", "
			}
			
			// Country
			if let country = placeMark?.addressDictionary?["Country"] as? String {
				self.address += country
			}
			// Passing address back
			handler(self.address)
		})
	}
	
	
	
	
	
	
	@objc func callback() {
		print("done--------")
		
		//Updatedetails()
		
	}
	
	
	
	
	
	func MovementIn_API()
	{
		var EmpAttendancedateString = ""
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		EmpAttendancedateString = formatter.string(from: date)
		print("EmpAttendancedate----",EmpAttendancedateString)
		
		print("For movement currentDate",self.currentDatestr)
		
		print("Movement In")
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print(" Movement InRetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("Movement In RetrivedempId----",RetrivedempId)
		
		let parameters = ["refEmpId": RetrivedempId as Any,
						  "empMovementDate": EmpAttendancedateString as Any,"empMovementMode":  "G" as Any,"empMovementDatetime":  currentDatestr as Any,"empMovementLatLong":  empAttendanceInLatLongstr as Any,"empMovementType":  "IN" as Any,"empPlaceOfVisit":  "" as Any] as [String : Any]
		
		//let url: NSURL = NSURL(string:"http://52.183.137.54:8080/attnd-api-gateway-service/api/customer/employee/movement/create")!
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint12 = "/attnd-api-gateway-service/api/customer/employee/movement/create"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint12)")!
		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/movement/create")!
		
		//http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/movement/create
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
				print("Json Response",responseJSON)
				let statusDic = responseJSON["status"]! as! NSDictionary
				print("Movement statusDic---",statusDic)
				
				DispatchQueue.main.async {
					
					let code = statusDic["code"] as? NSInteger
					print("Movement code-----",code as Any)
					
					if(code == 200)
					{
						
						
						self.customView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 275)
						self.customView.backgroundColor = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
						
						self.customView.backgroundColor = .white
						let shadowPath = UIBezierPath(rect: self.customView.bounds)
						self.customView.layer.masksToBounds = false
						self.customView.layer.shadowColor = UIColor.darkGray.cgColor
						self.customView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
						self.customView.layer.shadowOpacity = 0.8
						self.customView.layer.shadowPath = shadowPath.cgPath
						self.customView.center = self.view.center
						self.view.addSubview(self.customView)
						self.customSubView.frame = CGRect.init(x: 0, y: 0, width: 301, height: 135)
						self.customSubView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						self.customView.addSubview(self.customSubView)
						//image
						var imageView : UIImageView
						imageView  = UIImageView(frame:CGRect(x: 100, y: 10, width: 100, height: 100));
						imageView.image = UIImage(named:"conform.png")
						self.customView.addSubview(imageView)
						let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 21))
						label.text = "Thank you!"
						label.textColor = UIColor.white
						label.font = UIFont(name: "HelveticaNeue", size: CGFloat(18))
						self.customView.addSubview(label)
						let label1 = UILabel(frame: CGRect(x: 70, y: 150, width: 400, height: 21))
						label1.text = "Movement IN updated"
						label1.textColor = UIColor.darkGray
						label1.shadowColor = UIColor.gray
						label1.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
						self.customView.addSubview(label1)
						
						let label2 = UILabel(frame: CGRect(x: 100, y: 170, width: 400, height: 21))
						label2.text = "successfully "
						label2.textColor = UIColor.darkGray
						label2.shadowColor = UIColor.gray
						label2.font = UIFont(name: "HelveticaNeue", size: CGFloat(18))
						self.customView.addSubview(label2)
						let myButton = UIButton(type: .system)
						// Position Button
						myButton.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
						// Set text on button
						myButton.setTitle("OK", for: .normal)
						myButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
						myButton.setTitleColor(UIColor.white, for: .normal)
						
						// Set button action
						myButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
						self.customView.addSubview(myButton)
						self.customView.isHidden = false
						self.customSubView.isHidden = false
						self.VisitTextField.isHidden = false
						self.CancelBtnButton.isHidden = true
						self.submitButton.isHidden = true
						self.DrpdownBtn.isHidden = true
						
						print("success---")
						
					}
					else
					{
						let statusDic = responseJSON["status"]! as! NSDictionary
						print("statusDic---",statusDic)
						let message = statusDic["message"] as? NSString
						print("message-----",message as Any)
						var alert = UIAlertController(title: "Failure", message: message as! String, preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
						self.present(alert, animated: true, completion:nil)
						print("Failure---")
					}
					
				}
			}
			
		}
		task.resume()
		
	}
	
	func MovementOut_API()
	{
		print("Movement out")
		self.customView.frame = CGRect.init(x: 0, y: 0, width: 340, height: 225)
		self.customView.backgroundColor = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
		self.customView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)
		self.customView.layer.shadowColor = UIColor.red.cgColor
		self.customView.layer.shadowOpacity = 10
		self.customView.layer.shadowOffset = CGSize.zero
		self.customView.layer.shadowRadius = 0
		//give color to
		self.customView.center = self.view.center
		self.view.addSubview(self.customView)
		self.customSubView.frame = CGRect.init(x: 20, y: 85, width: 300, height: 55)
		self.customSubView.layer.cornerRadius = 3.0
		self.customSubView.layer.masksToBounds = true
		self.customSubView.backgroundColor = UIColor.white
		self.customView.addSubview(self.customSubView)
		VisitTextField = UITextField(frame: CGRect(x: 25, y: 87, width: 200, height: 50))
		VisitTextField.placeholder = "Enter Place Of Visit"
		VisitTextField.layer.borderWidth = 1
		VisitTextField.layer.borderColor = UIColor.clear.cgColor
		VisitTextField.autocorrectionType = UITextAutocorrectionType.no
		VisitTextField.keyboardType = UIKeyboardType.default
		VisitTextField.returnKeyType = UIReturnKeyType.done
		VisitTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
		VisitTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
		
		self.customView.addSubview(VisitTextField)
		//lable
		label = UILabel(frame: CGRect(x: 110, y: 40, width: 200, height: 21))
		label.text = "Movement"
		label.textColor = UIColor.white
		label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
		self.customView.addSubview(label)
		DrpdownBtn = UIButton(type: .system)
		let image = UIImage(named: "hand.png")! as UIImage
		// Position Button
		DrpdownBtn.frame = CGRect(x: 270, y: 90, width: 45, height: 40)
		DrpdownBtn .setBackgroundImage(image, for: UIControl.State.normal)
		// Set text on button
		//DrpdownBtn.setTitle("SUBMIT", for: .normal)
		DrpdownBtn.setTitle("Pressed + Hold", for: .highlighted)
		DrpdownBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
		// Set button action
		DrpdownBtn.addTarget(self, action: #selector(self.DrpdownBtnAction(_:)), for: .touchUpInside)
		self.customView.addSubview(DrpdownBtn)
		submitButton = UIButton(type: .system)
		// Position Button
		submitButton.frame = CGRect(x: 175, y: 165, width: 125, height: 40)
		// Set text on button
		submitButton.setTitle("SUBMIT", for: .normal)
		submitButton.setTitle("Pressed + Hold", for: .highlighted)
		submitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
		submitButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
		
		// Set button action
		submitButton.addTarget(self, action: #selector(self.SubmitBtnAction(_:)), for: .touchUpInside)
		self.customView.addSubview(submitButton)
		CancelBtnButton = UIButton(type: .system)
		// Position Button
		CancelBtnButton.frame = CGRect(x: 40, y: 165, width: 125, height: 40)
		// Set text on button
		CancelBtnButton.setTitle("CANCEL", for: .normal)
		CancelBtnButton.setTitle("Pressed + Hold", for: .highlighted)
		CancelBtnButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
		CancelBtnButton.layer.borderWidth = 1
		CancelBtnButton.layer.borderColor = UIColor.white.cgColor
		CancelBtnButton.backgroundColor = UIColor.clear
		
		// Set button action
		CancelBtnButton.addTarget(self, action: #selector(self.CancelAction(_:)), for: .touchUpInside)
		self.customView.addSubview(CancelBtnButton)
		customView.isHidden = false
		customSubView.isHidden = false
		VisitTextField.isHidden = false
		CancelBtnButton.isHidden = false
		submitButton.isHidden = false
		DrpdownBtn.isHidden = false
		print("success---")
		
	}
	
	
	@objc func buttonAction(_ sender:UIButton!)
	{
		print("Button tapped")
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
		self.present(UITabBarController, animated:true, completion:nil)
		
		//Updatedetails()
	}
	
	@objc func CancelAction(_ sender:UIButton!)
	{
		print("Button tapped")
		customView.isHidden = true
		customSubView.isHidden = true
		VisitTextField.isHidden = true
		CancelBtnButton.isHidden = true
		submitButton.isHidden = true
		DrpdownBtn.isHidden = true
		//label.text
		label.isHidden = true
		
		//Updatedetails()
	}
	
	@objc func DrpdownBtnAction(_ sender:UIButton!)
	{
		
		customSubView.isHidden = true
		DrpdownBtn.isHidden = true
		VisitTextField.isHidden = true
		MovementoutDrpTbl.isHidden = false
		
		print("Hellow--------")
		
		print("RetrivedcustId----",RetrivedcustId)
		let defaults = UserDefaults.standard
		
		RetrivedempId = defaults.integer(forKey: "empId")
		print("Movement dropdown RetrivedempId----",RetrivedempId)
		
		let parameters = [
			"refEmpId": RetrivedempId] as [String : Any]
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint13 = "/attnd-api-gateway-service/api/customer/employee/movement/getEmpPlaceOfVisitListByEmpId"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint13)")!
		
		
		
		//let url: NSURL = NSURL(string: "http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/movement/getEmpPlaceOfVisitListByEmpId")!
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/movement/create")!
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
				print("Json Response",responseJSON)
				
				let Inmatedict = responseJSON["empPlaceVisitList"] as! NSArray
				print("Array values----",Inmatedict)
				for VisitsubDictionary in Inmatedict as! [[String:Any]]
				{
					var MainDict:NSMutableDictionary = NSMutableDictionary()
					var empPlaceOfVisitstr = VisitsubDictionary["empPlaceOfVisit"] as? String
					print("empPlaceOfVisitstr-------",empPlaceOfVisitstr)
					MainDict.setObject(empPlaceOfVisitstr, forKey: "empPlaceOfVisit" as NSCopying)
					self.MovementOutDrpArray.add(MainDict)
					
				}
				
				DispatchQueue.main.async {
					self.MovementoutDrpTbl.reloadData()
					
				}
			}
		}
		task.resume()
		
	}
	
	@objc func SubmitBtnAction(_ sender:UIButton!)
	{
		print("submit Action Button tapped")
		
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
		
		var EmpAttendancedateString = ""
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		EmpAttendancedateString = formatter.string(from: date)
		print("EmpAttendancedate----",EmpAttendancedateString)
		
		
		
		print(" attendance empAttendanceInLatLongstr-----",empAttendanceInLatLongstr)
		
		//        "refEmpId":123,
		//        "empMovementDate":"2020-04-03",
		//        "empMovementMode":"G",
		//        "empMovementDatetime":"2020-04-03T15:52:48",
		//        "empMovementLatLong":"122366.5525",
		//         "empMovementType":"OUT",
		//         "empPlaceOfVisit":"kkl"
		
		let parameters = ["refEmpId": RetrivedempId as Any,
						  "empMovementDate": EmpAttendancedateString as Any,"empMovementMode":  "G" as Any,"empMovementDatetime":  currentDatestr as Any,"empMovementLatLong":  empAttendanceInLatLongstr as Any,"empMovementType":  "OUT" as Any,"empPlaceOfVisit":  VisitTextField.text as Any] as [String : Any]
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint14 = "/attnd-api-gateway-service/api/customer/employee/movement/create"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint14)")!
		

		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/movement/create")!
		//http://122.166.152.106:8080
		
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
				print("Json Response",responseJSON)
				let statusDic = responseJSON["status"]! as! NSDictionary
				print("Movement statusDic---",statusDic)
				DispatchQueue.main.async {
					if self.VisitTextField.text == "" {
						print("Please fill visit textfield")
						
						var alert = UIAlertController(title: "Alert", message: "Please Fill visit place" as! String, preferredStyle: UIAlertController.Style.alert)
						alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
						self.present(alert, animated: true, completion:nil)
						print("Failure---")
					}
					else
					{
						let code = statusDic["code"] as? NSInteger
						print("Movement code-----",code as Any)
						if(code == 200)
						{
							
							print("Movement success---")
							
							let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
							let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
							self.present(UITabBarController, animated:true, completion:nil)
						}else
						{
							let statusDic = responseJSON["status"]! as! NSDictionary
							print("statusDic---",statusDic)
							let message = statusDic["message"] as? NSString
							print("message-----",message as Any)
							var alert = UIAlertController(title: "Failure", message: message as! String, preferredStyle: UIAlertController.Style.alert)
							alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
							self.present(alert, animated: true, completion:nil)
							print("Failure---")
						}
					}
				}
			}
		}
		task.resume()
		
		//Updatedetails()
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
		var Endpoint15 = "/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint15)")!
		

		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile")!
		
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
						
				}
			}    }
		task.resume()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		
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


