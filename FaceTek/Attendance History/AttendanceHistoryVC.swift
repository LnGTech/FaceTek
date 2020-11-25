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
		print("current date",Currentdatestr)
		//SelectedDateLbl.text = Currentdatestr
		
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
		
		let Leftbutton = UIButton(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
		Leftbutton.setImage(UIImage(named: "Attendance-circled-left.png"), for: UIControlState.normal)
		Leftbutton.backgroundColor = .white
		Leftbutton.tag = 0
		
		Leftbutton.addTarget(self, action: #selector(LeftpressButton(_:)), for: .touchUpInside)
		self.Fscalendarview.addSubview(Leftbutton)

		
		let Rightbutton = UIButton(frame: CGRect(x: 300, y: 5, width: 40, height: 40))
		//button.setTitle("Prev", for: UIControlState.normal)
		Rightbutton.setTitleColor(.blue, for: .normal)

		//AttnceHitry.jpeg
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
		
		//let dateFormatter = DateFormatter()

		let datestring2 : String = dateFormatter3.string(from: date)
		if presentDateArray.contains(datestring2)
		{
			//return UIColor.green
			
			return #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9176470588, alpha: 1)
		}
		else if absentDateArray.contains(datestring2)
		{
			//return UIColor.red
			return #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
		}
			else if WeeklyOffDateArray.contains(datestring2)
			{
				//return UIColor.blue
				
				return #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
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
			print(" RetrivedcustId----",RetrivedcustId)
			var RetrivedempId = defaults.integer(forKey: "empId")
			print(" RetrivedempId----",RetrivedempId)
			var RetrivedbrId = defaults.integer(forKey: "brId")
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: Currentdatestr)!
		dateFormatter.dateFormat = "yyyy-MM"
		let Convertdate = dateFormatter.string(from: myDate)
		print("Convertdate",Convertdate)
		var Datestr = "\(Convertdate)\("-01")"
		print("Datestr-----",Datestr)
			print(" RetrivedbrId----",RetrivedbrId)
		let parameters = ["empId": RetrivedempId as Any, "brId": RetrivedbrId as Any,"date": Datestr as Any] as [String : Any]


			var StartPoint = Baseurl.shared().baseURL
			var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport"

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
				
				if let responseJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
								let presentdetails = responseJSON["present"] as? [[String:Any]],
								let Absentdetails = responseJSON["absent"] as? [[String:Any]],let Weeklyoffdetails = responseJSON["weeklyOff"] as? [[String:Any]] {

								let dateFormatter = DateFormatter()
								//dateFormatter.dateFormat = "yyyy-MM-dd"

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

	
	func maximumDate(for calendar: FSCalendar) -> Date {
		return Date()
		
		
	}
	
	
	
	@objc func LeftpressButton(_ sender: Any) {
		//let previousMonthCalendar = Calendar.current.date(byAdding: .month, value: -1, to: Date())
		
		
		let previousMonthCalendar = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)
        calendar.setCurrentPage(previousMonthCalendar!, animated: true)

		if(PreviousmonthValue != 0){
			   PreviousmonthValue -= 1;
		   }
		let PreviousmonthDecreamentValue = "\(PreviousmonthValue)"
		print("PreviousmonthDecreamentValue..",PreviousmonthDecreamentValue)
		
		print("PreviousmonthDecreamentValue..",PreviousmonthDecreamentValue)

		

		
		
		
		if(PreviousmonthDecreamentValue == "11")
		{
			print("November")
			//PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "10")
		{
			print("October")
			PreviousmonthAPIData()

		}
		 else if (PreviousmonthDecreamentValue == "9")
		{
			
			DispatchQueue.main.async {
				
				print("September")
				self.PreviousmonthAPIData()
			}
			

		}
		else if (PreviousmonthDecreamentValue == "8")
		{
			print("August")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "7")
		{
			print("July")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "6")
		{
			print("June")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "5")
		{
			print("May")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "4")
		{
			print("April")
			PreviousmonthAPIData()

		}

		else if (PreviousmonthDecreamentValue == "3")
		{
			print("March")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "2")
		{
			print("February")
			PreviousmonthAPIData()

		}
		else if (PreviousmonthDecreamentValue == "1")
		{
			print("January")
			PreviousmonthAPIData()

		}



		
		
				}
	
	
	@objc func RightpressButton(_ sender: Any) {
	let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)
	calendar.setCurrentPage(nextMonth!, animated: true)
		print("Right button clicked")
	
	}

	func PreviousmonthAPIData()
	{
		if(increamentOrDecreamentValue != 0){
			   increamentOrDecreamentValue -= 1;
		   }
		var DecreamentValue = "\(increamentOrDecreamentValue)"
		print("DecreamentValue..calling",DecreamentValue)

		if DecreamentValue.characters.count == 1 {
			DecreamentValue = "0\(DecreamentValue)"
		}

		print(DecreamentValue)
		
		
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				let myDate = dateFormatter.date(from: Currentdatestr)!
				dateFormatter.dateFormat = "yyyy"
				let Convertdate = dateFormatter.string(from: myDate)
				var DecreamentDatestr = "\(Convertdate)-\(DecreamentValue)"
				var decrmtDatestr = "\(DecreamentDatestr)\("-01")"
				print("decrmtDatestr..",decrmtDatestr)
		
		
		
				let defaults = UserDefaults.standard
						var RetrivedcustId = defaults.integer(forKey: "custId")
						print(" RetrivedcustId----",RetrivedcustId)
						var RetrivedempId = defaults.integer(forKey: "empId")
						print(" RetrivedempId----",RetrivedempId)
						var RetrivedbrId = defaults.integer(forKey: "brId")
		
						print(" RetrivedbrId----",RetrivedbrId)
					let parameters = ["empId": RetrivedempId as Any, "brId": RetrivedbrId as Any,"date": decrmtDatestr as Any] as [String : Any]
		
		
						var StartPoint = Baseurl.shared().baseURL
						var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport"
		
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
		
							if let responseJSON = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String:Any],
											let presentdetails = responseJSON["present"] as? [[String:Any]],
											let Absentdetails = responseJSON["absent"] as? [[String:Any]],let Weeklyoffdetails = responseJSON["weeklyOff"] as? [[String:Any]] {
		
											let dateFormatter = DateFormatter()
											//dateFormatter.dateFormat = "yyyy-MM-dd"
		
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
			
	
		
	@IBAction func PrevBtnclk(_ sender: Any) {
		calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
	}
	
	@IBAction func NextBtnclk(_ sender: Any) {
		
		print("Tapped")
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

	

