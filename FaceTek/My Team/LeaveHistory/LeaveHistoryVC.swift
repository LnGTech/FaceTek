//
//  LeaveHistoryVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/15/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LeaveHistoryVC: UIViewController {
	
	@IBOutlet weak var Nodatafoundview: UIView!
	
	@IBOutlet weak var LeaveHistorytbl: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		LeaveHistorytbl.isHidden = true
		Nodatafoundview.isHidden = true
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		LeaveHistorymethod()

        // Do any additional setup after loading the view.
    }
    func LeaveHistorymethod()
	{
        print("Leave Proceed------")
       
        let parameters = ["empId": 358 as Any, "monthYear": "2020-10-01" as Any] as [String : Any]
        
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmployeeLeaveList"
		
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Leave History Json Response",responseJSON)
                DispatchQueue.main.async {
             if let absentShiftDetailsid = responseJSON["empLeaveList"] as? NSNull {
            
         print("null values printed.....")
				self.Nodatafoundview.isHidden = false

//             self.NoLeavesView.isHidden = false
//            self.Absenttbl.isHidden = true
                                        }
            else
            {
				self.LeaveHistorytbl.isHidden = false

        print("Normal values printed....")
        }
                
                    }
//                     self.mDictAttendanceData = NSMutableDictionary()
//                    if responseJSON != nil{
//                        self.mDictAttendanceData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
//                    }
//                   self.Absenttbl.reloadData()
                }
            }
        
        task.resume()
    }
}

