//
//  AttendanceHistoryVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/16/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import FSCalendar


class AttendanceHistoryVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
	var PreviousMonthDate = ""
	var count = 0
	var PreviousMonthDecreadID = Int()
	var increamentOrDecreamentValue = Int()
	var PreviousmonthValue = Int()
	var DecreamentValue = [String]()
	var presentDateArray = [String]()
	var absentDateArray = [String]()
	var WeeklyOffDateArray = [String]()
	var LeaveDateArray = [String]()
	var HolidayDateArray = [String]()


    var customView = UIView()
	var Currentdatestr : String = ""
	private weak var calendar: FSCalendar!
	@IBOutlet weak var AttendanceHistorytitleLbl: UILabel!
	@IBOutlet weak var PrevBtn: UIButton!
	@IBOutlet weak var PrevView: UIView!
	@IBOutlet weak var NextBtn: UIButton!
	@IBOutlet weak var PresentLbl: UILabel!
	@IBOutlet weak var AbsentLbl: UILabel!
	@IBOutlet weak var LeaveLbl: UILabel!
	@IBOutlet weak var HolidayLbl: UILabel!
	@IBOutlet weak var WeeklyOffLbl: UILabel!
	@IBOutlet weak var segctrl: UISegmentedControl!
	@IBOutlet weak var Fscalendarview: UIView!
	var AttendanceHistorydata = NSMutableDictionary()
    var AttendanceHistoryArray = NSMutableArray()
    override func viewDidLoad() {
	super.viewDidLoad()
	let calendar1 = Calendar.current
	let CurrentMonth = Calendar.current.component(.month, from: Date())
	PreviousMonthDate = String(CurrentMonth)
	increamentOrDecreamentValue = CurrentMonth
	PreviousmonthValue = CurrentMonth
    let AttendanceHistorytitleLblattributes :Dictionary = [NSAttributedStringKey.font : AttendanceHistorytitleLbl.font]
	AttendanceHistorytitleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
	AttendanceHistorytitleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)!
	let today = Date()
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd"
	Currentdatestr = dateFormatter.string(from: today)
	let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
	statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
	view.addSubview(statusBarView)
	self.customView.frame = CGRect.init(x: 0, y: 0, width: 350, height: 300)
	self.customView.backgroundColor = UIColor.white     //give color to the view
	self.Fscalendarview.center = self.customView.center
	self.Fscalendarview.addSubview(self.customView)
	let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 350, height: 300))
	calendar.dataSource = self
	calendar.delegate = self
	let leftUIView = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
	leftUIView.backgroundColor = .white
	self.Fscalendarview.addSubview(leftUIView)
	let rightUIView = UIButton(frame: CGRect(x: 250, y: 0, width: 80, height: 40))
	rightUIView.backgroundColor = .white
	self.Fscalendarview.addSubview(rightUIView)
	let Leftbutton = UIButton(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
    Leftbutton.setImage(UIImage(named: "Attendance-circled-left.png"), for: UIControlState.normal)
	Leftbutton.backgroundColor = .white
	Leftbutton.tag = 0
		Leftbutton.addTarget(self, action: #selector(LeftpressButton(_:)), for: .touchUpInside)
	self.Fscalendarview.addSubview(Leftbutton)
	let Rightbutton = UIButton(frame: CGRect(x: 300, y: 5, width: 40, height: 40))
	Rightbutton.setTitleColor(.blue, for: .normal)
	Rightbutton.setImage(UIImage(named: "Attendance-circled-lRight.png"), for: UIControlState.normal)
	Rightbutton.backgroundColor = .white
	Rightbutton.tag = 1
	Rightbutton.addTarget(self, action: #selector(RightpressButton(_:)), for: .touchUpInside)
	self.Fscalendarview.addSubview(Rightbutton)
	customView.addSubview(calendar)
	self.calendar = calendar
	AttendanceHistoryAPIMethod()

    }
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
		let dateFormatter3 = DateFormatter()
		dateFormatter3.dateFormat = "dd-MM-yyyy"
		let datestring2 : String = dateFormatter3.string(from: date)
		if presentDateArray.contains(datestring2)
		{
			return #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
		}
		else if absentDateArray.contains(datestring2)
		{
			return #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
		}
		else if WeeklyOffDateArray.contains(datestring2)
		{
			return #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
		}
			else if LeaveDateArray.contains(datestring2)
			{
				return #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
			}
			else if HolidayDateArray.contains(datestring2)
			{
				return #colorLiteral(red: 0.6862745098, green: 0.3215686275, blue: 0.8705882353, alpha: 1)
			}
			
		else
		{
			return appearance.titleSelectionColor
			return nil
		}

	}
	func AttendanceHistoryAPIMethod()
	{
		let defaults = UserDefaults.standard
		var RetrivedcustId = defaults.integer(forKey: "custId")
		var RetrivedempId = defaults.integer(forKey: "empId")
		var RetrivedbrId = defaults.integer(forKey: "brId")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: Currentdatestr)!
		dateFormatter.dateFormat = "yyyy-MM"
		let Convertdate = dateFormatter.string(from: myDate)
		var Datestr = "\(Convertdate)\("-01")"
		let parameters = ["empId": RetrivedempId as Any, "brId": RetrivedbrId as Any,"date": Datestr as Any] as [String : Any]
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport"
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
		if let responseJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
		let presentdetails = responseJSON["present"] as? [[String:Any]],
		let Absentdetails = responseJSON["absent"] as? [[String:Any]],
		let Weeklyoffdetails = responseJSON["weeklyOff"] as? [[String:Any]],let leavedetailes = responseJSON["leave"] as? [[String:Any]],let holidaydetailes = responseJSON["holiday"] as? [[String:Any]] {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		self.presentDateArray = presentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.compactMap {
		dateFormatter.string(from:$0)
		}
		self.absentDateArray = Absentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
		self.WeeklyOffDateArray = Weeklyoffdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
			self.LeaveDateArray = leavedetailes.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
			self.HolidayDateArray = holidaydetailes.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
		self.absentDateArray.count

		print("absentDateArray",self.absentDateArray)
		DispatchQueue.main.async
		{
		var convertPresentstr = String(self.presentDateArray.count)
		self.PresentLbl.text = convertPresentstr
		var convertAbsentstr = String(self.absentDateArray.count)
		self.AbsentLbl.text = convertAbsentstr
		var convertWeeklyOffstr = String(self.WeeklyOffDateArray.count)
		self.WeeklyOffLbl.text = convertWeeklyOffstr
			
			var converholidaystr = String(self.HolidayDateArray.count)
			self.HolidayLbl.text = converholidaystr
			var convertleavestr = String(self.LeaveDateArray.count)
			self.LeaveLbl.text = convertleavestr

			self.calendar.reloadData()
		}
		}
		}
	
				task.resume()
		}
	func maximumDate(for calendar: FSCalendar) -> Date {
		return Date()
	}
	@objc func LeftpressButton(_ sender: Any) {
		
		let previousMonthCalendar = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)
        calendar.setCurrentPage(previousMonthCalendar!, animated: true)
		let currentPageDate = calendar.currentPage
		let month = Calendar.current.component(.month, from: currentPageDate)
		let formatter = NumberFormatter()
		formatter.minimumIntegerDigits = 2
		let Previousmonth = formatter.string(from: NSNumber(value: month))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: Currentdatestr)!
		dateFormatter.dateFormat = "yyyy"
		let Convertdate = dateFormatter.string(from: myDate)
		let DecreamentMonth = "\(Convertdate)-\(String(describing: Previousmonth!))"
		let Decreamentstr = "\(DecreamentMonth)\("-01")"
		let defaults = UserDefaults.standard
		var RetrivedcustId = defaults.integer(forKey: "custId")
		var RetrivedempId = defaults.integer(forKey: "empId")
		var RetrivedbrId = defaults.integer(forKey: "brId")
	    let parameters = ["empId": RetrivedempId as Any, "brId": RetrivedbrId as Any,"date": Decreamentstr as Any] as [String : Any]
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport"
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
		if let responseJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
		let presentdetails = responseJSON["present"] as? [[String:Any]],
		let Absentdetails = responseJSON["absent"] as? [[String:Any]],let Weeklyoffdetails = responseJSON["weeklyOff"] as? [[String:Any]] {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		self.presentDateArray = presentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.compactMap {
		dateFormatter.string(from:$0)
		}
	   self.absentDateArray = Absentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
	  self.WeeklyOffDateArray = Weeklyoffdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
		self.absentDateArray.count
		print("absentDateArray",self.absentDateArray.count)
		print("presentDateArray",self.presentDateArray)
		print("absentDateArray",self.absentDateArray)
		DispatchQueue.main.async
		{
		var convertPresentstr = String(self.presentDateArray.count)
		self.PresentLbl.text = convertPresentstr
		var convertAbsentstr = String(self.absentDateArray.count)
	    self.AbsentLbl.text = convertAbsentstr
	    var convertWeeklyOffstr = String(self.WeeklyOffDateArray.count)
		self.WeeklyOffLbl.text = convertWeeklyOffstr
		self.calendar.reloadData()
		}
		}
	}
	task.resume()
						}
	
	
	@objc func RightpressButton(_ sender: Any) {
	let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)
	calendar.setCurrentPage(nextMonth!, animated: true)
    let currentPageDate = calendar.currentPage
	let month = Calendar.current.component(.month, from: currentPageDate)
	let formatter = NumberFormatter()
	formatter.minimumIntegerDigits = 2
	let Nextmonth = formatter.string(from: NSNumber(value: month))
	print("Nextmonth",Nextmonth as Any)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd"
	let myDate = dateFormatter.date(from: Currentdatestr)!
	dateFormatter.dateFormat = "yyyy"
	let Convertdate = dateFormatter.string(from: myDate)
	let IncreamentMonth = "\(Convertdate)-\(String(describing: Nextmonth!))"
	let Increamentmonthstr = "\(IncreamentMonth)\("-01")"
	let defaults = UserDefaults.standard
	var RetrivedcustId = defaults.integer(forKey: "custId")
	var RetrivedempId = defaults.integer(forKey: "empId")
	var RetrivedbrId = defaults.integer(forKey: "brId")
	let parameters = ["empId": RetrivedempId as Any, "brId": RetrivedbrId as Any,"date": Increamentmonthstr as Any] as [String : Any]
	var StartPoint = Baseurl.shared().baseURL
    var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport"
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
		
	if let responseJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
	let presentdetails = responseJSON["present"] as? [[String:Any]],
	let Absentdetails = responseJSON["absent"] as? [[String:Any]],let Weeklyoffdetails = responseJSON["weeklyOff"] as? [[String:Any]] {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "dd-MM-yyyy"
	self.presentDateArray = presentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.compactMap {
	dateFormatter.string(from:$0)
	}
    self.absentDateArray = Absentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
    self.WeeklyOffDateArray = Weeklyoffdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
	self.absentDateArray.count
	DispatchQueue.main.async
	{
	var convertPresentstr = String(self.presentDateArray.count)
    self.PresentLbl.text = convertPresentstr
	var convertAbsentstr = String(self.absentDateArray.count)
	self.AbsentLbl.text = convertAbsentstr
	var convertWeeklyOffstr = String(self.WeeklyOffDateArray.count)
	self.WeeklyOffLbl.text = convertWeeklyOffstr
	self.calendar.reloadData()
	}
    }
	}
	task.resume()
	}
	@IBAction func PrevBtnclk(_ sender: Any) {
	calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
	}
	@IBAction func NextBtnclk(_ sender: Any) {
	calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
	}
	
	func getNextMonth(date:Date)->Date {
		return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
	}

	func getPreviousMonth(date:Date)->Date {
		return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
	}
	
	@IBAction func Btnclk(_ sender: Any) {
	}
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)

	}
	
}

	

