//
//  FieldVisitVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 8/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import GoogleMaps

class FieldVisitVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
@IBOutlet weak var mapView: GMSMapView!
@IBOutlet weak var Fieldvisitoutbtn: UIButton!
@IBOutlet weak var FieldvisitBckview: UIView!
@IBOutlet weak var Cancelbtn: UIButton!
@IBOutlet weak var Submitbrn: UIButton!
@IBOutlet weak var Selectplacelbl: UILabel!
@IBOutlet weak var VisitPuposetxtfld: UITextField!
@IBOutlet weak var Adresstxtview: UITextView!
@IBOutlet weak var DrpDownview: UIView!
@IBOutlet weak var SelectPlaceDrptble: UITableView!
var address: String = ""
var LattitudestrData: String = ""
var LongitudestrData: String = ""
var empAttndInDateTime : String = ""
var empAttndOutDateTime : String = ""
var RetrivedcustId = Int()
var RetrivedempId = Int()
var SelectPlaceArray:NSMutableArray = NSMutableArray()
var locationManager = CLLocationManager()

override func viewDidLoad() {
    super.viewDidLoad()
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
    
    locationManager.requestWhenInUseAuthorization()
    var currentLoc: CLLocation!
    if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
        currentLoc = locationManager.location
        LattitudestrData = String(currentLoc.coordinate.latitude)
        LongitudestrData = String(currentLoc.coordinate.longitude)
    }
            getAddress { (address) in
                print("Location------",address)
            }
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

    
    // Do any additional setup after loading the view.
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
    
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
    marker.title = address
    marker.map = self.mapView
}


func getAddress(handler: @escaping (String) -> Void)
{

    let Locationlatitude = (LattitudestrData as NSString).doubleValue
    let Locationlongitude = (LongitudestrData as NSString).doubleValue
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: Locationlatitude, longitude: Locationlongitude)
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark?
        placeMark = placemarks?[0]
        // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                self.address += locationName + ", "
            }
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                self.address += street + ", "
            }
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                self.address += city + ", "
            }
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                self.address += zip + ", "
            }
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                self.address += country
            }
            
           // Passing address back
        handler(self.address)
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
            self.Fieldvisitoutbtn.setTitleColor(.darkGray, for: .normal)
        } else {
        self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)
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

        }
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.animate(toViewingAngle: 45)
        self.mapView.delegate = self
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
               print("Selectplacestr data",responseDict)
               print("Selectplacestr Type Array",SelectPlaceArray)
               var Selectplacestr : String?
               Selectplacestr = responseDict["visitClientPlace"] as? String
               print("Selectplacestr",Selectplacestr)
               drpcell.selectPlacedrpLbl!.text = Selectplacestr
        Selectplacelbl.text = Selectplacestr
        DrpDownview.isHidden = true
        
        
    }
    
    
@objc func pressButton(button: UIButton) {
    NSLog("pressed!")
    FieldvisitBckview.isHidden = false
    Adresstxtview.text = address
}

    @IBAction func Cancelbtnclk(_ sender: Any) {
        FieldvisitBckview.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        VisitPuposetxtfld.resignFirstResponder()
        return true;
    }
}




