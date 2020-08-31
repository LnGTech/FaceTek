//
//  FieldVisitVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 8/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class FieldVisitVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
@IBOutlet weak var mapView: GMSMapView!
@IBOutlet weak var Fieldvisitoutbtn: UIButton!
    
    @IBOutlet weak var FieldVisitInbtn: UIButton!
    @IBOutlet weak var FieldvisitBckview: UIView!
@IBOutlet weak var Cancelbtn: UIButton!
@IBOutlet weak var Submitbrn: UIButton!
@IBOutlet weak var Selectplacelbl: UILabel!
@IBOutlet weak var VisitPuposetxtfld: UITextField!
@IBOutlet weak var Adresstxtview: UITextView!
@IBOutlet weak var DrpDownview: UIView!
    
    @IBOutlet weak var SelectPlaceViewconstriant: NSLayoutConstraint!
    
@IBOutlet weak var SelectPlaceDrptble: UITableView!
var addressString : String = ""
var empAttndInDateTime : String = ""
var empAttndOutDateTime : String = ""
    var latstr : String = ""
    var longstr : String = ""


var RetrivedcustId = Int()
var RetrivedempId = Int()
    //FieldvisitOUT views
    var customView = UIView()
    var customSubView = UIView()
    
    //FieldVisit IN Views
    var customView1 = UIView()
    var customSubView1 = UIView()

var SelectPlaceArray:NSMutableArray = NSMutableArray()
var locationManager = CLLocationManager()

override func viewDidLoad() {
    super.viewDidLoad()
    
     
    
//
//
//    //Field visit - IN and OUT button text color code
self.FieldVisitInbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
    
self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        
    self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    
    self.SelectPlaceViewconstriant?.constant = 0

    
    SelectPlaceDrptble.register(UINib(nibName: "SelectplaceDrpdwncell", bundle: nil), forCellReuseIdentifier: "SelectplaceDrpdwncell")
    self.VisitPuposetxtfld.delegate = self
    FieldvisitBckview.isHidden = true
    DrpDownview.isHidden = true
    let defaults = UserDefaults.standard
    RetrivedcustId = defaults.integer(forKey: "custId")
    print("RetrivedcustId----",RetrivedcustId)
    RetrivedempId = defaults.integer(forKey: "empId")
    print("RetrivedempId----",RetrivedempId)
    //Fieldvisit-Enable-Disable method
    Fieldvisit_OUT()
    //Select Dropdown method
    selectPlaceDrpdown()
    
    
    //Shadow color code
    FieldvisitBckview.layer.shadowColor = UIColor.black.cgColor
    FieldvisitBckview.layer.shadowOpacity = 0.8
    FieldvisitBckview.layer.shadowOffset = CGSize(width: 8, height: 8)
    FieldvisitBckview.layer.shadowRadius = 10
    FieldvisitBckview.layer.shadowPath = UIBezierPath(rect:FieldvisitBckview.bounds).cgPath
    FieldvisitBckview.layer.shouldRasterize = true
    
    //Cancel and submit button rounded conrner code
    Cancelbtn.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)
    Cancelbtn.layer.cornerRadius = 18
    Cancelbtn.layer.borderWidth = 1
    Cancelbtn.layer.borderColor = UIColor.clear.cgColor
    
    Submitbrn.backgroundColor = #colorLiteral(red: 0.9108545184, green: 0.7098409534, blue: 0.3473398089, alpha: 1)
    Submitbrn.layer.cornerRadius = 18
    Submitbrn.layer.borderWidth = 1
    Submitbrn.layer.borderColor = UIColor.clear.cgColor
    
    //select place lable guesture
    let tap = UITapGestureRecognizer(target: self, action: #selector(FieldVisitVC.tapFunction))
    Selectplacelbl.isUserInteractionEnabled = true
    Selectplacelbl.addGestureRecognizer(tap)
    
    
    //visit Purpose textfield validation
    VisitPuposetxtfld.addTarget(self, action: #selector(actionTextFieldIsEditingChanged), for: UIControl.Event.editingChanged)
    Submitbrn.isEnabled = false
    Submitbrn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.6487585616, blue: 0.06666666667, alpha: 0.2948148545)
    
    //Field visit IN disable
    FieldVisitInbtn.isEnabled = false

}
    
    
    @objc func actionTextFieldIsEditingChanged(sender: UITextField) {
        if sender.text!.isEmpty {
         // textfield is empty
            print("textfield is empty")
       } else {
            print("text field is not empty")
            Submitbrn.isEnabled = true
            Submitbrn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.7098039216, blue: 0.2670965325, alpha: 1)

         // text field is not empty
       }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {

        print("tap working")
        DrpDownview.isHidden = false
        

    }
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let newLocation = locations.last // find your device location
    mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 16) // show your device location on map
    mapView.settings.myLocationButton = true // show current location button
   let lat = (newLocation?.coordinate.latitude)! // get current location latitude
   let long = (newLocation?.coordinate.longitude)!
   latstr = String(lat)
   longstr = String(long)
   let geoCoder = CLGeocoder()
   let location = CLLocation(latitude: lat, longitude: long)
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
    let pm = placemarks! as [CLPlacemark]

    if pm.count > 0 {
    let pm = placemarks![0]
    print(pm.country as Any)
    print(pm.locality as Any)
    print(pm.subLocality as Any)
    print(pm.thoroughfare as Any)
    print(pm.postalCode as Any)
    print(pm.subThoroughfare as Any)
    if pm.subLocality != nil {
    self.addressString = self.addressString + pm.subLocality! + ", "
    }
    if pm.thoroughfare != nil {
    self.addressString = self.addressString + pm.thoroughfare! + ", "
    }
    if pm.locality != nil {
    self.addressString = self.addressString + pm.locality! + ", "
    }
    if pm.country != nil {
    self.addressString = self.addressString + pm.country! + ", "
    }
    if pm.postalCode != nil {
    self.addressString = self.addressString + pm.postalCode! + " "
    }

//    let marker = GMSMarker()
//    marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
//    marker.title = self.addressString
//    marker.map = self.mapView
//    print("address location",self.addressString)
}
})
    }


//Field-visit OUT Enable and Disable
func Fieldvisit_OUT()
{
        
  let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
  let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
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
    print("Employee ---- Json Response",responseJSON)
                
        let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
    DispatchQueue.main.async
    {
        self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
        self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
        if (self.empAttndInDateTime == "NA") {
//            self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
//            self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        } else {

        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 500
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
            //UIbutton Action
        self.Fieldvisitoutbtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
            self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)
            self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)


        }
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.animate(toViewingAngle: 45)
        self.mapView.delegate = self
        }
        
        if (self.empAttndOutDateTime == "NA") {
            
        } else {
        self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
            
        self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            self.Fieldvisitoutbtn.isEnabled = false
        }
    }
}
}
task.resume()
}
    
    func selectPlaceDrpdown()
    {
        let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
        let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getVisitClientPlaceDDList")!
        let session = URLSession.shared
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
        print("Visit select places ---- Json Response",responseJSON)
                        
        let ItemsDict = responseJSON["clientPlaceScheduleList"] as? [String:Any]
            print("clientPlaceScheduleList",ItemsDict)
            DispatchQueue.main.async
            {
        let SelectPlaceArray = responseJSON["clientPlaceScheduleList"] as! NSArray
        print("Select Place Array values----",SelectPlaceArray)
        for SelectPlaceDic in SelectPlaceArray as! [[String:Any]]
                {
        var MainDict:NSMutableDictionary = NSMutableDictionary()
        var SelectPlacestr = ""
                    SelectPlacestr = (SelectPlaceDic["visitClientPlace"] as? String)!
        print("visitClientPlace-------",SelectPlacestr)
        MainDict.setObject(SelectPlacestr, forKey: "visitClientPlace" as NSCopying)
                    self.SelectPlaceArray.add(MainDict)

                }
                self.SelectPlaceDrptble.reloadData()
            }
        }
        }
        task.resume()
    }
    
    func FieldvisitFormsubmitAPI()
    {
        let latlanstr = latstr + ", " + longstr
        print("suresh latlongvalues---",latlanstr)

        let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"outFromLatLong": latlanstr as Any,"outFromAddress":"Marathalli","toClientNamePlace":"SilkBoard","visitPurpose":"ClientMetting","prevVisitId":"2","meetingOutcome":"Approved","empVisitScheduleId":"2"] as [String : Any]
        
        let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertFieldVisitOutDetailsWithScheduleId")!
        let session = URLSession.shared
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
        print(" Field Visi submit form ---- Json Response",responseJSON)
        
            DispatchQueue.main.async
                {
        let statusDic = responseJSON["status"]! as! NSDictionary
        print("statusDic---",statusDic)
        let code = statusDic["code"] as! NSInteger
        if(code == 200)
        {
                       
        let message = statusDic["message"] as! NSString
                        //Leave PopUp method calling
        self.FieldvisitOUT_PopUp()
        }
        else
        {
        let message = responseJSON["message"]! as! NSString
        let alert = UIAlertController(title: "Alert", message: message as String, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
                    }

            }
            
        }
        }
        task.resume()
        
    }
    
    //tableview Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SelectPlaceArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let drpcell = tableView.dequeueReusableCell(withIdentifier: "SelectplaceDrpdwncell", for: indexPath) as! SelectplaceDrpdwncell
        var responseDict = self.SelectPlaceArray[indexPath.row] as! NSMutableDictionary
        var maindata = SelectPlaceArray[indexPath.row]
        print("Selectplacestr data",responseDict)
        print("Selectplacestr Type Array",SelectPlaceArray)
        var Selectplacestr : String?
        Selectplacestr = responseDict["visitClientPlace"] as? String
        print("Selectplacestr",Selectplacestr)
        drpcell.selectPlacedrpLbl!.text = Selectplacestr
        return drpcell

    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drpcell = tableView.dequeueReusableCell(withIdentifier: "SelectplaceDrpdwncell", for: indexPath) as! SelectplaceDrpdwncell
        var responseDict = self.SelectPlaceArray[indexPath.row] as! NSMutableDictionary
        var maindata = SelectPlaceArray[indexPath.row]
        var Selectplacestr : String?
        Selectplacestr = responseDict["visitClientPlace"] as? String
        drpcell.selectPlacedrpLbl!.text = Selectplacestr
        Selectplacelbl.text = Selectplacestr
        DrpDownview.isHidden = true

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.SelectPlaceViewconstriant?.constant = 45
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }

    
@objc func pressButton(button: UIButton) {
    NSLog("pressed!")
    FieldvisitBckview.isHidden = false
    Adresstxtview.text = addressString
}

    @IBAction func Cancelbtnclk(_ sender: Any) {
        FieldvisitBckview.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        VisitPuposetxtfld.resignFirstResponder()
        return true;
    }
    
    
    func FieldvisitOUT_PopUp()
    {
        
        self.customView.frame = CGRect.init(x: 0, y: 0, width: 230, height: 300)
        self.customView.backgroundColor = UIColor.white     //give color to the view
        self.customView.center = self.view.center
        self.view.addSubview(self.customView)
        self.customSubView.frame = CGRect.init(x: 0, y: 0, width: 233, height: 150)
        self.customSubView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        let shadowPath = UIBezierPath(rect: self.customView.bounds)
        self.customView.layer.masksToBounds = false
        self.customView.layer.shadowColor = UIColor.darkGray.cgColor
        self.customView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.customView.layer.shadowOpacity = 0.8
        self.customView.layer.shadowPath = shadowPath.cgPath
        self.customView.addSubview(self.customSubView)
        //image
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 65, y: 10, width: 100, height: 100));
        imageView.image = UIImage(named:"conform.png")
        self.customView.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 55, y: 110, width: 200, height: 21));
        label.text = "Thank you!"
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textColor = UIColor.white
        self.customView.addSubview(label)
        let label1 = UILabel(frame: CGRect(x: 55, y: 175, width: 400, height: 21))
        label1.text = "Visit Out Started"
        label1.textColor = UIColor.darkGray
        label1.shadowColor = UIColor.gray
        label1.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        self.customView.addSubview(label1)
        let myButton = UIButton(type: .system)
        myButton.frame = CGRect(x: 65, y: 210, width: 100, height: 50)
        // Set text on button
        myButton.setTitle("OK", for: .normal)
        myButton.setTitle("Pressed + Hold", for: .highlighted)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        myButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        myButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        self.customView.addSubview(myButton)
        
    }
    @objc func buttonAction(_ sender:UIButton!)
    {
        FieldvisitBckview.isHidden = true
        customView.isHidden = true
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let UITabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
//        self.present(UITabBarController, animated:true, completion:nil)
        
    }
    
    
    @objc func FieldVisitInbtnclick(_ sender:UIButton!)
    {
        self.Fieldvisitoutbtn.setTitleColor(.darkGray, for: .normal)

    }
    
    @IBAction func FieldvisitOUT_Submitbtnclk(_ sender: Any) {
        FieldvisitFormsubmitAPI()
        //FieldVisitInbtn.backgroundColor = UIColor.red
        self.FieldVisitInbtn.setTitleColor(.black, for: .normal)
        self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        FieldVisitInbtn.isEnabled = true
        Fieldvisitoutbtn.isEnabled = false
        self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)

        
        self.FieldVisitInbtn.addTarget(self, action: #selector(self.pressINButton(button:)), for: .touchUpInside)

//        let marker = GMSMarker()
//        let convertedlat = Double(latstr)
//        let convertedlong = Double(longstr)
//        let newPosition = CLLocationCoordinate2D(latitude: convertedlat!, longitude: convertedlong!)
//        marker.position = newPosition
//        marker.title = self.addressString
//        marker.map = self.mapView
//        print("address location",self.addressString)
        
               
    }
    @objc func pressINButton(button: UIButton) {
        
        

        customView1.frame = CGRect.init(x: 50, y: 50, width: 230, height: 300)
        customView1.backgroundColor = UIColor.white     //give color to the view
        customView1.center = view.center
        view.addSubview(customView1)
        customSubView1.frame = CGRect.init(x: 0, y: 0, width: 233, height: 150)
        customSubView1.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        let shadowPath = UIBezierPath(rect: customView1.bounds)
        customView1.layer.masksToBounds = false
        customView1.layer.shadowColor = UIColor.darkGray.cgColor
        customView1.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        customView1.layer.shadowOpacity = 0.8
        customView1.layer.shadowPath = shadowPath.cgPath
        customView1.addSubview(customSubView1)
        //image
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 65, y: 10, width: 100, height: 100));
        imageView.image = UIImage(named:"conform.png")
        customView1.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 55, y: 110, width: 200, height: 21));
        label.text = "Thank you!"
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textColor = UIColor.white
        customView1.addSubview(label)
        let label1 = UILabel(frame: CGRect(x: 55, y: 175, width: 400, height: 21))
        label1.text = "Visit In Updated"
        label1.textColor = UIColor.darkGray
        label1.shadowColor = UIColor.gray
        label1.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        customView1.addSubview(label1)
        let myButton = UIButton(type: .system)
        myButton.frame = CGRect(x: 65, y: 210, width: 100, height: 50)
        // Set text on button
        myButton.setTitle("OK", for: .normal)
        myButton.setTitle("Pressed + Hold", for: .highlighted)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        myButton.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.537254902, blue: 0.1019607843, alpha: 1)
        myButton.addTarget(self, action: #selector(self.FieldVisitIN(_:)), for: .touchUpInside)
        customView1.addSubview(myButton)
        
    }
    @objc func FieldVisitIN(_ sender:UIButton!)
    {
        customView1.isHidden = true
        FieldVisitInbtn.isEnabled = false
        Fieldvisitoutbtn.isEnabled = true
        self.FieldVisitInbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
        self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)
        self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        

                let marker = GMSMarker()
                let convertedlat = Double(latstr)
                let convertedlong = Double(longstr)
                let newPosition = CLLocationCoordinate2D(latitude: convertedlat!, longitude: convertedlong!)
                marker.position = newPosition
                marker.title = self.addressString
                marker.map = self.mapView
                print("address location",self.addressString)
    }
   
}




