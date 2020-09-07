//
//  PendingLeavesVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/28/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class PendingLeavesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var RetrivedcustId = Int()
       var RetrivedempId = Int()
    var empLeaveDaysCount = Int()
    var empLeaveId = Int()
    var Convertdaycount = ""
    var ConvertEmpLeaveId = ""

    
    

    

    
    var mDictAttendanceData = NSMutableDictionary()

    @IBOutlet weak var Noleavesview: UIView!
    @IBOutlet weak var NoLeavesfoundview: UIImageView!
    @IBOutlet weak var Pendingtble: UITableView!
    
    @IBOutlet weak var PendingLeaves_AcceptView: UIView!
    @IBOutlet weak var PendingLeaves_RejectView: UIView!
    
    //RejectView
    
    
    @IBOutlet weak var RejectviewCancel: UIView!
    
    @IBOutlet weak var RejectviewReject: UIView!
    
    @IBOutlet weak var RejectRemarkTextview: UITextView!
    
    
    
    var marLeavesData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PendingLeaves_AcceptView.isHidden = true
        PendingLeaves_RejectView.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.CancelAction(sender:)))
        self.RejectviewCancel.addGestureRecognizer(gesture)

        let Rejctgesture = UITapGestureRecognizer(target: self, action:  #selector(self.RejectAction(sender:)))
        self.RejectviewReject.addGestureRecognizer(Rejctgesture)
        
        
        Noleavesview.isHidden = true
               let defaults = UserDefaults.standard
                      RetrivedcustId = defaults.integer(forKey: "custId")
                      print("RetrivedcustId----",RetrivedcustId)
                      RetrivedempId = defaults.integer(forKey: "empId")
                      print("RetrivedempId----",RetrivedempId)
               
        Pendingtble.register(UINib(nibName: "PendingLeavescellTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingLeavescellTableViewCell")
                Pendingtble.register(UINib(nibName: "PendingHeadercell", bundle: nil), forCellReuseIdentifier: "PendingHeadercell")
 
        PendingLeavesAPI()

        // Do any additional setup after loading the view.
    }
    
    @objc func CancelAction(sender : UITapGestureRecognizer) {
        // Do what you want
        PendingLeaves_RejectView.isHidden = true
    }
    
    
    func PendingLeavesAPI(){
        print("Leave Proceed------")
        let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any] as [String : Any]
       
        let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmpPendingLeaveByCustIdAndEmpId")!
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
                        
                        let empnamestr = statusDic["empName"] as? String
                        print("suresh empname",empnamestr as Any)
                        
                         self.Pendingtble.isHidden = false
                        
                       
                        
                     }
                    else
                    {
 
                      print("Not found pending Leaves")
                        self.Noleavesview.isHidden = false
                     }
                                 
                    
                     self.mDictAttendanceData = NSMutableDictionary()
                    if responseJSON != nil{
                        self.mDictAttendanceData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        if let temp = self.mDictAttendanceData.value(forKey: "empLeaveDtoList") as? NSArray{
                            self.marLeavesData = temp.mutableCopy() as! NSMutableArray
                        }
                        
                      

                    }
                   self.Pendingtble.reloadData()
//                }
                }
            }
        }
        task.resume()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.marLeavesData.count
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = marLeavesData.object(at: section) as? NSDictionary
        if (dict?.value(forKey: "open") as? String) != nil{
            return 1
        }
           return 0
       }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "PendingHeadercell") as! PendingHeadercell
        let dict = marLeavesData.object(at: section) as? NSDictionary
        if let temp = dict?.value(forKey: "empName") as? String{
            if let Counttemp = dict?.value(forKey: "empLeaveDaysCount") as? NSInteger{
                print("Counttemp....",Counttemp)
                if let empLeaveId = dict?.value(forKey: "empLeaveId") as? NSInteger{
                print("empLeaveId....",empLeaveId)
                    
                    ConvertEmpLeaveId = String(empLeaveId)
                
                //Iteger to string convertion
                 Convertdaycount = String(Counttemp)
                
                var Daycount = "\(Convertdaycount) \("day")"
            headerCell.empNameLbl.text = temp
                headerCell.CountLbl.text = Daycount
            headerCell.Btnclk.addTarget(self, action: #selector(self.pressButton(sender:)), for: .touchUpInside)
            headerCell.Btnclk.tag = section
            headerCell.img.layer.borderWidth = 1
            headerCell.img.layer.masksToBounds = false
            headerCell.img.layer.borderColor = UIColor.clear.cgColor
            headerCell.img.layer.cornerRadius = headerCell.img.frame.width/2
            headerCell.img.clipsToBounds = true

        }
        }
        }
        
        return headerCell
    }
    
       func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
           return 40
       }
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let PendingLeavescellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PendingLeavescellTableViewCell", for: indexPath) as! PendingLeavescellTableViewCell
           let dicShiftDetails = marLeavesData.object(at: indexPath.section) as? NSDictionary
//           let predict = NSPredicate(format: "leaveType = %@", strShiftName)
//           let arrFilter = arrAbsentEmp.filtered(using: predict) as NSArray
//           if arrFilter.count > 0{
//               let dictEmp = arrFilter.object(at: indexPath.row) as? NSDictionary
               PendingLeavescellTableViewCell.FromLbl.text = dicShiftDetails?.value(forKey: "empLeaveFrom") as? String
               PendingLeavescellTableViewCell.ToLbl.text = dicShiftDetails?.value(forKey: "empLeaveTo") as? String
        PendingLeavescellTableViewCell.RemarksLbl.text = dicShiftDetails?.value(forKey: "empLeaveRemarks") as? String
        PendingLeavescellTableViewCell.LeaveTypeLbl.text = dicShiftDetails?.value(forKey: "leaveType") as? String
        
        //click on Reject
        let Rejecttap = UITapGestureRecognizer(target: self, action: #selector(PendingLeavesVC.RejecttapFunction))
        PendingLeavescellTableViewCell.RejctLbl.isUserInteractionEnabled = true
        PendingLeavescellTableViewCell.RejctLbl.addGestureRecognizer(Rejecttap)
        
        let Accepttap = UITapGestureRecognizer(target: self, action: #selector(PendingLeavesVC.AccepttapFunction))
        PendingLeavescellTableViewCell.AcceptLbl.isUserInteractionEnabled = true
        PendingLeavescellTableViewCell.AcceptLbl.addGestureRecognizer(Accepttap)
        
        
        
        
//           }
           return PendingLeavescellTableViewCell
       }
    @objc func pressButton(sender: UIButton) {
        let dict = marLeavesData.object(at:sender.tag ) as? NSDictionary
        let mdic = dict?.mutableCopy() as! NSMutableDictionary
        if (dict?.value(forKey: "open")) != nil{
            mdic.removeObject(forKey: "open")
        }else{
            mdic.setValue("yes", forKey: "open")
        }
        
        
        
        
        marLeavesData.replaceObject(at: sender.tag, with: mdic)
        let ip = IndexPath(row: 1, section: sender.tag)
        Pendingtble.reloadData()
//        Pendingtble.reloadRows(at: [ip], with: .fade)
    }

    
    @objc
    func RejecttapFunction(sender:UITapGestureRecognizer) {
        PendingLeaves_RejectView.isHidden = false
        print("RejecttapFunction tap working")

        
    }
    @objc
    func AccepttapFunction(sender:UITapGestureRecognizer) {
        PendingLeaves_AcceptView.isHidden = false
        print("AccepttapFunction tap working")

        
    }
    
    
    @IBAction func PendingLeavesCancelBtn(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
   
    
    @objc func RejectAction(sender : UITapGestureRecognizer) {
        // Do what you want
     print("Retrived empLeaveId",ConvertEmpLeaveId)
        
        let parameters = ["empLeaveId": Convertdaycount as Any,"empId": RetrivedempId as Any,"empLeaveRejectionRemarks":RejectRemarkTextview.text as Any] as [String : Any]
               
                let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/reject")!
        
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
                        print("Reject Leaves Json Response",responseJSON)
                        DispatchQueue.main.async
                            {
                                
                        }
                    }
                }
                task.resume()
            }
        
        

    
    
    @IBAction func PendingCancelBtn_Acceptview(_ sender: Any) {
        PendingLeaves_AcceptView.isHidden = true
        
    }
    
    @IBAction func ProceedBtn_Aceeptview(_ sender: Any) {
    }
    
}
    

