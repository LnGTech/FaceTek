//
//  LeaveHistoryVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/15/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit


class LeaveHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
	
	var Currentdatestr : String = ""
	var SelectedDatestr : String = ""


	@IBOutlet weak var RejectedView: UIView!
	

	@IBOutlet weak var Dateselectedview: UIView!
	
	@IBOutlet weak var LeaveHistorytitleLbl: UILabel!
	
	@IBOutlet weak var SelectedDateLbl: UILabel!
	var LeaveHistoryData = NSMutableDictionary()

	@IBOutlet weak var Nodatafoundview: UIView!
	
	@IBOutlet weak var LeaveHistorytbl: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		Currentdatestr = dateFormatter.string(from: today)
		SelectedDateLbl.text = Currentdatestr
		
		
		Dateselectedview.layer.borderWidth = 1
		Dateselectedview.layer.borderColor = UIColor.lightGray.cgColor

		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.DateselectedViewAction))
		self.Dateselectedview.addGestureRecognizer(gesture)

				
		LeaveHistorytbl.isHidden = true
		Nodatafoundview.isHidden = true
		RejectedView.isHidden = true
		self.LeaveHistorytbl.rowHeight = 230.0
		LeaveHistorytitleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)!
		let LeaveHistorytitleattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorytitleLbl.font]
		LeaveHistorytitleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		SelectedDateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let LeaveHistoryselectedattributes :Dictionary = [NSAttributedStringKey.font : SelectedDateLbl.font]
		SelectedDateLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		

		LeaveHistorytbl.register(UINib(nibName: "LeaveHistorycell", bundle: nil), forCellReuseIdentifier: "LeaveHistorycell")

		LeaveHistorytbl.register(UINib(nibName: "LeaveHistoryHeadercell", bundle: nil), forCellReuseIdentifier: "LeaveHistoryHeadercell")

		
		
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 0.9680276113)
		view.addSubview(statusBarView)
		
		
		RejectedView.layer.cornerRadius = 20
		RejectedView.clipsToBounds = true
		RejectedView.layer.masksToBounds = false
		RejectedView.layer.shadowRadius = 7
		RejectedView.layer.shadowOpacity = 0.6
		RejectedView.layer.shadowOffset = CGSize(width: 0, height: 5)
		RejectedView.layer.shadowColor = UIColor.black.cgColor
		
		
		
		LeaveHistorymethod()

        // Do any additional setup after loading the view.
    }
	
	
	@objc func DateselectedViewAction(sender : UITapGestureRecognizer) {
		print("Selected date...")
		AKMonthYearPickerView.sharedInstance.barTintColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

			   AKMonthYearPickerView.sharedInstance.previousYear = 4
			   
			   AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
	}

	
    func LeaveHistorymethod()
	{
        print("Leave Proceed------")
       
		let defaults = UserDefaults.standard
		
		var RetrivedempId = defaults.integer(forKey: "empId")
		print(" RetrivedempId----",RetrivedempId)
		

		
        let parameters = ["empId": RetrivedempId as Any, "monthYear": Currentdatestr as Any] as [String : Any]
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: Currentdatestr)!

		dateFormatter.dateFormat = "MMM yyyy"
		let Convertdate = dateFormatter.string(from: myDate)
		print("Convertdate",Convertdate)
		SelectedDateLbl.text = Convertdate
		
        
		
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
			
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
			headerCell.Rejectedimg.isUserInteractionEnabled = true
			headerCell.addGestureRecognizer(tapGestureRecognizer)
			
			
			
			headerCell.LeavestsLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let LeaveHistorystsattributes :Dictionary = [NSAttributedStringKey.font : headerCell.LeavestsLbl.font]
			headerCell.LeavestsLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)

			
			headerCell.LeaveHistoryRejectedLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let LeaveHistoryRejectedattributes :Dictionary = [NSAttributedStringKey.font : headerCell.LeaveHistoryRejectedLbl.font]
			
			headerCell.LeaveHistoryRejectedLbl.isHidden = true
			headerCell.Rejectedimg.isHidden = true
			
            if let temp = dict?.value(forKey: "empLeaveStatus") as? String{
				
				var empLeaveStatus = ""
				
                 empLeaveStatus = temp
				if (empLeaveStatus == "App")
				{
					headerCell.LeaveHistoryRejectedLbl.text = "Approved"
					headerCell.Rejectedimg.isHidden = true
					headerCell.LeaveHistoryRejectedLbl.isHidden = false
					headerCell.LeaveHistoryRejectedLbl.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)

				}
					if (empLeaveStatus == "Rej")
					{
						headerCell.LeaveHistoryRejectedLbl.text = "Rejected"
						headerCell.Rejectedimg.isHidden = false
						headerCell.LeaveHistoryRejectedLbl.isHidden = false
						headerCell.LeaveHistoryRejectedLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

					}

				if (empLeaveStatus == "")

				{
					headerCell.LeaveHistoryRejectedLbl.text = "Pending"
					headerCell.LeaveHistoryRejectedLbl.isHidden = false
					headerCell.LeaveHistoryRejectedLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
					headerCell.Rejectedimg.isHidden = true
					
				}
				
            }
//
        }
       
        return headerCell
    }
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
	{

		RejectedView.isHidden = false

	print("image tapped")
		// Your action
	}
	
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let LeaveHistorycell = tableView.dequeueReusableCell(withIdentifier: "LeaveHistorycell", for: indexPath) as! LeaveHistorycell
         let arrLeaveHistory =  LeaveHistoryData.value(forKey: "empLeaveList") as! NSArray
        
		print("arrLeaveHistory...",arrLeaveHistory)
        let leaveTypeDetails = arrLeaveHistory.object(at: indexPath.section) as? NSDictionary
        var strLeavetypeName = ""
        if let temp = leaveTypeDetails?.value(forKey: "leaveType") as? String{
            strLeavetypeName = temp
        }
		
		
		
		
        let predict = NSPredicate(format: "leaveType = %@", strLeavetypeName)
        let arrFilter = arrLeaveHistory.filtered(using: predict) as NSArray
        if arrFilter.count > 0{
            let dictLeaveHistory = arrFilter.object(at: indexPath.row) as? NSDictionary
            //LeaveHistorycell.Leavetypename.text = dictEmp?.value(forKey: "leaveType") as? String
			
			var Fromdatestr = ""
			Fromdatestr = (dictLeaveHistory?.value(forKey: "empLeaveFrom") as? String)!
			var Todatestr = ""
			Todatestr = (dictLeaveHistory?.value(forKey: "empLeaveTo") as? String)!
			
			//var Datestr = Fromdatestr + Todatestr
			var Datestr = Fromdatestr + " To " + Todatestr
			LeaveHistorycell.DateLbl.text = Datestr
			
			
			var Noofdayscount = Int()

			Noofdayscount = (dictLeaveHistory?.value(forKey: "empLeaveDaysCount") as? NSInteger)!
			let ConvertstNoofdayscountr2 = String(Noofdayscount)
            LeaveHistorycell.NoofdaysLbl.text = ConvertstNoofdayscountr2
			
			
			LeaveHistorycell.LeavetypeLbl.text = (dictLeaveHistory?.value(forKey: "leaveType") as? String)!
			
			var empLeaveStatus : String = ""
			empLeaveStatus = (dictLeaveHistory?.value(forKey: "empLeaveStatus") as? String)!
			print("empLeaveStatus....",empLeaveStatus)
			
			
			LeaveHistorycell.Remarktxtview.text = (dictLeaveHistory?.value(forKey: "empLeaveRemarks") as? String)!
			
			
			
			LeaveHistorycell.LeavedatetxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let Datetxtattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.LeavedatetxtLbl.font]
			LeaveHistorycell.LeavedatetxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
			LeaveHistorycell.NofodaystxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let Noofdaystxtattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.NofodaystxtLbl.font]
			LeaveHistorycell.NofodaystxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
			LeaveHistorycell.LeavetypetxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let Leavetypetxttxtattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.LeavetypetxtLbl.font]
			LeaveHistorycell.LeavetypetxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
			LeaveHistorycell.LeaveremarktxtLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)!
			let Leaveremarktxttxtattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.LeaveremarktxtLbl.font]
			LeaveHistorycell.LeaveremarktxtLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			
			

			LeaveHistorycell.DateLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
			let Dateattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.DateLbl.font]
			LeaveHistorycell.DateLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
			
			LeaveHistorycell.NoofdaysLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
			let Noofdaysattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.NoofdaysLbl.font]
			LeaveHistorycell.NoofdaysLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
			
			LeaveHistorycell.LeavetypeLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
			let Leavetypeattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.LeavetypeLbl.font]
			LeaveHistorycell.LeavetypeLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
			
			LeaveHistorycell.Remarktxtview.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)!
			let Leaveremarksattributes :Dictionary = [NSAttributedStringKey.font : LeaveHistorycell.Remarktxtview.font]
			LeaveHistorycell.Remarktxtview.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)

			
			
			
			LeaveHistorycell.LeaveHistorycellBackview.layer.borderWidth = 1
			LeaveHistorycell.LeaveHistorycellBackview.layer.borderColor = UIColor.lightGray.cgColor
        }
        return LeaveHistorycell
    }
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 230;//Choose your custom row height
	}
	
	private func doneHandler() {
		
				print("Month picker Done button action")
		selected_date_DoneMethod()
    }
    
	
    private func completetionalHandler(month: Int, year: Int) {
        print( "month = ", month, " year = ", year )
		var Monthstr = String(month)
		var Yearstr = String(year)
		var Datestr = "1"

		SelectedDatestr = Yearstr + "-" + Monthstr + "-" + Datestr
		
		print("SelectedDatestr....",SelectedDatestr)
    }
	
	func selected_date_DoneMethod()
	{
			print("Leave Proceed------")
		   
			let defaults = UserDefaults.standard
			
			var RetrivedempId = defaults.integer(forKey: "empId")
			print(" RetrivedempId----",RetrivedempId)
			

			
			let parameters = ["empId": RetrivedempId as Any, "monthYear": SelectedDatestr as Any] as [String : Any]
		
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let myDate = dateFormatter.date(from: SelectedDatestr)!

		dateFormatter.dateFormat = "MMM yyyy"
		let Convertdate = dateFormatter.string(from: myDate)
		print("Convertdate",Convertdate)
		SelectedDateLbl.text = Convertdate
		
		
			
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
	
	
	@IBAction func Closebtn(_ sender: Any) {
		RejectedView.isHidden = true
		
	}
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
	
}

