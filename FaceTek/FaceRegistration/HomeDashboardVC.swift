//
//  HomeDashboardVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/6/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class HomeDashboardVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    
    
    
    
    
    
    @IBOutlet weak var CompanyNameLbl: UILabel!
    
    @IBOutlet weak var UserNameLbl: UILabel!
    
    
    @IBOutlet weak var MobilenumberLbl: UILabel!
    
    
    var button: HamburgerButton! = nil
    
    @IBOutlet weak var OfficeInLbl: UILabel!
    
    
    
    @IBOutlet weak var PendingLbl: UILabel!
    
    @IBOutlet weak var OfficeOutLbl: UILabel!
    
    
    
    @IBOutlet weak var LeaveFromLbl: UILabel!
    
    
    @IBOutlet weak var LeaveToLbl: UILabel!
    
    @IBOutlet weak var LeavePendingLbl: UILabel!
    
    @IBOutlet weak var menu: UIView!
    
    
    var customView = UIView()
    var label = UILabel()
    var CancelBtnButton = UIButton()
    var ProceedButton = UIButton()

    var imageview = UIImageView()

    var empLeaveId : Int = 0



    
    
    @IBOutlet weak var ContactUsView: UIView!
    
    @IBOutlet weak var ContactusText: UITextView!
    
    @IBOutlet weak var HomeDashboatdtbl: UITableView!
    
    var isMenuVisible:Bool!
    
    
    
    var IntimedateString = String()

    var empAttndInDateTime = String()
    var empAttndOutDateTime = String()
    var RetrivedMobileNumber = String()
    var Employeenamestr = String()
    
    var brNamestr = String()

    var name = String()
    
    var Facename = String()




    
    
    @IBOutlet weak var ManagerView: UIView!
    
    @IBOutlet weak var LeaveApplicationPendingview: UIView!
    

    
    @IBOutlet weak var PendingLeavesview: UIView!
    @IBOutlet weak var Absentview: UIView!
    
    @IBOutlet weak var Leavesview: UIView!
    
    @IBOutlet weak var Latecomersview: UIView!
    

    @IBOutlet weak var EarlyLeaversview: UIView!
    //Manager Dashboard Label Outlets
    
    
    @IBOutlet weak var AbsentLbl: UILabel!
    
    @IBOutlet weak var Absentimg: UIImageView!
    
    @IBOutlet weak var LeavesLbl: UILabel!
    
    @IBOutlet weak var Leavesimg: UIImageView!
    
    @IBOutlet weak var LateComersLbl: UILabel!
    
    @IBOutlet weak var LateComersimg: UIImageView!
    @IBOutlet weak var EarlyLeaversLbl: UILabel!
    
    @IBOutlet weak var EarlyLeaversimg: UIImageView!
    
    @IBOutlet weak var LeaveApplicationPendingLbl: UILabel!
    
    
    @IBOutlet weak var LeavePendingimg: UIImageView!
    
   
    
    @IBOutlet weak var OfficeInBtn: UIButton!
    
    
    @IBOutlet weak var OfficeOutBtn: UIButton!
    
    
    @IBOutlet weak var LeaveStatusBtn: UIButton!
    
    
    
    
    var RetrivedcustId = Int()
    var RetrivedempId = Int()
    
    
//    var HomeDashboardNavigationMenuArray = ["Holiday Calender","FAQ","Contact Us"]
    var HomeDashboardNavigationMenuArray = ["Holiday Calender","FAQ","Contact Us"]

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size:14)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

        
        

        LeaveStatusBtn.isHidden = true
//        self.LeaveStatusBtn.setImage(UIImage(named: "cancel.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
//
//
         
        let defaults = UserDefaults.standard
         if let RetrivedempPresistedFaceId = defaults.string(forKey: "empPresistedFaceId") {
             print(" Retrived empPresistedFaceId----",RetrivedempPresistedFaceId)
             
            defaults.set(self.RetrivedempId, forKey: "RetrivedFaceid")

        
        }
        
        
        
        defaults.set(self.RetrivedempId, forKey: "RetrivedFaceid")
        
        
        
//        if let Facename = defaults.string(forKey: "Facename") {
//             print(" Retrived Facename----",Facename)
//
//            defaults.set(self.Facename, forKey: "Facename")
//
//
//        }
//
//        defaults.set(self.Facename, forKey: "Facename")

       
        menu.backgroundColor = .white

               menu.layer.shadowOffset = .zero
               menu.layer.shadowColor = UIColor.gray.cgColor
               menu.layer.shadowRadius = 0
               menu.layer.shadowOpacity = 1
               menu.layer.shadowPath = UIBezierPath(rect: menu.bounds).cgPath
               
               
               let shadowPath = UIBezierPath(rect: view.bounds)
               menu.layer.masksToBounds = false
               menu.layer.shadowColor = UIColor.gray.cgColor
               menu.layer.shadowOffset = CGSize(width: 0, height: 0.5)
               menu.layer.shadowOpacity = 0.2
               menu.layer.shadowPath = shadowPath.cgPath
               
        
        
        
        //Manager view screen design
        
        self.Absentview.layer.masksToBounds = false
               self.Absentview.layer.cornerRadius = 1
               self.Absentview.layer.shadowColor = UIColor.black.cgColor
               self.Absentview.layer.shadowPath = UIBezierPath(roundedRect: self.Absentview.bounds, cornerRadius: self.Absentview.layer.cornerRadius).cgPath
               self.Absentview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
               self.Absentview.layer.shadowOpacity = 0.1
               self.Absentview.layer.shadowRadius = 1.0
        
        
        self.Leavesview.layer.masksToBounds = false
               self.Leavesview.layer.cornerRadius = 1
               self.Leavesview.layer.shadowColor = UIColor.black.cgColor
               self.Leavesview.layer.shadowPath = UIBezierPath(roundedRect: self.Leavesview.bounds, cornerRadius: self.Leavesview.layer.cornerRadius).cgPath
               self.Leavesview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
               self.Leavesview.layer.shadowOpacity = 0.1
               self.Leavesview.layer.shadowRadius = 1.0
        
        
        self.Latecomersview.layer.masksToBounds = false
                      self.Latecomersview.layer.cornerRadius = 1
                      self.Latecomersview.layer.shadowColor = UIColor.black.cgColor
                      self.Latecomersview.layer.shadowPath = UIBezierPath(roundedRect: self.Latecomersview.bounds, cornerRadius: self.Latecomersview.layer.cornerRadius).cgPath
                      self.Latecomersview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                      self.Latecomersview.layer.shadowOpacity = 0.1
                      self.Latecomersview.layer.shadowRadius = 1.0
               
        
        self.EarlyLeaversview.layer.masksToBounds = false
                             self.EarlyLeaversview.layer.cornerRadius = 1
                             self.EarlyLeaversview.layer.shadowColor = UIColor.black.cgColor
                             self.EarlyLeaversview.layer.shadowPath = UIBezierPath(roundedRect: self.EarlyLeaversview.bounds, cornerRadius: self.EarlyLeaversview.layer.cornerRadius).cgPath
                             self.EarlyLeaversview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                             self.EarlyLeaversview.layer.shadowOpacity = 0.1
                             self.EarlyLeaversview.layer.shadowRadius = 1.0
                      
        
        self.LeaveApplicationPendingview.layer.masksToBounds = false
                   self.LeaveApplicationPendingview.layer.cornerRadius = 1
                   self.LeaveApplicationPendingview.layer.shadowColor = UIColor.black.cgColor
                   self.LeaveApplicationPendingview.layer.shadowPath = UIBezierPath(roundedRect: self.LeaveApplicationPendingview.bounds, cornerRadius: self.LeaveApplicationPendingview.layer.cornerRadius).cgPath
                   self.LeaveApplicationPendingview.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                   self.LeaveApplicationPendingview.layer.shadowOpacity = 0.1
                   self.LeaveApplicationPendingview.layer.shadowRadius = 1.0
        
        
        
        
        
        UserDefaults.standard.set(self.IntimedateString, forKey: "LuxandIntime") //String
                                               
      
        customActivityIndicatory(self.view, startAnimate: false)

        
        LeaveApplicationPendingview.isHidden = true
        ManagerView.isHidden = true
        
        
        //let defaults = UserDefaults.standard
        RetrivedcustId = defaults.integer(forKey: "custId")
        print("RetrivedcustId----",RetrivedcustId)
        RetrivedempId = defaults.integer(forKey: "empId")
        print("RetrivedempId----",RetrivedempId)
        
        
        
        
        
        isMenuVisible = true
        menu.isHidden = true
        ContactUsView.isHidden = true
        ContactusText.isHidden = true

        OfficeOutLbl.layer.cornerRadius = 5
        OfficeOutLbl.layer.borderWidth = 2
        OfficeOutLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        
        
        
        HomeDashboatdtbl.register(UINib(nibName: "LeaveNavigationcell", bundle: nil), forCellReuseIdentifier: "LeaveNavigationcell")


        
//        RetrivedMobileNumber = defaults.string(forKey: "Mobilenum")!
//        print("RetrivedMobileNumber-----",RetrivedMobileNumber)
//        
        
        RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
        print("RetrivedMobileNumber-----",RetrivedMobileNumber)
        MobilenumberLbl.text = RetrivedMobileNumber
        Employeenamestr = defaults.string(forKey: "employeeName")!
        UserNameLbl.text = Employeenamestr
        brNamestr = defaults.string(forKey: "brName")!
        print("brNamestr-----",brNamestr)
        CompanyNameLbl.text = brNamestr
        self.button = HamburgerButton(frame: CGRect(x: 5, y: 20, width: 45, height: 45))
        self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
        self.view.addSubview(button)
        EmployeeDashboardDetails()
        
        //image circle code
        Absentimg.layer.borderWidth = 1
        Absentimg.layer.masksToBounds = false
        Absentimg.layer.borderColor = UIColor.clear.cgColor
        Absentimg.layer.cornerRadius = Absentimg.frame.height/2
        Absentimg.clipsToBounds = true
        
        
        Absentimg.tintColor = UIColor.black
        Leavesimg.layer.borderWidth = 1
        Leavesimg.layer.masksToBounds = false
        Leavesimg.layer.borderColor = UIColor.clear.cgColor
        Leavesimg.layer.cornerRadius = Leavesimg.frame.height/2
        Leavesimg.clipsToBounds = true
        
        
        LateComersimg.layer.borderWidth = 1
        LateComersimg.layer.masksToBounds = false
        LateComersimg.layer.borderColor = UIColor.clear.cgColor
        LateComersimg.layer.cornerRadius = LateComersimg.frame.height/2
        LateComersimg.clipsToBounds = true

        EarlyLeaversimg.layer.borderWidth = 1
        EarlyLeaversimg.layer.masksToBounds = false
        EarlyLeaversimg.layer.borderColor = UIColor.clear.cgColor
        EarlyLeaversimg.layer.cornerRadius = EarlyLeaversimg.frame.height/2
        EarlyLeaversimg.clipsToBounds = true


        LeavePendingimg.layer.borderWidth = 1
        LeavePendingimg.layer.masksToBounds = false
        LeavePendingimg.layer.borderColor = UIColor.clear.cgColor
        LeavePendingimg.layer.cornerRadius = LeavePendingimg.frame.height/2
        LeavePendingimg.clipsToBounds = true


        
        
        //Manager view Absent , Leaves , Latecomers and EarlyLeavers
        
       let Absentviewtap = UITapGestureRecognizer(target: self, action: #selector(self.AbsenttouchTapped(_:)))
       self.Absentview.addGestureRecognizer(Absentviewtap)
        
        
        let Leavesviewtap = UITapGestureRecognizer(target: self, action: #selector(self.LeavestouchTapped(_:)))
              self.Leavesview.addGestureRecognizer(Leavesviewtap)
               
        
        
        
        let LatecomersviewTap = UITapGestureRecognizer(target: self, action: #selector(self.LatecomersTapped(_:)))
           self.Latecomersview.addGestureRecognizer(LatecomersviewTap)
        
        
        let EarlyLeaversviewTap = UITapGestureRecognizer(target: self, action: #selector(self.EarlyLeaversTapped(_:)))
                  self.EarlyLeaversview.addGestureRecognizer(EarlyLeaversviewTap)
        
        
        let PendingLeavesTap = UITapGestureRecognizer(target: self, action: #selector(self.PendingLeavesTap(_:)))
                        self.PendingLeavesview.addGestureRecognizer(PendingLeavesTap)
              
        
        // Do any additional setup after loading the view.
    }
    
    
   @objc func AbsenttouchTapped(_ sender: UITapGestureRecognizer) {
    print("Absent view is calling.......")
    
    
//    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
//    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
//
    
    let AbsentVC = storyboard?.instantiateViewController(withIdentifier: "AbsentVC") as! AbsentVC

    
//    //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
//
//    var Managerstr = ""
//
//ManagerVC.Managerstr = "Absent Details"
//
          
           
            self.present(AbsentVC, animated:true, completion:nil)

    }
    
    
    @objc func LeavestouchTapped(_ sender: UITapGestureRecognizer) {
       print("Absent view is calling.......")
       
       
      
       //    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
       //    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
       //
           
           let ManagerLeavesVC = storyboard?.instantiateViewController(withIdentifier: "ManagerLeavesVC") as! ManagerLeavesVC
//
//
//           //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
//
//           var Managerstr = ""
//
//       ManagerVC.Managerstr = "Leave Details"
//
                 
                  
                   self.present(ManagerLeavesVC, animated:true, completion:nil)

       }
    
    
    @objc func LatecomersTapped(_ sender: UITapGestureRecognizer) {
       print("Absent view is calling.......")
       
       
      
       //    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
       //    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
       //
           
           let LatecomersVC = storyboard?.instantiateViewController(withIdentifier: "LatecomersVC") as! LatecomersVC

           
           //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
           
//           var Managerstr = ""
//           
//       ManagerVC.Managerstr = "Late comers"
//           
                 
                  
                   self.present(LatecomersVC, animated:true, completion:nil)

       }
    
    
    
    @objc func EarlyLeaversTapped(_ sender: UITapGestureRecognizer) {
     print("Absent view is calling.......")
     
     
    
     //    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
     //    let ManagerVC = storyBoard.instantiateViewController(withIdentifier: "ManagerVC") as! ManagerVC
     //
         
         let EarlyLeaversVC = storyboard?.instantiateViewController(withIdentifier: "EarlyLeaversVC") as! EarlyLeaversVC

         
         //self.navigationController?.pushViewController(FaceRegistrationVC, animated:false)
         
//         var Managerstr = ""
//
//     ManagerVC.Managerstr = "Early Leavers"
//
               
                
                 self.present(EarlyLeaversVC, animated:true, completion:nil)

     }
    
    
    
     @objc func PendingLeavesTap(_ sender: UITapGestureRecognizer) {
        print("Absent view is calling.......")
        
    
        
        let PendingLeavesVC = storyboard?.instantiateViewController(withIdentifier: "PendingLeavesVC") as! PendingLeavesVC
  
                self.present(PendingLeavesVC, animated:true, completion:nil)

        }
    
    override var preferredStatusBarStyle : UIStatusBarStyle  {
        return .lightContent
    }
    
    
    
    
    
    @objc func toggle(_ sender: AnyObject!) {
        
        self.toggleComparision()
        menu.isHidden = false

        self.button.showsMenu = !self.button.showsMenu
    }
    //Menu code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        isMenuVisible = false;
        self.toggleComparision()
    }
    
    func toggleComparision()
    {
        if (isMenuVisible)
        {
            
            UIView.transition(with: menu, duration: 0.6, options: .beginFromCurrentState, animations: {
                self.menu.frame = CGRect(x: 0, y: 70, width: 300, height: 700)
                self.isMenuVisible = false;
                self.menu.isHidden = false
                
                self.tabBarController?.tabBar.isHidden = true

                
            })
        }
        else
        {
            
            UIView.animate(withDuration: 0.6,
                           delay: 0.1,
                           options: UIView.AnimationOptions.beginFromCurrentState,
                           animations: { () -> Void in
                            self.menu.frame = CGRect(x: -self.view.frame.size.width, y: 70, width: 300, height: 700)
                            self.menu.isHidden = true
            }, completion: { (finished) -> Void in
                self.isMenuVisible = true;
                self.menu.isHidden = true
                
                self.tabBarController?.tabBar.isHidden = false

                
            })
            
            
        }
    }
    
    
    func EmployeeDashboardDetails()
    {
        let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
        
        
        //    var RetrivedcustId : Int = 0r
        //
        //
        //
        //    let parameters = ["custId": RetrivedcustId] as [String : Any]
        //
        
        //create the url with URL
        //let url = URL(string: "https://www.webliststore.biz/app_api/api/authenticate_user")! //change the url
        
        
        //let url: NSURL = NSURL(string:"http://122.166.152.106:8081/attnd-api-gateway-service/api/customer/employee/setup/updateEmpAppStatus ")!
        
        
        
//        let url: NSURL = NSURL(string:"http://122.166.152.106:8081/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeSummary")!
        
        
        
         let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
        
        
        
        
        //http://122.166.152.106:8080/serenityuat/inmatesignup/validateMobileNo
        
        customActivityIndicatory(self.view, startAnimate: true)

        
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
                print("Employee ---- Json Response",responseJSON)
                
                //var empIsSupervisor_Manager: Bool?
                var empIsSupervisor_Manager: Int
                
                empIsSupervisor_Manager = (responseJSON["empIsSupervisor_Manager"] as? NSInteger)!
                print("empIsSupervisor_Manager ------------",empIsSupervisor_Manager as Any)

                
                
                
                
                
                
                let ItemsDict = responseJSON["empAttendanceStatus"] as! NSDictionary
                
                
                
                
                //Employee Upcoming Leaves and Office In ,Office Out
                let empLeaveData = responseJSON["empLeaveData"]! as! NSDictionary
                print("empLeaveData------",empLeaveData)
                
                let statusDic = empLeaveData["status"]! as! NSDictionary
                print("status------",statusDic)
                let empcode = statusDic["code"] as? NSInteger
                print("empcode-----",empcode as Any)
                
                
                
                let empSummary = responseJSON["empSummary"]! as! NSDictionary
                print("empSummary------",empSummary)
                
                let empSummarystatusDic = empSummary["status"]! as! NSDictionary
                print("empSummarystatusDic------",empSummarystatusDic)
                
                
                
                let empSummarycode = empSummarystatusDic["code"]! as! NSInteger
                print("empSummarycode------",empSummarycode)
                
                                DispatchQueue.main.async {
                                    
                                    
                                    
                                    
                                    
                                    //Manager screen calling code
                                    //------******---------------------********--------//
                                    var empIsSupervisor_Manager_flag : Int = 1

                                    
                                    
                                    if (empIsSupervisor_Manager_flag == empIsSupervisor_Manager)
                                    {
                                        
                                        self.ManagerView.isHidden = false
                                        
                                         self.LeaveApplicationPendingview.isHidden = false
                                        print("Manager screen----")
                                        
                                        
                                         if (empSummarycode == 200)
                                                                            {
                                        
                                                                                let empsummaryDetailsDic = empSummary["summaryDetails"]! as! NSDictionary
                                                                                print("empsummaryDetailsDic------",empsummaryDetailsDic)
                                        
                                        
                                        
                                                                                let absent = empsummaryDetailsDic["absent"]! as! NSInteger
                                                                                print("absent------",absent)
                                        
                                        
                                                                                let absentstrValue = String(absent)
                                        
                                        
                                        
                                                                                self.AbsentLbl.text = absentstrValue
                                        
                                                                                let totalAppLeave = empsummaryDetailsDic["totalAppLeave"]! as! NSInteger
                                                                                print("totalAppLeave------",totalAppLeave)
                                        
                                                                                let LeavesstrValue = String(totalAppLeave)
                                        
                                                                                self.LeavesLbl.text = LeavesstrValue
                                        
                                        
                                                                                let totalLateComers = empsummaryDetailsDic["totalLateComers"]! as! NSInteger
                                                                                print("totalLateComers------",totalLateComers)
                                                                                let totalLateComersstrValue = String(totalLateComers)
                                                                                self.LateComersLbl.text = totalLateComersstrValue
                                        
                                        
                                                                                let totalEarlyLeavers = empsummaryDetailsDic["totalEarlyLeavers"]! as! NSInteger
                                                                                print("totalEarlyLeavers------",totalEarlyLeavers)
                                                                                let totalEarlyLeaverssstrValue = String(totalEarlyLeavers)
                                                                                self.EarlyLeaversLbl.text = totalEarlyLeaverssstrValue
                                        
                                        
                                                                                let totalPendingLeave = empsummaryDetailsDic["totalPendingLeave"]! as! NSInteger
                                                                                print("totalPendingLeave------",totalPendingLeave)
                                        
                                                                                 let totalPendingLeavesstrValue = String(totalPendingLeave)
                                        
                                                                                self.LeaveApplicationPendingLbl.text = totalPendingLeavesstrValue
                                        
                                        
                                        
                                                                            }
                                        
                                        
                                    }
                                    
                                    
                                    //------******---------------------********--------//
                                   
                                    
                                    
//                                    if (empIsSupervisor_Manager == false)
//                                    {
//
//

                                    if(empcode == 200)
                                    {



                                        let Empdata = empLeaveData["data"]! as! NSDictionary
                                        print("Empdata------",Empdata)


                                        
                                        self.empLeaveId = (Empdata["empLeaveId"] as? NSInteger)!
                                                                                  print("empLeaveId ------------",self.empLeaveId as Any)


                                        var empLeaveFrom = (Empdata["empLeaveFrom"] as? String)!
                                        print("empLeaveFrom-------",empLeaveFrom)



                                        var empLeaveTo = (Empdata["empLeaveTo"] as? String)!
                                        print("empLeaveTo-------",empLeaveTo)

                                        
                                        
                                        
                                        var empLeaveStatus = (Empdata["empLeaveStatus"] as? String)!
                                                                               print("empLeaveStatus-------",empLeaveStatus)

                                        
                                        
                                        
                                        
                                        
                                        self.LeaveFromLbl.text = empLeaveFrom
                                        self.LeaveToLbl.text = empLeaveTo
                                        
                                        
                                        var LeaveApproved = "App"
                                        
                                        var LeaveRejected = "Rej"

                                        
                                        
                                        if (empLeaveStatus == "")
                                        {
                                        
                                        
                                            
                                            self.LeaveStatusBtn.isHidden = false
                                                                                   
                                                
                                                                                   
                                                                                   self.LeaveStatusBtn.setImage(UIImage(named: "cancel.png")?.withRenderingMode(.alwaysOriginal), for: .normal)

                                        
                                        self.LeavePendingLbl.layer.cornerRadius = 2
                                                                                   self.LeavePendingLbl.layer.borderWidth = 1
                                                                                   self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                                                                   self.LeavePendingLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                                                                   self.LeavePendingLbl.text = "Pending"
                                        
                                            
                                        }
                                        
                                        
                                        else if (LeaveApproved == empLeaveStatus)
                                        {
                                            self.LeavePendingLbl.layer.cornerRadius = 2
                                                                    self.LeavePendingLbl.layer.borderWidth = 1
                                            self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 0.1368455306, green: 0.5300007931, blue: 0.2386429882, alpha: 1)
                                            self.LeavePendingLbl.textColor = #colorLiteral(red: 0.1368455306, green: 0.5300007931, blue: 0.2386429882, alpha: 1)


                                            self.LeavePendingLbl.text = "Approval"
                                            
                                            self.LeaveStatusBtn.isHidden = true
                                            
                                            
                                        }
//
                                       else if(LeaveRejected == empLeaveStatus)
                                        {
                                            
                                          self.LeaveStatusBtn.isHidden = true

                                            
                                            self.LeavePendingLbl.layer.cornerRadius = 2
                                                                                                                             self.LeavePendingLbl.layer.borderWidth = 1
                                                                                                                             self.LeavePendingLbl.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                                                                                                                             self.LeavePendingLbl.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
                                                                                                                             self.LeavePendingLbl.text = "Rejected"
                                            
                                            
                                           
                                        }
                                        
                                        
                                       
                                            
                                        
                                        self.LeaveStatusBtn.addTarget(self, action: #selector(self.CancelLeave(_:)), for: .touchUpInside)
                                        
                                        
                                        
//
                                        
                                    }
                                        
                                        
                                        
                                        
                                    var empAttndDate = (ItemsDict["empAttndDate"] as? String)!
                                    print("empAttndDate ------------",empAttndDate as Any)

                                    self.empAttndInDateTime = (ItemsDict["empAttndInDateTime"] as? String)!
                                    print("empAttndInDateTime ------------",self.empAttndInDateTime as Any)



                                    self.empAttndOutDateTime = (ItemsDict["empAttndOutDateTime"] as? String)!
                                    print("empAttndOutDateTime ------------",self.empAttndOutDateTime as Any)




                                    //let string = "2017-01-27T18:36:36Z"

                                        if (self.empAttndInDateTime == "NA")
                                        {
                                            self.OfficeInLbl.text = self.empAttndInDateTime
                                            

                                            
                                            self.OfficeInLbl.layer.cornerRadius = 5
                                            self.OfficeInLbl.layer.borderWidth = 2
                                            self.OfficeInLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                            self.OfficeInLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                            self.OfficeInLbl.text = "Pending"
                                            self.OfficeInBtn.setImage(UIImage(named: "pending.png")?.withRenderingMode(.alwaysOriginal), for: .normal)


                                            
                                        }else
                                        {
                                        
                                    //InTime Code
                                                    let dateFormatter = DateFormatter()
                                                    let tempLocale = dateFormatter.locale // save locale temporarily
                                                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                                    let Intimedate = dateFormatter.date(from: self.empAttndInDateTime)!
                                                    //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

                                                    //dateFormatter.dateFormat = "yyyyy.MMMM.dd GGG hh:mm aaa"

                                            dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format

                                            
                                            
                                            
                                                    dateFormatter.locale = tempLocale // reset the locale
                                                    let IntimedateString = dateFormatter.string(from: Intimedate)
                                                    print("Intime EXACT_DATE : \(IntimedateString)")


                                    self.OfficeInLbl.text = IntimedateString
                                            //self.OfficeInLbl.text = "suresh"

                                       
                                            self.OfficeInLbl.layer.cornerRadius = 5
                                            self.OfficeInLbl.layer.borderWidth = 2
                                            //self.OfficeInLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)

                                            
                                            self.OfficeInLbl.layer.borderColor = UIColor.clear.cgColor
                                            self.OfficeInLbl.textColor = UIColor.darkGray
                                           
                                            
                                            self.OfficeInBtn.setImage(UIImage(named: "pass.png")?.withRenderingMode(.alwaysOriginal), for: .normal)

                                            
                                        
                                        }


                                    //Leave Detailes Data

//                                    var empLeaveFrom = (Empdata["empLeaveFrom"] as? String)!
//                                    print("empLeaveFrom ------------",empLeaveFrom as Any)
//                                    self.LeaveFromLbl.text = empLeaveFrom
//
//
//                                    var empLeaveTo = (Empdata["empLeaveTo"] as? String)!
//                                    print("empLeaveTo ------------",empLeaveTo as Any)

                                    //self.LeaveToLbl.text = empLeaveTo






                                    if (self.empAttndOutDateTime == "NA")
                                    {
                                        self.OfficeOutLbl.text = self.empAttndOutDateTime

                                        self.OfficeOutLbl.layer.cornerRadius = 5
                                        self.OfficeOutLbl.layer.borderWidth = 2
                                        self.OfficeOutLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                        
                                        self.OfficeOutLbl.textColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)

                                        self.OfficeOutLbl.text = "Pending"

                                        self.OfficeOutBtn.setImage(UIImage(named: "pending.png")?.withRenderingMode(.alwaysOriginal), for: .normal)

                                    }
                                    else

                                    {
                                        //Outtime Conversion Code
                                        let OuttimedateFormatter = DateFormatter()
                                        let tempLocale = OuttimedateFormatter.locale // save locale temporarily
                                        OuttimedateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                                        OuttimedateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                        let Outtimedate = OuttimedateFormatter.date(from: self.empAttndOutDateTime)!
                                        print("Outtimedate----",Outtimedate)
                                        
                                        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

                                        //OuttimedateFormatter.dateFormat = "yyyyy.MMMM.dd GGG hh:mm aaa"
                                        
                                        OuttimedateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"///this is what you want to convert format

                                        

                                        OuttimedateFormatter.locale = tempLocale // reset the locale
                                        let OuttimedateString = OuttimedateFormatter.string(from: Outtimedate)
                                        print(" Outtime EXACT_DATE : \(OuttimedateString)")

                                        
                                        self.OfficeOutLbl.text = OuttimedateString
                                        self.OfficeOutLbl.layer.cornerRadius = 5
                                        self.OfficeOutLbl.layer.borderWidth = 2
                                        //self.OfficeOutLbl.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
                                        
                                        self.OfficeOutLbl.layer.borderColor = UIColor.clear.cgColor
                                        self.OfficeOutLbl.textColor = UIColor.darkGray

                                        
                                        
                                        
                                                                                   self.OfficeOutBtn.setImage(UIImage(named: "pass.png")?.withRenderingMode(.alwaysOriginal), for: .normal)


                                    }



                                        
                                    //}
                                    //else
//                                    //{
//
//                                        let statusDic = empLeaveData["status"]! as! NSDictionary
//
//                                        print("statusDic---",statusDic)
//
//
//                                        let message = statusDic["message"] as? NSString
//                                        print("message-----",message as Any)
////                                        var alert = UIAlertController(title: "Failure", message: message as! String, preferredStyle: UIAlertController.Style.alert)
////                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
////                                        self.present(alert, animated: true, completion: nil)
////                                        print("Failure---")
////                                        print("Failure")
//                                    }
                                    //}
                                    //else
                                    //{
                                        
//                                        print("Calling manager dashboard")
//                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//
//                                        self.LeaveApplicationPendingview.isHidden = false
//                                        self.ManagerView.isHidden = false
//
                                        
                                        
                                        
                                        
//                                        let OfficeOutVC = storyBoard.instantiateViewController(withIdentifier: "OfficeOutVC") as! OfficeOutVC
//                                        //UserDefaults.standard.set(Verificationtoken, forKey: "token") //String
//                                        self.present(OfficeOutVC, animated:true, completion:nil)
//
                                    
                                    //}
                                    
                                    //Manager Dashboard Additional fetatures From API Absent , Leaves , LateComers and EarlyLeavers
                                    
//                                    if (empSummarycode == 200)
//                                    {
//
//                                        let empsummaryDetailsDic = empSummary["summaryDetails"]! as! NSDictionary
//                                        print("empsummaryDetailsDic------",empsummaryDetailsDic)
//
//
//
//                                        let absent = empsummaryDetailsDic["absent"]! as! NSInteger
//                                        print("absent------",absent)
//
//
//                                        let absentstrValue = String(absent)
//
//
//
//                                        self.AbsentLbl.text = absentstrValue
//
//                                        let totalAppLeave = empsummaryDetailsDic["totalAppLeave"]! as! NSInteger
//                                        print("totalAppLeave------",totalAppLeave)
//
//                                        let LeavesstrValue = String(totalAppLeave)
//
//                                        self.LeavesLbl.text = LeavesstrValue
//
//
//                                        let totalLateComers = empsummaryDetailsDic["totalLateComers"]! as! NSInteger
//                                        print("totalLateComers------",totalLateComers)
//                                        let totalLateComersstrValue = String(totalLateComers)
//                                        self.LateComersLbl.text = totalLateComersstrValue
//
//
//                                        let totalEarlyLeavers = empsummaryDetailsDic["totalEarlyLeavers"]! as! NSInteger
//                                        print("totalEarlyLeavers------",totalEarlyLeavers)
//                                        let totalEarlyLeaverssstrValue = String(totalEarlyLeavers)
//                                        self.EarlyLeaversLbl.text = totalEarlyLeaverssstrValue
//
//
//                                        let totalPendingLeave = empsummaryDetailsDic["totalPendingLeave"]! as! NSInteger
//                                        print("totalPendingLeave------",totalPendingLeave)
//
//                                         let totalPendingLeavesstrValue = String(totalPendingLeave)
//
//                                        self.LeaveApplicationPendingLbl.text = totalPendingLeavesstrValue
//
//
//
//                                    }
//                                    else
//                                    {
//
//
//                                    }
//
                                    
                                        
                                        
                                    
                                    
                                    self.customActivityIndicatory(self.view, startAnimate: false)

                                                                          
                                    
                                    
                                        
                }

                
                
            }
            
            
        }
        task.resume()
        
        
        
    }
    
    
    
    
    
    
    @objc func CancelLeave(_ sender:UIButton!)
        {
            
            
            
            print("Click cancel Button")
            
            
           
            
            
            self.customView.frame = CGRect.init(x: 0, y: 0, width: 350, height: 350)
                                                     //self.customView.backgroundColor = UIColor.white     //give color to the view
            
            self.customView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)

            
            
                                                     self.customView.center = self.view.center
                                                     self.view.addSubview(self.customView)


            
            label = UILabel(frame: CGRect(x: 60, y: 220, width: 350, height: 21))
                                                                                             //label.center = CGPoint(x: 160, y: 285)
                                                                                             //label.textAlignment = .center
                                                                                             label.text = "Do you want to cancel your leave?"
                                                                                             
                                                                                             label.textColor = UIColor.white
                                                                                             label.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
                                                                                             self.view.addSubview(label)
            
            
            
            //var imageView : UIImageView
                                                                           imageview  = UIImageView(frame:CGRect(x: 150, y: 260, width: 60, height: 60));
                                                                           imageview.image = UIImage(named:"selectmode.png")
                                                                           self.view.addSubview(imageview)
            
            
            
             ProceedButton = UIButton(type: .system)
                                                                                                                
                                                                                                                // Position Button
                                                                                                                ProceedButton.frame = CGRect(x: 50, y: 340, width: 275, height: 55)
                                                                                                                // Set text on button
                                                                                                                ProceedButton.setTitle("PROCEED", for: .normal)
                                                                                                                //myButton.setTitle("Pressed + Hold", for: .highlighted)
                                                                                                                
            ProceedButton.backgroundColor = UIColor.clear

            
            ProceedButton.layer.borderWidth = 1
            
            
            ProceedButton.layer.borderColor = UIColor.white.cgColor
            
            ProceedButton.setTitleColor(UIColor.white, for: .normal)

                                                                                                                // Set button action
                                                                                                    ProceedButton.addTarget(self, action: #selector(self.LeaveProceedBtn(_:)), for: .touchUpInside)
                                                                                                                
                                                                                                      self.view.addSubview(ProceedButton)
                                                     
            
            
            
            
            
            CancelBtnButton = UIButton(type: .system)
                                                                                                                
                                                                                                                // Position Button
                                                                                                                CancelBtnButton.frame = CGRect(x: 50, y: 410, width: 275, height: 55)
                                                                                                                // Set text on button
                                                                                                                CancelBtnButton.setTitle("CANCEL", for: .normal)
                                                                                                                //myButton.setTitle("Pressed + Hold", for: .highlighted)
                                                                                                                
                                                                                                                CancelBtnButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)

            
            
            
            CancelBtnButton.setTitleColor(UIColor.white, for: .normal)

                                                                                                                // Set button action
                                                                                                      CancelBtnButton.addTarget(self, action: #selector(self.CancelLeaveBtn(_:)), for: .touchUpInside)
                                                                                             
            
            
            
            
            customView.isHidden = false
                       imageview.isHidden = false
                       ProceedButton.isHidden = false
                       CancelBtnButton.isHidden = false
            
            label.isHidden = false
                       
            
                                                                                                      self.view.addSubview(CancelBtnButton)
                                                     
            
            
            
            
            
            }

    
    
    
    @objc func LeaveProceedBtn(_ sender:UIButton!)
              {
               
               
               print("Leave Proceed------")
               
               

                            
                            
                            
                            //        "empId":"8",
                            //        "empPresistedFaceId":"abc123",
                            //        "empDeviceName":"Oppo",
                            //        "empModelNumber":"A7",
                            //        "empAndriodVersion":"9",
                            //        "employeePic":" base64 converted String "
                            //
                            //
                
                                    let parameters = ["custId": RetrivedcustId as Any,"empLeaveId": empLeaveId as Any] as [String : Any]
                
                
                                    //    var RetrivedcustId : Int = 0r
                                    //
                                    //
                                    //
                                    //    let parameters = ["custId": RetrivedcustId] as [String : Any]
                                    //
                
                                    //create the url with URL
                                    //let url = URL(string: "https://www.webliststore.biz/app_api/api/authenticate_user")! //change the url
                
                
                                    //let url: NSURL = NSURL(string:"http://122.166.152.106:8081/attnd-api-gateway-service/api/customer/employee/setup/updateEmpAppStatus ")!
                
                
                
                                    let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/cancel")!
                
                
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
                                            print("Json Response",responseJSON)
                
                
                
                                                            DispatchQueue.main.async {
                
                                                                let code = responseJSON["code"] as? NSInteger
                                                                              print("face code-----",code as Any)
                
                
                
                                                                              if(code == 200)
                                                                              {
                
                                                                                var message = ""
                                                                                message = (responseJSON["message"] as? String)!
                

                                                                                
                                                                                
                                                                                
                                                                                
                                                                                let alert = UIAlertController(title: "Succesful", message: "Leave Cancelled successfully!", preferredStyle: .alert)
                                                                                                                                                                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                                                                                                                                                      let UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "UITabBarController")
                                                                                                                                                                                               
                                                                                                                                           self.present(UITabBarController, animated:true, completion:nil)
                                                                                                                                                                  }))
                                                                                                                                                                  self.present(alert, animated: true)
                                                                                              
                                                                                                                                              
                                                                                                                                              
                                                                                              
                                                                                
                                                                                
                                                                                
                
//                                                    let alert = UIAlertController(title: "Leave Cancelled successfully", message: message as String, preferredStyle: UIAlertController.Style.alert)
//                                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                                                    self.present(alert, animated: true, completion: nil)
//
//                                                                                                print("Successfully inserted ",message)
                
                                                                                
                                                                                
//                                                                                let alertController = UIAlertController(title: "Disclaimer", message: "Disclaimer Text Here", preferredStyle: .alert)
//
//
//                                                                                let declineAction = UIAlertAction(title: "Decline", style: .cancel, handler: nil)
//                                                                                alertController.addAction(declineAction)
//
//                                                                                let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) -> Void in

                                                         
                                                                                    
                                                                                    
                                                                                    
//                                                                                    let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
//                                                                                    self.present(UITabBarController, animated:true, completion:nil)
//
                                                                                    
                                                                                    
                                                                                    
                                         
                                        }
                
                                            }
                
                                        }
                
                
                                    }
                                    task.resume()
                
                
                
             
       }
       
    
    
    
    
    
    
    
    @objc func CancelLeaveBtn(_ sender:UIButton!)
           {
            
            
            print("cancel------")


            customView.isHidden = true
            imageview.isHidden = true
            ProceedButton.isHidden = true
            CancelBtnButton.isHidden = true
            label.isHidden = true

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count:Int?
        
        if tableView == self.HomeDashboatdtbl {
            count = HomeDashboardNavigationMenuArray.count
        }
        
        //        if tableView == self.Menutbl {
        //            count =  NavigationmenuArray.count
        //        }
        return count!
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveNavigationcell", for: indexPath) as! LeaveNavigationcell
        cell.accessoryType = .disclosureIndicator

        
        // set the text from the data model
        cell.LeaveNavigationLbl?.text = self.HomeDashboardNavigationMenuArray[indexPath.row]
        
        //        let image = NavigationMenuArray[indexPath.row]
        //
        //        cell.slideMenuimgicon.image = image
        
        
        return cell
    }
    
    
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        if indexPath.row == 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

            let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            self.present(CalendarVC, animated:true, completion:nil)

            
//
//            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
//            let CalendarVC = storyBoard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//            self.navigationController?.pushViewController(CalendarVC, animated:false)
//
            
            
            
        } else if indexPath.item == 1 {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

             let FaqVC = storyBoard.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
           self.present(FaqVC, animated:true, completion:nil)

            
        }
        else if indexPath.item == 2 {
            
            if ContactUsView.isHidden {
                ContactUsView.isHidden = false
                ContactusText.isHidden = false
            } else {
                ContactUsView.isHidden = true
                ContactusText.isHidden = true
            }
            
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
          let mainContainer: UIView = UIView(frame: viewContainer.frame)
          mainContainer.center = viewContainer.center
          mainContainer.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
        
        
          mainContainer.alpha = 0.5
          mainContainer.tag = 789456123
          mainContainer.isUserInteractionEnabled = false
      
          let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
          viewBackgroundLoading.center = viewContainer.center
         // viewBackgroundLoading.backgroundColor = UIColor.init(netHex: 0x444444)
          
        viewBackgroundLoading.backgroundColor = UIColor.darkGray
        
        viewBackgroundLoading.alpha = 0.5
          viewBackgroundLoading.clipsToBounds = true
          viewBackgroundLoading.layer.cornerRadius = 15
      
          let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
          activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.style =
            UIActivityIndicatorView.Style.whiteLarge
          activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
                  if startAnimate!{
                       viewBackgroundLoading.addSubview(activityIndicatorView)
                        mainContainer.addSubview(viewBackgroundLoading)
                        viewContainer.addSubview(mainContainer)
                        activityIndicatorView.startAnimating()
                  }else{
                         for subview in viewContainer.subviews{
                              if subview.tag == 789456123{
                                subview.removeFromSuperview()
                              }
                          }
                  }
             return activityIndicatorView
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
