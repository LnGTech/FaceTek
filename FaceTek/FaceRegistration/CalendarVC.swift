//
//  CalendarVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/27/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var Calendartbl: UITableView!
	var CalendarData = NSMutableDictionary()
    var CalendarArray = NSMutableArray()
    
    
    var DayArray = ["Wed","Wed","Sun","Fri","Wed","Sat","Fri","Sun","Mon","Mon","Sun","Sat","Fri"]

    var CalendarEventdayArray = ["New Year","Makara Sankranti","Republic Day","Maha Shivaratri","Ugadi","Ganesh Chaturthi","Gandhi Jayanti","Maha Navami,Ayudapooja","Vijaya Dashami","Kannada Rajyothsava","Deepavali","Christmas"]

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendartbl.register(UINib(nibName: "Calendarcell", bundle: nil), forCellReuseIdentifier: "Calendarcell")
        
        
		let parameters = ["refbrId": 12 as Any] as [String : Any];
		
//		var StartPoint = Baseurl.shared().baseURL
//		var Endpoint = "/attnd-api-gateway-service/api/customer/employee/setup/generateOtp"
		
		let url: NSURL = NSURL(string:"http://52.183.137.54:8080/attnd-api-gateway-service/api/customer/mobile/holidayClaendar/getholidayListByBrId")!
		
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
						let Calendarcode = statusDic["code"] as? NSInteger
						print("Calendar code-----",Calendarcode as Any)
//									 if (LeavePendingCode == 200)
//									{
//
//		//								let empnamestr = statusDic["empName"] as? String
//		//
//		//
//										 self.MyTeamtbl.isHidden = false
//
//
//
//									 }
//									else
//									{
//
//									  print("Not   Leaves")
//										self.Nodataview.isHidden = false
//									 }
//
									
									 self.CalendarData = NSMutableDictionary()
									if responseJSON != nil{
										self.CalendarData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
										
										if let temp = self.CalendarData.value(forKey: "holidayList") as? NSArray{
											self.CalendarArray = temp.mutableCopy() as! NSMutableArray
										}
										
									  

									}
								self.Calendartbl.reloadData()
				//                }
								}
							}
						}
						task.resume()
	}
		
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count:Int?
        
        if tableView == self.Calendartbl {
			count = self.CalendarArray.count
        }
       
        return count!
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "Calendarcell", for: indexPath) as! Calendarcell
        //cell.accessoryType = .disclosureIndicator
        
        
        
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(2.0)
        borderBottom.borderColor = UIColor.gray.cgColor
        borderBottom.frame = CGRect(x: 0, y: cell.Bckview.frame.height - 1.0, width: cell.Bckview.frame.width , height: cell.Bckview.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        cell.Bckview.layer.addSublayer(borderBottom)
        cell.Bckview.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        cell.Bckview.layer.borderWidth = 2.0
        cell.Bckview.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        // set the shadow properties
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 4.0
        
        
		
		let CalendarDetails = CalendarArray.object(at: indexPath.row) as? NSDictionary
		cell.EventdayLbl.text = CalendarDetails?.value(forKey: "holidayName") as? String
		
			cell.DateLbl.text = CalendarDetails?.value(forKey: "holidayDate") as? String
		//cell.DayLbl.text = CalendarDetails?.value(forKey: "day") as? String
		
		let Daystr = CalendarDetails?.value(forKey: "day") as? String
		
		let DaystrLbl = String(Daystr!.prefix(3))
		cell.DayLbl.text = DaystrLbl

		cell.EventdayLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
		let holidayNameattributes :Dictionary = [NSAttributedStringKey.font : cell.EventdayLbl.font]
		
		cell.DateLbl.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
		let holidayDateattributes :Dictionary = [NSAttributedStringKey.font : cell.DateLbl.font]
		
		cell.DayLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)!
		let dayattributes :Dictionary = [NSAttributedStringKey.font : cell.DayLbl.font]
		
		cell.EventdayLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
		cell.DateLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
		cell.DayLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)



		
		
		
		
			//cell.MobilenumberLbl.text = CalendarDetails?.value(forKey: "holidayName") as? String
			
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    @IBAction func cancelBtn(_ sender: Any) {
        
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)

        

    }
    
    
}
