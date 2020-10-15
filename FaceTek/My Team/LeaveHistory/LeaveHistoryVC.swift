//
//  LeaveHistoryVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/15/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LeaveHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
    var LeaveHistoryData = NSMutableDictionary()

	@IBOutlet weak var Nodatafoundview: UIView!
	
	@IBOutlet weak var LeaveHistorytbl: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		LeaveHistorytbl.isHidden = true
		Nodatafoundview.isHidden = true
		
		LeaveHistorytbl.register(UINib(nibName: "LeaveHistorycell", bundle: nil), forCellReuseIdentifier: "LeaveHistorycell")

		LeaveHistorytbl.register(UINib(nibName: "LeaveHistoryHeadercell", bundle: nil), forCellReuseIdentifier: "LeaveHistoryHeadercell")

		
		
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		LeaveHistorymethod()

        // Do any additional setup after loading the view.
    }
    func LeaveHistorymethod()
	{
        print("Leave Proceed------")
       
        let parameters = ["empId": 358 as Any, "monthYear": "2020-09-01" as Any] as [String : Any]
        
		
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
                     self.LeaveHistoryData = NSMutableDictionary()
                    if responseJSON != nil{
                        self.LeaveHistoryData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
				
				DispatchQueue.main.async {
					self.LeaveHistorytbl.reloadData()
				}
                }
            }
        
        task.resume()
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
        if LeaveHistoryData.allKeys.count > 0{
            if let temp = LeaveHistoryData.value(forKey: "empLeaveList") as? NSArray{
                return temp.count
            }
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  LeaveHistoryData.allKeys.count > 0{
            var arrSectionsData = NSArray()
            if let temp = LeaveHistoryData.value(forKey: "empLeaveList") as? NSArray{
                arrSectionsData = temp
            }
            if arrSectionsData.count > 0{
                let dict = arrSectionsData.object(at: section) as? NSDictionary
                if let temp = dict?.value(forKey: "empLeaveDaysCount") as? Int{
                    return temp
                }
                return 0
            }
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "LeaveHistoryHeadercell") as! LeaveHistoryHeadercell
        var arrSectionsData = NSArray()
        if let temp = LeaveHistoryData.value(forKey: "empLeaveList") as? NSArray{
            arrSectionsData = temp
        }
        if arrSectionsData.count > 0{
            let dict = arrSectionsData.object(at: section) as? NSDictionary
			//headerCell.Leavestatusname.text = "Leave Status"
			headerCell.LeaveHistorystatusview.layer.borderWidth = 1
			headerCell.LeaveHistorystatusview.layer.borderColor = UIColor.lightGray.cgColor
			
			
//            if let temp = dict?.value(forKey: "totalCount") as? Int{
//                headerCell.lblCount.text = "count: \(temp)"
//            }
//            var strTimings = ""
//            if let shiftStarttime = dict?.value(forKey: "shiftStart") as? String{
//                strTimings = shiftStarttime
//            }
//            if let shiftEndtime = dict?.value(forKey: "shiftEnd") as? String{
//                //strTimings = strTimings + shiftEndtime
//                strTimings = "\(strTimings)  -  \(shiftEndtime)"
//
//            }
//             headerCell.lblTimings.text = strTimings
//            if let temp = dict?.value(forKey: "shiftName") as? String{
//                 headerCell.lblShiftName.text = temp
//            }
//
        }
       
        return headerCell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let LeaveHistorycell = tableView.dequeueReusableCell(withIdentifier: "LeaveHistorycell", for: indexPath) as! LeaveHistorycell
         let arrLeaveHistory =  LeaveHistoryData.value(forKey: "empLeaveList") as! NSArray
        
        let leaveTypeDetails = arrLeaveHistory.object(at: indexPath.section) as? NSDictionary
        var strLeavetypeName = ""
        if let temp = leaveTypeDetails?.value(forKey: "leaveType") as? String{
            strLeavetypeName = temp
        }
        let predict = NSPredicate(format: "leaveType = %@", strLeavetypeName)
        let arrFilter = arrLeaveHistory.filtered(using: predict) as NSArray
        if arrFilter.count > 0{
            let dictEmp = arrFilter.object(at: indexPath.row) as? NSDictionary
            LeaveHistorycell.Leavetypename.text = dictEmp?.value(forKey: "leaveType") as? String
        }
        return LeaveHistorycell
    }
	
}

