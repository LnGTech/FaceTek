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
	
	private weak var calendar: FSCalendar!

	@IBOutlet weak var segctrl: UISegmentedControl!
	
	@IBOutlet weak var Fscalendarview: UIView!
	var AttendanceHistorydata = NSMutableDictionary()
    var AttendanceHistoryArray = NSMutableArray()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 340, height: 300))
		calendar.dataSource = self
		calendar.delegate = self
		Fscalendarview.addSubview(calendar)
		self.calendar = calendar
		
		
		AttendanceHistoryAPIMethod()

    }
	
	
	
//	func getdateFromJSON()
//	{
//		let url = NSURL(string: "http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/mobile/employee/getOneMonthReport")
//		let request = NSMutableURLRequest(url: url! as URL)
//		let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error)
//			in
//			guard error == nil && data != nil else
//			{
//				print("Error:",error ?? "error")
//				return
//			}
//			let httpstatus = response as? HTTPURLResponse
//			if httpstatus?.statusCode == 200
//			{
//				if data?.count != 0
//				{
//					if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String:Any],
//						let presentdetails = responseJSON["Present"] as? [[String:Any]],
//						let Absentdetails = responseJSON["Absent"] as? [[String:Any]] {
//
//						let dateFormatter = DateFormatter()
//						dateFormatter.dateFormat = "yyyy-MM-dd"
//
//
//						self.presentDateArray = presentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.compactMap {
//							dateFormatter.string(from:$0)
//						}
//						self.absentDateArray = Absentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
//						DispatchQueue.main.async
//							{
//								self.calendar.reloadData()
//						}
//					}
//				}
//				else
//				{
//					print("No data got from URL")
//				}
//			}
//			else{
//				print("error httpstatus code is :",httpstatus?.statusCode ?? "5")
//			}
//
//		}
//		task.resume()
//	}
	

//
//	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//
//		let dateString = date.toString(dateFormat: "yyyy-MM-dd")
//		if self.presentDateArray.contains(dateString!) {
//			return [UIColor.blue]
//		}
//		return [UIColor.white]
//	}
	

	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
		
		let dateFormatter3 = DateFormatter()
		dateFormatter3.dateFormat = "dd-MM-yyyy"
		
		//let dateFormatter = DateFormatter()

		let datestring2 : String = dateFormatter3.string(from: date)
		if presentDateArray.contains(datestring2)
		{
			return UIColor.green
		}
		else if absentDateArray.contains(datestring2)
		{
			return UIColor.red
			
		}
		else
		{
			return nil
		}

	}

	
	
	func AttendanceHistoryAPIMethod()
	{
			print("Leave Proceed------")

			let defaults = UserDefaults.standard

			var RetrivedempId = defaults.integer(forKey: "empId")
			print(" RetrivedempId----",RetrivedempId)



		let parameters = ["empId": RetrivedempId as Any, "brId": 83 as Any,"date":"2020-10-03" as Any] as [String : Any]

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
								let Absentdetails = responseJSON["absent"] as? [[String:Any]] {

								let dateFormatter = DateFormatter()
								//dateFormatter.dateFormat = "yyyy-MM-dd"

					dateFormatter.dateFormat = "dd-MM-yyyy"

								self.presentDateArray = presentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.compactMap {
									dateFormatter.string(from:$0)
									
									
								}
								self.absentDateArray = Absentdetails.compactMap { dateFormatter.date(from: $0["date"] as! String) }.flatMap { dateFormatter.string(from:$0) }
					
					self.absentDateArray.count
					print("absentDateArray",self.absentDateArray.count)

					
					print("presentDateArray",self.presentDateArray)

					print("absentDateArray",self.absentDateArray)
								DispatchQueue.main.async
									{
										self.calendar.reloadData()
								}
							
						
				}
				}
	

				task.resume()
		}




}
	

