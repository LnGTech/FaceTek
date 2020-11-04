//
//  LatecomersVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LatecomersVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var RetrivedcustId = Int()
       var RetrivedempId = Int()
       let Datepicker = UIDatePicker()
       var ConvertedCurrentDatestr = NSString()
       var mDictAttendanceData = NSMutableDictionary()



       @IBOutlet weak var EarlyLeaverstbl: UITableView!
       
       
       @IBOutlet weak var DatetxtFld: UITextField!
         @IBOutlet weak var Dateview: UIView!
         @IBOutlet weak var TitleLbl: UILabel!
         
         @IBOutlet weak var NoLeavesView: UIView!
         @IBOutlet weak var Noleavesimg: UIImageView!
         @IBOutlet weak var NoLeavesLbl: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 0.9680276113)
		view.addSubview(statusBarView)

        let defaults = UserDefaults.standard
                      RetrivedcustId = defaults.integer(forKey: "custId")
                      print("RetrivedcustId----",RetrivedcustId)
                      RetrivedempId = defaults.integer(forKey: "empId")
                      print("RetrivedempId----",RetrivedempId)
 
            EarlyLeaverstbl.register(UINib(nibName: "AbsenttblCell", bundle: nil), forCellReuseIdentifier: "AbsenttblCell")
                    EarlyLeaverstbl.register(UINib(nibName: "AbsentHeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
             NoLeavesView.isHidden = true
              DatetxtFld.delegate = self
                   Dateview.layer.borderWidth = 1
                   //Dateview.layer.borderColor = UIColor.blue.cgColor
                   Dateview.layer.borderColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
                    Datepicker.datePickerMode = UIDatePicker.Mode.date
                   DatetxtFld.inputView = Datepicker

                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MMM-yyyy"
                    DatetxtFld.text = formatter.string(from: Datepicker.date)
                             
                               //var ConvertedCurrentDatestr = ""
                   ConvertedCurrentDatestr = formattedDateFromString(dateString: DatetxtFld.text!, withFormat: "yyyy-MM-dd")! as NSString
                   
                print("ConvertedCurrentDatestr---",ConvertedCurrentDatestr)
                   
            LateComersAPI()
                    self.view.endEditing(true)
                   Datepicker.datePickerMode = .date
                   //Datepicker.inputView = Datepicker
                   
                   DatetxtFld.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)

    }
    
    
    
    @objc func FromDatesetDatePicker() {
                //Format Date
               // DatetxtFld.datePickerMode = .date
                
                //ToolBar
                let toolbar = UIToolbar();
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                
                toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                
                DatetxtFld.inputAccessoryView = toolbar
                DatetxtFld.inputView = Datepicker
                

                
        //        Totxt.inputAccessoryView = toolbar
        //        Totxt.inputView = datePicker
        //
                
            }
            
            @objc func doneDatePicker(){
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-yyyy"
                DatetxtFld.text = formatter.string(from: Datepicker.date)
              
                //var ConvertedDatestr = ""
                ConvertedCurrentDatestr = formattedDateFromString(dateString: DatetxtFld.text!, withFormat: "yyyy-MM-dd")! as NSString

                       print("ConvertedCurrentDatestr---",ConvertedCurrentDatestr)
                
                LateComersAPI()
                
                self.view.endEditing(true)
            }
                        @objc func cancelDatePicker(){
                self.view.endEditing(true)
            }
        
        func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = format
                return outputFormatter.string(from: date)
            }
            return nil
        }
    
    
    func LateComersAPI(){
        //        "empId":"8",
        //        "empPresistedFaceId":"abc123",
        //        "empDeviceName":"Oppo",
        //        "empModelNumber":"A7",
        //        "empAndriodVersion":"9",
        //        "employeePic":" base64 converted String "
        let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any, "dates": ConvertedCurrentDatestr as Any] as [String : Any]
        //    var RetrivedcustId : Int = 0r
        //    let parameters = ["custId": RetrivedcustId] as [String : Any]
        //create the url with URL
        //let url = URL(string: "https://www.webliststore.biz/app_api/api/authenticate_user")! //change the url
        //let url: NSURL = NSURL(string:"http://122.166.152.106:8081/attnd-api-gateway-service/api/customer/employee/setup/updateEmpAppStatus ")!
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/employee/setup/getlateComersDetails"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
        //let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/setup/getlateComersDetails")!
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
                print("Absent Json Response",responseJSON)
                DispatchQueue.main.async {
                    
                    
                    
                    if let lateComersShiftDetails = responseJSON["lateComersShiftDetails"] as? [Any], !lateComersShiftDetails.isEmpty {
                        print("lateComersShiftDetails----",lateComersShiftDetails)
                        
                        self.NoLeavesView.isHidden = true

                        self.EarlyLeaverstbl.isHidden = false
                        print("Print empty values----")
                    }
                    else
                    {
                        self.NoLeavesView.isHidden = false

                        self.EarlyLeaverstbl.isHidden = true

                        
                    }
                    
    if let absentShiftDetailsid = responseJSON["lateComersShiftDetails"] as? NSString {
                                        
    if let absentEmpShiftDetails = responseJSON["lateComersEmpShiftDetails"] as? NSString {
     print("null values printed.....")
self.NoLeavesView.isHidden = false
self.EarlyLeaverstbl.isHidden = true
                                        }
                                        else
                                        {
                                            
                    print("Normal values printed....")
                                        }

                    }
                    self.mDictAttendanceData = NSMutableDictionary()
                    if responseJSON != nil{
                        self.mDictAttendanceData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                   self.EarlyLeaverstbl.reloadData()
                }
            }
        }
        task.resume()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if mDictAttendanceData.allKeys.count > 0{
            if let temp = mDictAttendanceData.value(forKey: "lateComersShiftDetails") as? NSArray{
                return temp.count
            }
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  mDictAttendanceData.allKeys.count > 0{
            var arrSectionsData = NSArray()
            if let temp = mDictAttendanceData.value(forKey: "lateComersShiftDetails") as? NSArray{
                arrSectionsData = temp
            }
            if arrSectionsData.count > 0{
                let dict = arrSectionsData.object(at: section) as? NSDictionary
                if let temp = dict?.value(forKey: "totalCount") as? Int{
                    return temp
                }
                return 0
            }
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! AbsentHeaderCell
        var arrSectionsData = NSArray()
        if let temp = mDictAttendanceData.value(forKey: "lateComersShiftDetails") as? NSArray{
            arrSectionsData = temp
        }
        if arrSectionsData.count > 0{
            let dict = arrSectionsData.object(at: section) as? NSDictionary
            if let temp = dict?.value(forKey: "totalCount") as? Int{
                headerCell.lblCount.text = "Count: \(temp)"
            }
            var strTimings = ""
            if let shiftStarttime = dict?.value(forKey: "shiftStart") as? String{
                strTimings = shiftStarttime
            }
            if let shiftEndtime = dict?.value(forKey: "shiftEnd") as? String{
                //strTimings = strTimings + shiftEndtime
                strTimings = "\(strTimings)  -  \(shiftEndtime)"
                
            }
             headerCell.lblTimings.text = strTimings
            if let temp = dict?.value(forKey: "shiftName") as? String{
                 headerCell.lblShiftName.text = temp
            }
           
        }
       
        return headerCell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let AbsenttblCell = tableView.dequeueReusableCell(withIdentifier: "AbsenttblCell", for: indexPath) as! AbsenttblCell
         let arrAbsentEmp =  mDictAttendanceData.value(forKey: "lateComersEmpShiftDetails") as! NSArray
        let arrShiftDetails =  mDictAttendanceData.value(forKey: "lateComersShiftDetails") as! NSArray
        let dicShiftDetails = arrShiftDetails.object(at: indexPath.section) as? NSDictionary
        var strShiftName = ""
        if let temp = dicShiftDetails?.value(forKey: "shiftName") as? String{
            strShiftName = temp
        }
        let predict = NSPredicate(format: "shiftName = %@", strShiftName)
        let arrFilter = arrAbsentEmp.filtered(using: predict) as NSArray
        if arrFilter.count > 0{
            let dictEmp = arrFilter.object(at: indexPath.row) as? NSDictionary
            AbsenttblCell.NameLbl.text = dictEmp?.value(forKey: "empName") as? String
            AbsenttblCell.ShiftLbl.text = dictEmp?.value(forKey: "attndInTime") as? String
        }
        return AbsenttblCell
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        
          self.presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
