//
//  RegistrationVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/2/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreLocation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



class RegistrationVC: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate {
    
    var showTabBar = false;
    var manager:CLLocationManager!
    
    
    @IBOutlet weak var Bckview: UIView!
    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var PopUpNameLbl: UILabel!
    @IBOutlet weak var PopUpMobilenumLbl: UILabel!
    @IBOutlet weak var NoteLbl: UILabel!
    @IBOutlet weak var NoteLbl2: UILabel!
    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var ConfirmBtm: UIButton!
    @IBOutlet weak var Customercodeview: UIView!
    @IBOutlet weak var Custmernumberview: UIView!
    @IBOutlet weak var CustmercodeTxt: UITextField!
    @IBOutlet weak var MobilenumTxt: UITextField!
    var employeeName = String()
    var custName = String()
    var brName = String()
    var RetrivedFacestr = String()
    
    //var brId = String()
    //var brId = Enum.self
    var empPresistedFaceId = String()
    var custId : Int = 0
    var empId : Int = 0
    var brId : Int = 0
    var convertedcustIdstr = String()
    var convertedempIdstr = String()
    var convertedbrIdstr = String()
    var brCode = String()
    
    //var brCode : Int = 0
    var db:DBHelper = DBHelper()
    var persons:[Person] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUsersLocationServicesAuthorization()
        
        let defaults = UserDefaults.standard
        defaults.set("Coding Explorer", forKey: "userNameKey")
        
        
        customActivityIndicatory(self.view, startAnimate: false)
        hideKeyboardWhenTappedAround()
        CustmercodeTxt.delegate = self
        MobilenumTxt.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        let myColor : UIColor = UIColor.lightGray
        Customercodeview.layer.borderWidth = 1
        Customercodeview.layer.borderColor = myColor.cgColor
        Customercodeview.layer.borderColor = myColor.cgColor
        
        
        Custmernumberview.layer.borderWidth = 1
        Custmernumberview.layer.borderColor = myColor.cgColor
        Custmernumberview.layer.borderColor = myColor.cgColor
        
        Bckview.layer.shadowColor = UIColor.black.cgColor
        Bckview.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        Bckview.layer.shadowOpacity = 0.2
        Bckview.layer.shadowRadius = 4.0
        //NoteLbl.numberOfLines = 2;
        //Popupview.layer.cornerRadius = 6.0
        Popupview.layer.masksToBounds = true
        // set the shadow properties
        Popupview.layer.shadowColor = UIColor.darkGray.cgColor
        Popupview.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        Popupview.layer.shadowOpacity = 0.2
        Popupview.layer.shadowRadius = 4.0
        NoteLbl.text = "NOTE : Make sure the name and the";
        NoteLbl2.text = "Mobile number are correct"
        Popupview.isHidden = true
        CancelBtn.layer.borderWidth = 1
        CancelBtn.layer.borderColor = UIColor.white.cgColor
        //uppercase letters keypad
        CustmercodeTxt.addTarget(self, action: #selector(myTextFieldTextChanged), for: UIControl.Event.editingChanged)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showTabBar {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
            self.present(tabBarController, animated:true, completion:nil)
        }
    }
    
    
    
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @objc func myTextFieldTextChanged (textField: UITextField) {
        CustmercodeTxt.text =  textField.text?.uppercased()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == CustmercodeTxt {
            
            let NewLength = (CustmercodeTxt.text?.count)! + string.count - range.length
            return NewLength <= 6
        } else if textField == MobilenumTxt{
            
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            let Range = range.length + range.location > (MobilenumTxt.text?.count)!
            
            if Range == false && alphabet == false {
                
                return false
            }
            
            
            let NewLength = (MobilenumTxt.text?.count)! + string.count - range.length
            return NewLength <= 10
            
            
        }
        
        return false
    }
    
    @IBAction func BerifyBtnclk(_ sender: Any) {
        
        
        if (CustmercodeTxt.text == ""){
               let alert = UIAlertController(title: "Error", message: "Please Enter Custmer code", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
               return
           }
            if (MobilenumTxt.text == ""){
                   let alert = UIAlertController(title: "Error", message: "Please Enter 10 digit mobile number", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   return
               }

           else {
            
            VerifiedRegisterscreedn()
        }
        
    }
    
    
    
    @IBAction func ConfirmBtnclk(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let InputOTPVC = storyBoard.instantiateViewController(withIdentifier: "InputOTPVC") as! InputOTPVC
        //Stored values in Locally Using NSUserDefaulds Database
        
        UserDefaults.standard.set(self.custId, forKey: "custId")
        UserDefaults.standard.set(self.empId, forKey: "empId")
        UserDefaults.standard.set(self.brCode, forKey: "brCode")
        UserDefaults.standard.set(self.employeeName, forKey: "employeeName")
        UserDefaults.standard.set(self.brName, forKey: "brName")
        UserDefaults.standard.set(self.empPresistedFaceId, forKey: "empPresistedFaceId")
        UserDefaults.standard.set(self.MobilenumTxt.text, forKey: "Mobilenum")
        UserDefaults.standard.set(self.CustmercodeTxt.text, forKey: "Custmercode")
        self.customActivityIndicatory(self.view, startAnimate: false)
        print("face else RetrivedFacestr-------",self.RetrivedFacestr)
        UserDefaults.standard.set(self.RetrivedFacestr, forKey: "Facestr")
        
        //
        //
        //        let def = UserDefaults.standard
        //        def.set(true, forKey: "empPresistedFaceId") // save true flag to UserDefaults
        //        def.synchronize()
        //
        
        self.navigationController?.pushViewController(InputOTPVC, animated:true)
        
        
    }
    
    
    func VerifiedRegisterscreedn()
    {
        
        let parameters = ["custCode":CustmercodeTxt.text as Any,
                          "empMobile":MobilenumTxt.text as Any] as [String : Any]
        
		Baseurl.shared().baseURL
		print("Base url point",Baseurl.shared().baseURL)

		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile"
		var RegesterAPI = "\(StartPoint)\(Endpoint)"
		print("Register API ",RegesterAPI)
		
		let url: NSURL = NSURL(string:RegesterAPI)!
		print("url----",url)
		
		
		//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/setup/findByCustCodeAndEmpMobile")!
        
        self.customActivityIndicatory(self.view, startAnimate: true)
        
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Json Response",responseJSON)
                
                DispatchQueue.main.async {
                    let statusDic = responseJSON["status"]! as! NSDictionary
                    print("statusDic---",statusDic)
                    let code = statusDic["code"] as? NSInteger
                    print("code-----",code as Any)
                    
                    if(code == 200)
                    {
                        
                        self.customActivityIndicatory(self.view, startAnimate: false)
                        let ItemsDict = responseJSON["employeeDataDto"] as! NSDictionary
                        self.custName = (ItemsDict["custName"] as? String)!
                        print("custName ------------",self.custName as Any)
                        
                        self.employeeName = (ItemsDict["employeeName"] as? String)!
                        print("employeeName ------------",self.employeeName as Any)
                        self.brName = (ItemsDict["brName"] as? String)!
                        print("brName ------------",self.brName as Any)
                        
                        
                        //                    self.empPresistedFaceId = (ItemsDict["empPresistedFaceId"] as? String)!
                        //                                           print("empPresistedFaceId ------------",self.empPresistedFaceId as Any)
                        //
                        
                        
                        self.custId = (ItemsDict["custId"] as? NSInteger)!
                        print("custId ------------",self.custId as Any)
                        self.convertedcustIdstr = String(self.custId)
                        self.empId = (ItemsDict["empId"] as? NSInteger)!
                        print("empId ------------",self.empId as Any)
                        self.convertedempIdstr = String(self.empId)
                        
                        self.brId = (ItemsDict["brId"] as? NSInteger)!
                        print("brId ------------",self.brId as Any)
                        self.convertedbrIdstr = String(self.brId)
                        
                        self.brCode = (ItemsDict["brCode"] as? String)!
                        print("brCode---",self.brCode)
                        //self.SQliteDatabase_Employee()
                        
                        print("success---")
                        
                        
                        //empPresistedFaceId
                        
                        if (self.empPresistedFaceId == ""){
                            //if let id = ItemsDict["empPresistedFaceId"] as? NSNull {
                            
                            self.employeeName = (ItemsDict["employeeName"] as? String)!
                            print("employeeName ------------",self.employeeName as Any)
                            
                            
                            self.custId = (ItemsDict["custId"] as? NSInteger)!
                            print("custId ------------",self.custId as Any)
                            
                            self.empId = (ItemsDict["empId"] as? NSInteger)!
                            print("empId ------------",self.empId as Any)
                            
                            //                    self.brCode = Int((ItemsDict["brCode"] as? NSNumber)!)
                            //                    print("brCode ------------",self.brCode as Any)
                            //
                            self.brCode = (ItemsDict["brCode"] as? String)!
                            print("brCode---",self.brCode)
                            
                            self.PopUpNameLbl.text = self.employeeName
                            self.PopUpMobilenumLbl.text = self.MobilenumTxt.text
                            self.Bckview.isHidden = true
                            self.Popupview.isHidden = false
                            
                            print("success---")
                        }
                        else
                        {
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                            let InputOTPVC = storyBoard.instantiateViewController(withIdentifier: "InputOTPVC") as! InputOTPVC
                            
                            UserDefaults.standard.set(self.custId, forKey: "custId")
                            UserDefaults.standard.set(self.empId, forKey: "empId")
                            UserDefaults.standard.set(self.brCode, forKey: "brCode")
                            UserDefaults.standard.set(self.employeeName, forKey: "employeeName")
                            UserDefaults.standard.set(self.empPresistedFaceId, forKey: "empPresistedFaceId")
                            UserDefaults.standard.set(self.brName, forKey: "brName")
                            
                            UserDefaults.standard.set(self.MobilenumTxt.text, forKey: "Mobilenum")
                            UserDefaults.standard.set(self.CustmercodeTxt.text, forKey: "Custmercode")
                            
                            
                            //                        let def = UserDefaults.standard
                            //                        def.set(true, forKey: "empPresistedFaceId") // save true flag to UserDefaults
                            //                        def.synchronize()
                            
                            self.navigationController?.pushViewController(InputOTPVC, animated:false)
                            
                        }
                        
                    }
                    else
                    {
                        
                        self.customActivityIndicatory(self.view, startAnimate: false)
                        let statusDic = responseJSON["status"]! as! NSDictionary
                        print("statusDic---",statusDic)
                        let message = statusDic["message"] as? NSString
                        print("message-----",message as Any)
                        var alert = UIAlertController(title: "Failure", message: message as! String, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Failure---")
                    }
                    
                }
            }    }
        task.resume()
        
    }
    
    //    func SQliteDatabase_Employee()
    //    {
    //
    //
    //        db.insert(id: 0, customerId: convertedcustIdstr,branchId: convertedbrIdstr,employeeId: convertedempIdstr,customerName: custName,branchName:brName,employeeName:employeeName,empGroupFaceList:"",empPersistedFaceId:empPresistedFaceId)
    //
    //        persons = db.read()
    //
    //        print("SQlite Database files")
    //    }
    
    
    @IBAction func BckBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        //self.presentingViewController?.dismiss(animated: false, completion: nil)

        
        //navigationController?.popViewController(animated: true)

        Popupview.isHidden = true
    }
    //
    //
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        animateViewMoving(up: true, moveValue: 100)
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        animateViewMoving(up: false, moveValue: 100)
    //    }
    //    func animateViewMoving (up:Bool, moveValue :CGFloat){
    //        let movementDuration:TimeInterval = 0.3
    //        let movement:CGFloat = ( up ? -moveValue : moveValue)
    //        UIView.beginAnimations( "animateView", context: nil)
    //        UIView.setAnimationBeginsFromCurrentState(true)
    //        UIView.setAnimationDuration(movementDuration )
    //        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    //        UIView.commitAnimations()
    //    }
    
    
    
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
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
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
    
    
    //Location Permisstion's code
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        print("locations = \(locations)")
        //gpsResult.text = "success"
    }
    
    // authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("restricted") //we have got the location access
        case .denied, .notDetermined, .restricted:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let LocationPermissionVC = storyBoard.instantiateViewController(withIdentifier: "LocationPermissionVC") as! LocationPermissionVC
            self.navigationController?.pushViewController(LocationPermissionVC, animated: true)
        default:
            print("location accessed")
        }
    }
    
    func checkUsersLocationServicesAuthorization(){
        if manager == nil {
            manager = CLLocationManager()
            manager.delegate = self
        }
        manager.requestWhenInUseAuthorization()
    }
    
    
    
    
    
}

