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
	
	var presentDateArray = [String]()
	var absentDateArray = [String]()
	var WeeklyOffDateArray = [String]()
    var customView = UIView()


	
	private weak var calendar: FSCalendar!
	
	
	
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

			var RetrivedempId = defaults.integer(forKey: "empId")

		let parameters = ["empId": 358 as Any, "brId": 83 as Any,"date":"2020-10-01" as Any] as [String : Any]

//			let dateFormatter = DateFormatter()
//			dateFormatter.dateFormat = "yyyy-MM-dd"
//			let myDate = dateFormatter.date(from: Currentdatestr)!
//
//			dateFormatter.dateFormat = "MMM yyyy"
//			let Convertdate = dateFormatter.string(from: myDate)
//			print("Convertdate",Convertdate)
//			SelectedDateLbl.text = Convertdate
//


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
	
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}

	

