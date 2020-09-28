//
//  MyTeamVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class MyTeamVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	
    var mDictAttendanceData = NSMutableDictionary()
    var marLeavesData = NSMutableArray()


	
	@IBOutlet weak var MyTeamtbl: UITableView!
	@IBOutlet weak var Nodataview: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.MyTeamtbl.rowHeight = 65

		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		Nodataview.isHidden = true
		
		  MyTeamtbl.register(UINib(nibName: "MyTeamtblCell", bundle: nil), forCellReuseIdentifier: "MyTeamtblCell")
		
		let parameters = ["brId": 83 as Any,"custId": 74 as Any,"empId": 353 as Any] as [String : Any]
			   
				var StartPoint = Baseurl.shared().baseURL
				var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getMyTeamDetails"
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
						print("Pending Leaves Json Response",responseJSON)
						DispatchQueue.main.async {
				let statusDic = responseJSON["status"]! as! NSDictionary
				print("status------",statusDic)
				let LeavePendingCode = statusDic["code"] as? NSInteger
				print("LeavePendingCode-----",LeavePendingCode as Any)
							 if (LeavePendingCode == 200)
							{
								
//								let empnamestr = statusDic["empName"] as? String
//
//
								 self.MyTeamtbl.isHidden = false
								
							   
								
							 }
							else
							{
		 
							  print("Not   Leaves")
								self.Nodataview.isHidden = false
							 }
										 
							
							 self.mDictAttendanceData = NSMutableDictionary()
							if responseJSON != nil{
								self.mDictAttendanceData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
								
								if let temp = self.mDictAttendanceData.value(forKey: "reportingEmployees") as? NSArray{
									self.marLeavesData = temp.mutableCopy() as! NSMutableArray
								}
								
							  

							}
						self.MyTeamtbl.reloadData()
		//                }
						}
					}
				}
				task.resume()
		
    }
	
//	func numberOfSections(in tableView: UITableView) -> Int {
//			return self.marLeavesData.count
//		   }
//
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return self.marLeavesData.count
		}
		
		  
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let MyTeamtblCell = tableView.dequeueReusableCell(withIdentifier: "MyTeamtblCell", for: indexPath) as! MyTeamtblCell
		let dicShiftDetails = marLeavesData.object(at: indexPath.row) as? NSDictionary
	
		MyTeamtblCell.nameLbl.text = dicShiftDetails?.value(forKey: "empName") as? String
		MyTeamtblCell.MobilenumberLbl.text = dicShiftDetails?.value(forKey: "empMobileNo") as? String
		let borderBottom = CALayer()
		let borderWidth = CGFloat(1.0)
		borderBottom.borderColor = UIColor.lightGray.cgColor
		borderBottom.frame = CGRect(x: 0, y: MyTeamtblCell.MyTeamcellview.frame.height - 1.0, width: MyTeamtblCell.MyTeamcellview.frame.width , height: MyTeamtblCell.MyTeamcellview.frame.height - 1.0)
	    borderBottom.borderWidth = borderWidth
		MyTeamtblCell.MyTeamcellview.layer.addSublayer(borderBottom)
		MyTeamtblCell.MyTeamcellview.layer.masksToBounds = true
		MyTeamtblCell.img.layer.borderWidth = 1
		MyTeamtblCell.img.layer.masksToBounds = false
		MyTeamtblCell.img.layer.borderColor = UIColor.green.cgColor
		MyTeamtblCell.img.layer.backgroundColor = UIColor.green.cgColor
		MyTeamtblCell.img.layer.cornerRadius = MyTeamtblCell.img.frame.height/2
		MyTeamtblCell.img.clipsToBounds = true
	//           }
		return MyTeamtblCell
		   }
	
    
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
