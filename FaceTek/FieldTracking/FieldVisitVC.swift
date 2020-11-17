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
import GooglePlaces
import Alamofire
import SwiftyJSON

extension UIViewController {
func dismissKey()
{
let dismisstap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard1))
dismisstap.cancelsTouchesInView = false
view.addGestureRecognizer(dismisstap)
}
@objc func dismissKeyboard1()
{
view.endEditing(true)
}
}



class FieldVisitVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {


private var isAlreadyLoaddropdowndata = false
private var Fieldvisitout_cleardata = false
private var RefreshformData = false
    private var isAlreadyAddrestxt = false


	@IBOutlet weak var FieldVisitLbltxt: UILabel!
	
	
	@IBOutlet weak var PlaceClintNametxtLbl: UILabel!
	
	@IBOutlet weak var VisitPurposetxtLbl: UILabel!
	
	@IBOutlet weak var AddresstxtLbl: UILabel!
	
	
	@IBOutlet weak var PreviousMeetingtxtLbl: UILabel!
	
	
	@IBOutlet weak var PlacestxtLbl: UILabel!
	
	
	
	
@IBOutlet weak var mapView: GMSMapView!
@IBOutlet weak var Fieldvisitoutbtn: UIButton!
@IBOutlet weak var FieldVisitInbtn: UIButton!

@IBOutlet weak var FldvisitFormView: UIView!
@IBOutlet weak var FieldvisitBckview: UIView!
@IBOutlet weak var Cancelbtn: UIButton!
@IBOutlet weak var Submitbrn: UIButton!
@IBOutlet weak var Selectplacelbl: UILabel!
@IBOutlet weak var SelectPlacetxtfld: UITextField!


@IBOutlet weak var ClientView: UIView!
@IBOutlet weak var Contactsubview: UIView!
@IBOutlet weak var ClientTxtfld: UITextField!
@IBOutlet weak var VisitPuposetxtfld: UITextField!
@IBOutlet weak var Adresstxtview: UITextView!
@IBOutlet weak var PreviousTxt: UITextField!
@IBOutlet weak var PreviousMeetingView: UIView!
@IBOutlet weak var DrpDownview: UIView!
@IBOutlet weak var FieldVisit_Popupview: UIView!
@IBOutlet weak var FieldVisitIn_PopupView: UIView!
@IBOutlet weak var SelectPlaceViewconstriant: NSLayoutConstraint!
@IBOutlet weak var SelectPlaceDrptble: UITableView!
var addressString : String = ""
var empAttndInDateTime : String = ""
var empAttndOutDateTime : String = ""
var DestinationInLatlong : String = ""
var DestinationAddress : String = ""
var RetrivedMobileNumber = String()
var Employeenamestr = String()
var FirstLocation = String()
var DestinationLocation = String()
var meetingOutcome = String()
var Inaddress = String()

var OriginLatLong : String = ""
var latstr : String = ""
var longstr : String = ""
var empVisitId = Int()
var RetrivedempVisitId = Int()
var PreviousempVisitId = Int()
	var empVisitSheduleId = Int()
	var SelectedempVisitSheduleId = Int()

var TrackempVisitId = Int()
var timer = Timer()
var RetrivedcustId = Int()
var RetrivedempId = Int()
	var prevVisitId = Int()

//FieldvisitOUT views
var customView = UIView()
var customSubView = UIView()
//FieldVisit IN Views
var customView1 = UIView()
var customSubView1 = UIView()
var ContactLbl = UILabel()
var NameLbl = UILabel()
var MobnumberLbl = UILabel()

var Cantactsubview = UIView()

var SelectPlaceArray:NSMutableArray = NSMutableArray()
var locationManager = CLLocationManager()
override func viewDidLoad() {
	super.viewDidLoad()
	Trackedetails()
	GoogleMapPolyline()
	
	//self.PreviousMeetingView.isHidden = true
	ClientTxtfld.delegate = self
	VisitPuposetxtfld.delegate = self
	//Touch anywhere key board hide method
	dismissKey()
	self.SelectPlaceDrptble.delegate = self
	self.SelectPlaceDrptble.dataSource = self
	FieldVisit_Popupview.isHidden = true
	//    //Field visit - IN and OUT button text color code
	//self.FieldVisitInbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
	self.FieldVisitInbtn.setTitleColor(.lightGray, for: .normal)

	self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
	//self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
	self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)

	self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
	self.SelectPlaceViewconstriant?.constant = 0
	SelectPlaceDrptble.register(UINib(nibName: "SelectplaceDrpdwncell", bundle: nil), forCellReuseIdentifier: "SelectplaceDrpdwncell")
	self.VisitPuposetxtfld.delegate = self
	self.PreviousTxt.delegate = self
	FieldvisitBckview.isHidden = true
	DrpDownview.isHidden = true
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	print("RetrivedcustId----",RetrivedcustId)
	RetrivedempId = defaults.integer(forKey: "empId")
	print("RetrivedempId----",RetrivedempId)
	
	
	
	prevVisitId = UserDefaults.standard.integer(forKey: "empVisitId")
	
	
	//Fieldvisit-Enable-Disable method
	//Fieldvisit_OUT()
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
	SelectPlacetxtfld.isUserInteractionEnabled = true
	SelectPlacetxtfld.addGestureRecognizer(tap)
	
		//Field visit IN disable
	//FieldVisitInbtn.isEnabled = false
	//Key board Hide touch any where
//		let touchtap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//		view.addGestureRecognizer(touchtap)
//
	
	
	//Form Label Text font
	
	PlacestxtLbl.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	
	SelectPlacetxtfld.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	ClientTxtfld.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	VisitPuposetxtfld.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	Adresstxtview.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	PreviousTxt.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
		//key board show and Hide
	NotificationCenter.default.addObserver(self, selector: #selector(FieldVisitVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	NotificationCenter.default.addObserver(self, selector: #selector(FieldVisitVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	
	//Field Visit form Top and Bottom Green line code
	// Creates the bottom border
	let borderBottom = CALayer()
	let borderWidth = CGFloat(2.0)
//		borderBottom.borderColor = (UIColor(red: 204/255.0, green: 255/255.0, blue: 204/255.0, alpha: 1.0) as! UIColor) as! CGColor
//
//
	
	borderBottom.borderColor = #colorLiteral(red: 0.8325170875, green: 0.9924197793, blue: 0.8371630907, alpha: 1)
	borderBottom.frame = CGRect(x: 0, y: FldvisitFormView.frame.height - 1.0, width: FldvisitFormView.frame.width , height: FldvisitFormView.frame.height - 1.0)
	borderBottom.borderWidth = borderWidth
	FldvisitFormView.layer.addSublayer(borderBottom)
	FldvisitFormView.layer.masksToBounds = true

	// Creates the Top border
	let borderTop = CALayer()
	borderTop.borderColor = #colorLiteral(red: 0.8325170875, green: 0.9924197793, blue: 0.8371630907, alpha: 1)
	borderTop.frame = CGRect(x: 0, y: 0, width: FldvisitFormView.frame.width, height: 1)
	borderTop.borderWidth = borderWidth
	FldvisitFormView.layer.addSublayer(borderTop)
	FldvisitFormView.layer.masksToBounds = true

	let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			let now = Date()
			let CurrentdateString = formatter.string(from:now)
			print("CurrentdateStringsecond",CurrentdateString)
			let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": CurrentdateString as Any] as [String : Any]
	
	
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild"
	let urlstring = "\(StartPoint)\(Endpoint1)"
	print("First",urlstring)
	let url = NSURL(string: urlstring)
	
	
	
//			let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
			_ = URLSession.shared
	var request = URLRequest(url: url as! URL)
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
					print("fieldTrackDic responseJSON",responseJSON)
					DispatchQueue.main.async {
						
						
						let statusDic = responseJSON["status"]! as! NSDictionary
						print("statusDic---",statusDic)
						let code = statusDic["code"] as? NSInteger
						print("code-----",code as Any)
						
						if (code == 200)
						
							{
						let path = GMSMutablePath()
						let fieldTrackArray = responseJSON["fieldTrack"] as? [Any]
						for visit in fieldTrackArray! {
							let fieldVisit = visit as? [String:Any]
							let latLongString = fieldVisit!["inLatLong"] as? String
							self.Inaddress = (fieldVisit!["inAddress"] as? String)!
							print("In address values...",self.Inaddress as Any)
							if (self.Inaddress == "NA")
							{
								
								self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
								self.FieldVisitInbtn.setTitleColor(.black, for: .normal)
								self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
								
								self.RetrivedempVisitId = (fieldVisit?["empVisitId"] as? NSInteger)!
	print("RetrivedempVisitId----",self.RetrivedempVisitId)
								self.FieldVisitInbtn.addTarget(self, action: #selector(self.pressINButton(button:)), for: .touchUpInside)
								print("calling first method")

							}
								
								
								else
								{
									self.Fieldvisit_OUT()
									//self.GoogleMapPolyline()


									//self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), for: .normal)
									self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)

									self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
									//Fieldvisit-Enable-Disable method
																		print("calling second method")

									
								}
								
							}
							
							
						}
					
						else
						{
							
							self.Fieldvisit_OUT()
							//self.GoogleMapPolyline()

						}
						
					}
				}
	}
			
			task.resume()
}



//	@objc override func dismissKeyboard() {
//
//		view.endEditing(true)
//	}


//Previous meeting Validations

@objc func actionTextFieldIsEditingChanged(sender: UITextField) {
	if sender.text!.isEmpty {
		// textfield is empty
		print("textfield is empty")
	} else {
		print("text field is not empty")
		Submitbrn.isEnabled = true
		Submitbrn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
		
		// text field is not empty
	}
}

@objc func tapFunction(sender:UITapGestureRecognizer) {
	print("tap working")
	DrpDownview.isHidden = false
	//view.endEditing(true)
	

	
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

	self.locationManager.stopUpdatingLocation()
//		geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//	var placeMark: CLPlacemark!
//        placeMark = placemarks?[0]
//
//        // Location name
//        if let locationName = placeMark.location {
//            print("locationName",locationName)
//        }
//        // Street address
//        if let street = placeMark.thoroughfare {
//            print("street",street)
//        }
//        // City
//        if let city = placeMark.subAdministrativeArea {
//            print("city",city)
//        }
//        // Zip code
//        if let zip = placeMark.isoCountryCode {
//            print("zip",zip)
//        }
//        // Country
//        if let country = placeMark.country {
//            print("country",country)
//        }
//    })
//
	

	geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
		let pm = placemarks! as [CLPlacemark]

		if pm.count > 0 {
			let pm = placemarks![0]
			print(pm.country as Any)
			print(pm.locality as Any)
			print(pm.subLocality as Any)
			print(pm.subAdministrativeArea as Any)
			print(pm.thoroughfare as Any)
			print(pm.postalCode as Any)
			print(pm.subThoroughfare as Any)
//			if pm.subLocality != nil {
//				self.addressString = self.addressString + pm.subLocality! + ", "
//			}
//			if pm.thoroughfare != nil {
//				self.addressString = self.addressString + pm.thoroughfare! + ", "
//			}
			if pm.locality != nil {
				self.addressString = self.addressString + pm.locality! + ", "
			}
//			if pm.subAdministrativeArea != nil {
//				self.addressString = self.addressString + pm.subAdministrativeArea! + ", "
//			}
			
			
			if pm.country != nil {
				self.addressString = self.addressString + pm.country! + ", "
			}
			if pm.postalCode != nil {
				self.addressString = self.addressString + pm.postalCode! + " "
			}
		}
	})
}

	
	
	
	

//Field-visit OUT Enable and Disable
func Fieldvisit_OUT()
{
	
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	RetrivedempId = defaults.integer(forKey: "empId")
	let parameters = ["refCustId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
	
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard"
	let urlstring = "\(StartPoint)\(Endpoint1)"
	print("First",urlstring)
	let url = NSURL(string: urlstring)
	
	
	//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/mobile/app/dashboard/getEmployeeDetailsForDashboard")!
	//create the session object
	let session = URLSession.shared
	//now create the URLRequest object using the url object
	var request = URLRequest(url: url as! URL)
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
			
			let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
			DispatchQueue.main.async
				{
					self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
					self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
					if (self.empAttndInDateTime == "NA" ) {
						//            self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
						//            self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
						
					} else {
						
						if CLLocationManager.locationServicesEnabled(){
							
							if(self.Inaddress == "NA")
							{
							
							
							self.locationManager.delegate = self
							self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
							self.locationManager.distanceFilter = 500
							self.locationManager.requestWhenInUseAuthorization()
							self.locationManager.startUpdatingLocation()
							//UIbutton Action
							self.Fieldvisitoutbtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
							self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
							self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
						}
							else
							{
								
								
								print(" calling polyline dsfsdfsff")
								self.locationManager.delegate = self
								self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
								self.locationManager.distanceFilter = 500
								self.locationManager.requestWhenInUseAuthorization()
								self.locationManager.startUpdatingLocation()
								//UIbutton Action
								self.Fieldvisitoutbtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
								self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)

								self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

								self.GoogleMapPolyline()
							}
						}
						self.mapView.settings.myLocationButton = true
						self.mapView.settings.zoomGestures = true
						self.mapView.animate(toViewingAngle: 45)
						self.mapView.delegate = self
					}
					
					if (self.empAttndOutDateTime == "NA") {
						
					} else {
						self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
						self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
						self.Fieldvisitoutbtn.isEnabled = false
					}
			}
		}
	}
	task.resume()
}
//Dropdown API for Field-Visit form
func selectPlaceDrpdown()
{
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	RetrivedempId = defaults.integer(forKey: "empId")
	let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
	
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getVisitClientPlaceDDList"
	let urlstring = "\(StartPoint)\(Endpoint1)"
	print("First",urlstring)
	let url = NSURL(string: urlstring)
	
	
	//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getVisitClientPlaceDDList")!
	let session = URLSession.shared
	var request = URLRequest(url: url as! URL)
	request.httpMethod = "POST" //set http method as POST
	do {
		request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
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
			let ItemsDict = responseJSON["clientPlaceScheduleList"] as? [String:Any]
			print("Dropdown array sheduled id",responseJSON)
			print("Dropdown array sheduled id...",responseJSON)

			
			DispatchQueue.main.async
				{
					let SelectPlaceArray = responseJSON["clientPlaceScheduleList"] as! NSArray
					for SelectPlaceDic in SelectPlaceArray as! [[String:Any]]
					{
						var MainDict:NSMutableDictionary = NSMutableDictionary()
						var SelectPlacestr = ""
						SelectPlacestr = (SelectPlaceDic["visitClientPlace"] as? String)!
						MainDict.setObject(SelectPlacestr, forKey: "visitClientPlace" as NSCopying)
						
						self.empVisitSheduleId = ((SelectPlaceDic["empVisitSheduleId"] as? Int)!)
						print("empVisitSheduleId...",self.empVisitSheduleId)
						
						
						MainDict.setObject(self.empVisitSheduleId, forKey: "empVisitSheduleId" as NSCopying)
						
						self.SelectPlaceArray.add(MainDict)
						
					}
					//self.SelectPlaceDrptble.reloadData()
			}
		}
	}
	task.resume()
}





func FieldvisitFormsubmitAPI()
{
	
	locationManager.requestWhenInUseAuthorization()
	var currentLoc: CLLocation!
	if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
	CLLocationManager.authorizationStatus() == .authorizedAlways) {
	   currentLoc = locationManager.location
	   print("Outlatlong values",currentLoc.coordinate.latitude)
	   print("Outlatlong values",currentLoc.coordinate.longitude)
		let OutLatLnglocation = CLLocation(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)

		let locationData = NSKeyedArchiver.archivedData(withRootObject: OutLatLnglocation)
		UserDefaults.standard.set(locationData, forKey: "locationDatavalues")
		print("Outlatlangvalues",locationData)

	print("previous id value ",PreviousempVisitId)
		print("Retrived SelectedempVisitSheduleId",SelectedempVisitSheduleId)
	print("Retrived Stored empVisitId",prevVisitId)

	
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	RetrivedempId = defaults.integer(forKey: "empId")
	let latlanstr = latstr + ", " + longstr
	print("latlanstr..",latlanstr)
		let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"outFromLatLong": latlanstr as Any,"outFromAddress":Adresstxtview.text,"toClientNamePlace":ClientTxtfld.text,"visitPurpose":VisitPuposetxtfld.text,"prevVisitId":prevVisitId,"meetingOutcome":PreviousTxt.text,"empVisitScheduleId":SelectedempVisitSheduleId] as [String : Any]
		
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertFieldVisitOutDetailsWithScheduleId"
		let urlstring = "\(StartPoint)\(Endpoint1)"
		print("First",urlstring)
		let url = NSURL(string: urlstring)
		
	
	//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertFieldVisitOutDetailsWithScheduleId")!
	let session = URLSession.shared
		var request = URLRequest(url: url as! URL)
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
		
		print("insertFieldVisitOutDetailsWithScheduleId",responseJSON)
		if let responseJSON = responseJSON as? [String: Any] {
			self.empVisitId = Int()
			self.empVisitId = (responseJSON["empVisitId"] as? NSInteger)!
			
			
			UserDefaults.standard.set(self.empVisitId, forKey: "empVisitId") //setObject
			self.empVisitId = UserDefaults.standard.integer(forKey: "empVisitId")
			print("Stored empVisitId",self.empVisitId)
			
			
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
				self.scheduledTimerWithTimeInterval()
				DispatchQueue.main.async {
					let statusDic = responseJSON["status"]! as! NSDictionary
					let code = statusDic["code"] as! NSInteger
					if(code == 200)
					{
						
						let message = statusDic["message"] as! NSString
						//Leave PopUp method calling
						
						//self.PopUpView.isHidden = false
						
						self.FieldVisit_Popupview.isHidden = false
						
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
	}
	task.resume()
	
}
}

func FieldvisitOUT_PopUp()
{
	
	self.customView.frame = CGRect.init(x: 50, y: 50, width: 230, height: 300)
	self.customView.backgroundColor = UIColor.white
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
	//label1.text = "\("Visit In") \(message)"
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
	myButton.addTarget(self, action: #selector(self.FieldVisitOutPop_Okbtnclk(_:)), for: .touchUpInside)
	self.customView.addSubview(myButton)
	
	
}

@objc func FieldVisitOutPop_Okbtnclk(_ sender:UIButton!)
{
	print("ok button click")
	FieldvisitBckview.isHidden = true
	customView.isHidden = true
	
}





//tableview Delegate methods
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return self.SelectPlaceArray.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let drpcell = tableView.dequeueReusableCell(withIdentifier: "SelectplaceDrpdwncell", for: indexPath) as! SelectplaceDrpdwncell
	var responseDict = self.SelectPlaceArray[indexPath.row] as! NSMutableDictionary
	var maindata = SelectPlaceArray[indexPath.row]
	var Selectplacestr : String?
	Selectplacestr = responseDict["visitClientPlace"] as? String
	
	empVisitSheduleId = ((responseDict["empVisitSheduleId"] as? Int)!)
	
	
	drpcell.selectPlacedrpLbl!.text = Selectplacestr
	drpcell.selectPlacedrpLbl!.textColor = #colorLiteral(red: 0.2414736675, green: 0.2414736675, blue: 0.2414736675, alpha: 1)
	

	return drpcell
	
}

// method to run when table view cell is tapped
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	
	let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
	view.addGestureRecognizer(tap)
	tap.cancelsTouchesInView = false
	let drpcell = tableView.dequeueReusableCell(withIdentifier: "SelectplaceDrpdwncell", for: indexPath) as! SelectplaceDrpdwncell
	var responseDict = self.SelectPlaceArray[indexPath.row] as! NSMutableDictionary
	var maindata = SelectPlaceArray[indexPath.row]
	var Selectplacestr : String?
	Selectplacestr = responseDict["visitClientPlace"] as? String
	drpcell.selectPlacedrpLbl!.text = Selectplacestr
	SelectPlacetxtfld.text = Selectplacestr
	
	SelectedempVisitSheduleId = ((responseDict["empVisitSheduleId"] as? Int)!)
	
	
	DrpDownview.isHidden = true
	
	if (drpcell.selectPlacedrpLbl.text == "Others")
	{
		ClientTxtfld.isHidden = false
		ContactLbl.isHidden = true
		NameLbl.isHidden = true
		MobnumberLbl.isHidden = true
		Cantactsubview.isHidden = true
		ClientView.backgroundColor = UIColor.white
		ClientTxtfld.backgroundColor = UIColor.white
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.SelectPlaceViewconstriant?.constant = 45
			self.view.layoutIfNeeded()
		}, completion: nil)
		
	}
	else
	{
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.SelectPlaceViewconstriant?.constant = 0
			self.view.layoutIfNeeded()
		}, completion: nil)

	}
	
	
	 if(drpcell.selectPlacedrpLbl.text == "SH5")
	{
		ClientTxtfld.isHidden = true
		Cantactsubview.isHidden = false

		ClientView.backgroundColor = UIColor.clear
		ContactLbl = UILabel(frame: CGRect(x: 0, y: 5, width: 320, height: 23))
		//label.center = CGPoint(x: 160, y: 284)
		ContactLbl.textAlignment = NSTextAlignment.left
		ContactLbl.text = "Catact details"
		ContactLbl.backgroundColor = UIColor.clear
		let defaults = UserDefaults.standard
		
		Employeenamestr = defaults.string(forKey: "employeeName") ?? ""
		//        UserNameLbl.text = Employeenamestr
		RetrivedMobileNumber = UserDefaults.standard.string(forKey: "Mobilenum") ?? ""
		
		NameLbl = UILabel(frame: CGRect(x: 5, y: 3, width: 320, height: 23))
		NameLbl.textAlignment = NSTextAlignment.left
		NameLbl.text = Employeenamestr
		NameLbl.textColor = UIColor.lightGray
		NameLbl.backgroundColor = UIColor.clear
		MobnumberLbl = UILabel(frame: CGRect(x: 5, y: 30, width: 320, height: 23))
		MobnumberLbl.textAlignment = NSTextAlignment.left
		MobnumberLbl.text = RetrivedMobileNumber
		MobnumberLbl.textColor = UIColor.lightGray
		MobnumberLbl.backgroundColor = UIColor.clear
		Cantactsubview.frame = CGRect.init(x: 0, y: 30, width: 322, height: 60)
		Cantactsubview.backgroundColor = UIColor.white     //give color to the view
		Cantactsubview.layer.borderColor = UIColor.gray.cgColor
		Cantactsubview.layer.borderWidth = 1.0
		//Cantactsubview.center = self.view.center
		//self.ClientView.addSubview(Cantactsubview)
		self.ClientView.addSubview(Cantactsubview)

		self.ClientView.addSubview(ContactLbl)
		self.Cantactsubview.addSubview(NameLbl)
		self.Cantactsubview.addSubview(MobnumberLbl)


		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.SelectPlaceViewconstriant?.constant = 80
			self.view.layoutIfNeeded()
		}, completion: nil)

	}
	else
	{

		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.SelectPlaceViewconstriant?.constant = 45
			self.view.layoutIfNeeded()
		}, completion: nil)

	}

	
	
	
}
@objc func pressButton(button: UIButton) {
	NSLog("pressed!")
	
	
	if (Adresstxtview.text == "")
	{
	print("nillvalues---",addressString)
	Adresstxtview.text = addressString
	}
	else
	{
		print("not nill")
		
	}

	
	self.ClientView.setNeedsLayout()
	self.ClientView.layoutIfNeeded()
	self.ClientTxtfld.setNeedsLayout()
	self.ClientTxtfld.layoutIfNeeded()

	self.FieldvisitBckview.isHidden = false
	
	//SelectPlacetxtfld.text?.removeAll()
	ClientTxtfld.text?.removeAll()
	VisitPuposetxtfld.text?.removeAll()
	PreviousTxt.text?.removeAll()
	
	DispatchQueue.main.async {
		
		if(self.SelectPlacetxtfld.text == "")
		{
			self.viewDidLoad()
			
			self.SelectPlaceDrptble.reloadData()
			self.FieldvisitBckview.isHidden = false
			
		}
		else
		{
			
		}
		
		
	}}
	
	
	
@IBAction func Cancelbtnclk(_ sender: Any) {
	
	
	SelectPlacetxtfld.text?.removeAll()
	ClientTxtfld.text?.removeAll()
	VisitPuposetxtfld.text?.removeAll()
	PreviousTxt.text?.removeAll()
	
	Adresstxtview.text?.removeAll()
	//Adresstxtview.text = addressString
	
	FieldvisitBckview.isHidden = true
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
{
	ClientTxtfld.resignFirstResponder()
	VisitPuposetxtfld.resignFirstResponder()
	PreviousTxt.resignFirstResponder()
	return true;
}


@objc func FieldVisitInbtnclick(_ sender:UIButton!)
{
	self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
	self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)}
@IBAction func FieldvisitOUT_Submitbtnclk(_ sender: Any) {
	
	if (SelectPlacetxtfld.text == ""){
               let alert = UIAlertController(title: "Error", message: "Please choose select place", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
               return
           }
            if (VisitPuposetxtfld.text == ""){
                   let alert = UIAlertController(title: "Error", message: "Please Enter Visit Purpose", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   return
               }

           else {
            

			
			FieldvisitFormsubmitAPI()
			self.FieldVisitInbtn.setTitleColor(.black, for: .normal)
			self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
			FieldVisitInbtn.isEnabled = true
			Fieldvisitoutbtn.isEnabled = false
			//self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
				
				self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)

			self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
			self.FieldVisitInbtn.addTarget(self, action: #selector(self.pressINButton(button:)), for: .touchUpInside)
			        }
        
    

	
}

@IBAction func OkBtnclk(_ sender: Any) {
	FieldvisitBckview.isHidden = true
	FieldVisit_Popupview.isHidden = true
	
}


//Field-Visit IN update API
@objc func pressINButton(button: UIButton) {
	
	if(Inaddress == "NA")
	{
		
		
		locationManager.requestWhenInUseAuthorization()
		var currentLoc: CLLocation!
		if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
		CLLocationManager.authorizationStatus() == .authorizedAlways) {
		   currentLoc = locationManager.location
		   print("lattitude..",currentLoc.coordinate.latitude)
		   print("longitude..",currentLoc.coordinate.longitude)
			let Inlatstr = String(currentLoc.coordinate.latitude)
			let Inlongstr = String(currentLoc.coordinate.longitude)
		let Inlatlanstr = Inlatstr + ", " + Inlongstr

		
		let defaults = UserDefaults.standard
				RetrivedcustId = defaults.integer(forKey: "custId")
				RetrivedempId = defaults.integer(forKey: "empId")
				//let latlanstr = latstr + ", " + longstr
				
				print("Update latlanstr",Inlatlanstr)
				print("empVisitId---",empVisitId)
				let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"empVisitId": RetrivedempVisitId as Any,"inLatLong": Inlatlanstr as Any,"inAddress":addressString as Any]
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/updateFieldVisitInDetails"
		let urlstring = "\(StartPoint)\(Endpoint1)"
		print("First",urlstring)
		let url = NSURL(string: urlstring)

		
				
				//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/updateFieldVisitInDetails")!
				let session = URLSession.shared
		var request = URLRequest(url: url as! URL)
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
					
					print("timer update Response---",responseJSON)
					if let responseJSON = responseJSON as? [String: Any] {
						//self.scheduledTimerWithTimeInterval()
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//							self.scheduledTimerWithTimeInterval()
							DispatchQueue.main.async {
						//self.scheduledTimerWithTimeInterval()

						//self.insertTrackFieldVisit_updateCounting()
								
								let statusDic = responseJSON["status"]! as! NSDictionary
								let code = statusDic["code"] as! NSInteger
								if(code == 200)
								{
									//self.scheduledTimerWithTimeInterval()
									self.mapView.addSubview(self.self.FieldVisitIn_PopupView)
									self.FieldVisitIn_PopupView.isHidden = false
								}
									
								else
								{
		//							let message = responseJSON["message"]! as! NSString
		//							let alert = UIAlertController(title: "Alert", message: message as String, preferredStyle: UIAlertController.Style.alert)
		//							alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
		//							self.present(alert, animated: true, completion: nil)
								}
							}
						}
						
					}
				}
		
				task.resume()
		
	}
	}
	else
	{
		
		locationManager.requestWhenInUseAuthorization()
		var currentLoc: CLLocation!
		if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
		CLLocationManager.authorizationStatus() == .authorizedAlways) {
		   currentLoc = locationManager.location
		   print("lattitude..",currentLoc.coordinate.latitude)
		   print("longitude..",currentLoc.coordinate.longitude)
			let Inlatstr = String(currentLoc.coordinate.latitude)
			let Inlongstr = String(currentLoc.coordinate.longitude)
		let Inlatlanstr = Inlatstr + ", " + Inlongstr

		let defaults = UserDefaults.standard
				RetrivedcustId = defaults.integer(forKey: "custId")
				RetrivedempId = defaults.integer(forKey: "empId")
				//let latlanstr = latstr + ", " + longstr
				
				print("timer 1 Update latlanstr",Inlatlanstr)
				print("empVisitId---",empVisitId)
//				let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"empVisitId": empVisitId as Any,"inLatLong": latlanstr as Any,"inAddress":addressString as Any,"kmTravelled":""] as [String : Any]
		
		let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"empVisitId": empVisitId as Any,"inLatLong": Inlatlanstr as Any,"inAddress":addressString as Any]
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/updateFieldVisitInDetails"
		let urlstring = "\(StartPoint)\(Endpoint1)"
		print("First",urlstring)
		let url = NSURL(string: urlstring)

		
				
				//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/updateFieldVisitInDetails")!
				let session = URLSession.shared
		var request = URLRequest(url: url as! URL)
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
					
					print("update Response---",responseJSON)
					if let responseJSON = responseJSON as? [String: Any] {
						//self.scheduledTimerWithTimeInterval()
						
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
							//self.scheduledTimerWithTimeInterval()
							DispatchQueue.main.async {
								//self.insertTrackFieldVisit_updateCounting()
								
								let statusDic = responseJSON["status"]! as! NSDictionary
								let code = statusDic["code"] as! NSInteger
								if(code == 200)
								{
									self.insertTrackFieldVisit_updateCounting()

									//self.scheduledTimerWithTimeInterval()
									self.mapView.addSubview(self.self.FieldVisitIn_PopupView)
									self.FieldVisitIn_PopupView.isHidden = false
								}
								else
								{
		//							let message = responseJSON["message"]! as! NSString
		//							let alert = UIAlertController(title: "Alert", message: message as String, preferredStyle: UIAlertController.Style.alert)
		//							alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
		//							self.present(alert, animated: true, completion: nil)
								}
							}
						}
						
					}
				}
				task.resume()
		
	}
	}
	
}

//Background Location method
func scheduledTimerWithTimeInterval(){
	
	timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.insertTrackFieldVisit_updateCounting), userInfo: nil, repeats: true)
}

//Background calling API
	
	@objc func insertTrackFieldVisit_updateCounting()
	{
			let previousLocationEncoded = UserDefaults.standard.object(forKey: "locationDatavalues") as? Data
				let previousLocationDecoded = NSKeyedUnarchiver.unarchiveObject(with: previousLocationEncoded!) as! CLLocation
				print("sddsfsfsfs",previousLocationDecoded)
				
				if let loadedData = UserDefaults.standard.data(forKey: "locationDatavalues")
				{
					if let loadedLocation = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? CLLocation {
						print("First Location Lat",loadedLocation.coordinate.latitude)
						print("First Location long",loadedLocation.coordinate.longitude)
						locationManager.requestWhenInUseAuthorization()
						
					
				let FirstLacoationLat1 = (loadedLocation.coordinate.latitude)
				let FirstLacoationLng1 = (loadedLocation.coordinate.longitude)
							//"outFromLatLong": "15.225391290164756, 78.31401312731046",
						var currentLoc: CLLocation!
						if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
						CLLocationManager.authorizationStatus() == .authorizedAlways) {
							currentLoc = self.locationManager.location
						   print("SecondLocation",currentLoc.coordinate.latitude)
						   print("SecondLocation",currentLoc.coordinate.longitude)
							let SecondLocationLat2 = (currentLoc.coordinate.latitude)
							let SecondLocationLng2 = (currentLoc.coordinate.longitude)
							var DestinationLocation = CLLocation(latitude: SecondLocationLat2, longitude: SecondLocationLng2)
							print("Destination Latlong values",DestinationLocation)


				let currentLocation = CLLocation(latitude: FirstLacoationLat1, longitude: FirstLacoationLng1)
				var distance = currentLocation.distance(from: DestinationLocation) / 1000
					//var distance = previousLocationDecoded.distance(from: DestinationLocation) * 0.000621371
				//print(String(format: "The distance to my buddy is %.01fkm", distance))
	//			let defaults = UserDefaults.standard
	//			RetrivedcustId = defaults.integer(forKey: "custId")
	//			RetrivedempId = defaults.integer(forKey: "empId")
	//			let latlanstr = latstr + ", " + longstr
	//
							locationManager.requestWhenInUseAuthorization()
							var currentLoc: CLLocation!
							if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
							CLLocationManager.authorizationStatus() == .authorizedAlways) {
							   currentLoc = locationManager.location
							   print("lattitude..",currentLoc.coordinate.latitude)
							   print("longitude..",currentLoc.coordinate.longitude)
								let Inlatstr = String(currentLoc.coordinate.latitude)
								let Inlongstr = String(currentLoc.coordinate.longitude)
							let Inlatlanstr = Inlatstr + ", " + Inlongstr

							
							
				
				print("Background latlanstr...",Inlatlanstr)
				let formatter = DateFormatter()
				//2016-12-08 03:37:22 +0000
				//formatter.dateFormat = "yyyy-MM-dd"
				formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
				let now = Date()
				let CurrentdateString = formatter.string(from:now)
				print("CurrentdateString",CurrentdateString)
				
				let parameters = [["custId": RetrivedcustId ,"empId": RetrivedempId,"empVisitId": RetrivedempVisitId,"trackDateTime": CurrentdateString,"trackLatLong":Inlatlanstr, "trackAddress":addressString, "trackDistance":  distance,"trackBattery":"99"] as [String : Any]]
							
							
							var StartPoint = Baseurl.shared().baseURL
							var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit"
							let urlstring = "\(StartPoint)\(Endpoint1)"
							print("First",urlstring)
							let url = NSURL(string: urlstring)
							
				
				//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit")!
				//create the session object
				let session = URLSession.shared
							var request = URLRequest(url: url as! URL)
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
					
					print("insertTrackFieldVisit---",responseJSON)
					if let responseJSON = responseJSON as? [String: Any] {
						DispatchQueue.main.async
							{
								
								self.Trackedetails()

						}
						}
						
					
					
					
				}
				task.resume()
				
			}
				}
				}
		}
	}
		
	
	
//@objc func insertTrackFieldVisit_updateCounting(){
//
//
//	if (Inaddress == "NA")
//	{
//		let previousLocationEncoded = UserDefaults.standard.object(forKey: "locationDatavalues") as? Data
//			let previousLocationDecoded = NSKeyedUnarchiver.unarchiveObject(with: previousLocationEncoded!) as! CLLocation
//			print("sddsfsfsfs",previousLocationDecoded)
//
//			if let loadedData = UserDefaults.standard.data(forKey: "locationDatavalues")
//			{
//				if let loadedLocation = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? CLLocation {
//					print("First Location Lat",loadedLocation.coordinate.latitude)
//					print("First Location long",loadedLocation.coordinate.longitude)
//					locationManager.requestWhenInUseAuthorization()
//
//
//			let FirstLacoationLat1 = (loadedLocation.coordinate.latitude)
//			let FirstLacoationLng1 = (loadedLocation.coordinate.longitude)
//						//"outFromLatLong": "15.225391290164756, 78.31401312731046",
//					var currentLoc: CLLocation!
//					if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//					CLLocationManager.authorizationStatus() == .authorizedAlways) {
//						currentLoc = self.locationManager.location
//					   print("SecondLocation",currentLoc.coordinate.latitude)
//					   print("SecondLocation",currentLoc.coordinate.longitude)
//						let SecondLocationLat2 = (currentLoc.coordinate.latitude)
//						let SecondLocationLng2 = (currentLoc.coordinate.longitude)
//						var DestinationLocation = CLLocation(latitude: SecondLocationLat2, longitude: SecondLocationLng2)
//						print("Destination Latlong values",DestinationLocation)
//
//
//			let currentLocation = CLLocation(latitude: FirstLacoationLat1, longitude: FirstLacoationLng1)
//			var distance = currentLocation.distance(from: DestinationLocation) / 1000
//				//var distance = previousLocationDecoded.distance(from: DestinationLocation) * 0.000621371
//			//print(String(format: "The distance to my buddy is %.01fkm", distance))
////			let defaults = UserDefaults.standard
////			RetrivedcustId = defaults.integer(forKey: "custId")
////			RetrivedempId = defaults.integer(forKey: "empId")
////			let latlanstr = latstr + ", " + longstr
////
//						locationManager.requestWhenInUseAuthorization()
//						var currentLoc: CLLocation!
//						if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//						CLLocationManager.authorizationStatus() == .authorizedAlways) {
//						   currentLoc = locationManager.location
//						   print("lattitude..",currentLoc.coordinate.latitude)
//						   print("longitude..",currentLoc.coordinate.longitude)
//							let Inlatstr = String(currentLoc.coordinate.latitude)
//							let Inlongstr = String(currentLoc.coordinate.longitude)
//						let Inlatlanstr = Inlatstr + ", " + Inlongstr
//
//
//
//
//			print("Background latlanstr...",Inlatlanstr)
//			let formatter = DateFormatter()
//			//2016-12-08 03:37:22 +0000
//			//formatter.dateFormat = "yyyy-MM-dd"
//			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//			let now = Date()
//			let CurrentdateString = formatter.string(from:now)
//			print("CurrentdateString",CurrentdateString)
//
//			let parameters = [["custId": RetrivedcustId ,"empId": RetrivedempId,"empVisitId": RetrivedempVisitId,"trackDateTime": CurrentdateString,"trackLatLong":Inlatlanstr, "trackAddress":addressString, "trackDistance":  distance,"trackBattery":"99"] as [String : Any]]
//
//
//						var StartPoint = Baseurl.shared().baseURL
//						var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit"
//						let urlstring = "\(StartPoint)\(Endpoint1)"
//						print("First",urlstring)
//						let url = NSURL(string: urlstring)
//
//
//			//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit")!
//			//create the session object
//			let session = URLSession.shared
//						var request = URLRequest(url: url as! URL)
//			request.httpMethod = "POST" //set http method as POST
//			do {
//				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//			} catch let error {
//				print(error.localizedDescription)
//			}
//			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//			request.addValue("application/json", forHTTPHeaderField: "Accept")
//			let task = URLSession.shared.dataTask(with: request) { data, response, error in
//				guard let data = data, error == nil else {
//					print(error?.localizedDescription ?? "No data")
//					return
//				}
//				let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//				print("insertTrackFieldVisit---",responseJSON)
//				if let responseJSON = responseJSON as? [String: Any] {
//					DispatchQueue.main.async
//						{
//
//							self.Trackedetails()
//
//					}
//					}
//
//
//
//
//			}
//			task.resume()
//
//		}
//			}
//			}
//
//	}
//	}
//
//	else
//	{
//		let previousLocationEncoded = UserDefaults.standard.object(forKey: "locationDatavalues") as? Data
//			let previousLocationDecoded = NSKeyedUnarchiver.unarchiveObject(with: previousLocationEncoded!) as! CLLocation
//			print("sddsfsfsfs",previousLocationDecoded)
//
//			if let loadedData = UserDefaults.standard.data(forKey: "locationDatavalues")
//			{
//				if let loadedLocation = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? CLLocation {
//					print("First Location Lat",loadedLocation.coordinate.latitude)
//					print("First Location long",loadedLocation.coordinate.longitude)
//					locationManager.requestWhenInUseAuthorization()
//
//
//			let FirstLacoationLat1 = (loadedLocation.coordinate.latitude)
//			let FirstLacoationLng1 = (loadedLocation.coordinate.longitude)
//						//"outFromLatLong": "15.225391290164756, 78.31401312731046",
//					var currentLoc: CLLocation!
//					if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//					CLLocationManager.authorizationStatus() == .authorizedAlways) {
//						currentLoc = self.locationManager.location
//					   print("SecondLocation",currentLoc.coordinate.latitude)
//					   print("SecondLocation",currentLoc.coordinate.longitude)
//						let SecondLocationLat2 = (currentLoc.coordinate.latitude)
//						let SecondLocationLng2 = (currentLoc.coordinate.longitude)
//						var DestinationLocation = CLLocation(latitude: SecondLocationLat2, longitude: SecondLocationLng2)
//						print("Destination Latlong values",DestinationLocation)
//
//
//			let currentLocation = CLLocation(latitude: FirstLacoationLat1, longitude: FirstLacoationLng1)
//			var distance = currentLocation.distance(from: DestinationLocation) / 1000
//				//var distance = previousLocationDecoded.distance(from: DestinationLocation) * 0.000621371
//			//print(String(format: "The distance to my buddy is %.01fkm", distance))
////			let defaults = UserDefaults.standard
////			RetrivedcustId = defaults.integer(forKey: "custId")
////			RetrivedempId = defaults.integer(forKey: "empId")
////			let latlanstr = latstr + ", " + longstr
//
//
//
//						locationManager.requestWhenInUseAuthorization()
//						var currentLoc: CLLocation!
//						if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//						CLLocationManager.authorizationStatus() == .authorizedAlways) {
//						   currentLoc = locationManager.location
//						   print("lattitude..",currentLoc.coordinate.latitude)
//						   print("longitude..",currentLoc.coordinate.longitude)
//							let Inlatstr = String(currentLoc.coordinate.latitude)
//							let Inlongstr = String(currentLoc.coordinate.longitude)
//						let Inlatlanstr = Inlatstr + ", " + Inlongstr
//
//			print("Background latlanstr...",Inlatlanstr)
//			let formatter = DateFormatter()
//			//2016-12-08 03:37:22 +0000
//			//formatter.dateFormat = "yyyy-MM-dd"
//			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//			let now = Date()
//			let CurrentdateString = formatter.string(from:now)
//			print("CurrentdateString",CurrentdateString)
//
//			let parameters = [["custId": RetrivedcustId ,"empId": RetrivedempId,"empVisitId": empVisitId,"trackDateTime": CurrentdateString,"trackLatLong":Inlatlanstr, "trackAddress":addressString, "trackDistance":  distance,"trackBattery":"99"] as [String : Any]]
//
//						var StartPoint = Baseurl.shared().baseURL
//						var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit"
//						let urlstring = "\(StartPoint)\(Endpoint1)"
//						print("First",urlstring)
//						let url = NSURL(string: urlstring)
//
//			//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit")!
//			//create the session object
//			let session = URLSession.shared
//						var request = URLRequest(url: url as! URL)
//			request.httpMethod = "POST" //set http method as POST
//			do {
//				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//			} catch let error {
//				print(error.localizedDescription)
//			}
//			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//			request.addValue("application/json", forHTTPHeaderField: "Accept")
//			let task = URLSession.shared.dataTask(with: request) { data, response, error in
//				guard let data = data, error == nil else {
//					print(error?.localizedDescription ?? "No data")
//					return
//				}
//				let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//				print("insertTrackFieldVisit---",responseJSON)
//				if let responseJSON = responseJSON as? [String: Any] {
//					DispatchQueue.main.async
//						{
//
//					}
//					}
//
//			}
//			task.resume()
//
//		}
//			}
//			}
//
//	}
//
//
//	}
//}
	//FieldVisit IN OK Button Code

@IBAction func FieldVisit_InOkbtnclk(_ sender: Any) {
	
	FieldVisitIn_PopupView.isHidden = true
	FieldVisitInbtn.isEnabled = false
	Fieldvisitoutbtn.isEnabled = true
	self.FieldVisitInbtn.setTitleColor(.lightGray, for: .normal)
	self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
	self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)
	self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
	
	Trackedetails()
}

func Trackedetails()
{
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	RetrivedempId = defaults.integer(forKey: "empId")
	let formatter = DateFormatter()
	//2016-12-08 03:37:22 +0000
	//formatter.dateFormat = "yyyy-MM-dd"
	formatter.dateFormat = "yyyy-MM-dd"
	
	let now = Date()
	let Datestr = formatter.string(from:now)
	print("Datestr",Datestr)
	
	let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": Datestr as Any] as [String : Any]
	
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild"
	let urlstring = "\(StartPoint)\(Endpoint1)"
	print("First",urlstring)
	let url = NSURL(string: urlstring)
	
	//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
	//create the session object
	let session = URLSession.shared
	//now create the URLRequest object using the url object
	var request = URLRequest(url: url as! URL)
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
			print("fieldTrackDic responseJSON",responseJSON)
			DispatchQueue.main.async
				{
					
					let statusDic = responseJSON["status"]! as! NSDictionary
					print("statusDic---",statusDic)
					let code = statusDic["code"] as? NSInteger
					print("code-----",code as Any)
					
					if (code == 200)
					
						{
							self.PreviousMeetingView.isHidden = false
							//visit Purpose textfield validation
							self.PreviousTxt.addTarget(self, action: #selector(self.actionTextFieldIsEditingChanged), for: UIControl.Event.editingChanged)
							self.Submitbrn.isEnabled = false
							self.Submitbrn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.6487585616, blue: 0.06666666667, alpha: 0.2948148545)


							
							let fieldTrackArray = responseJSON["fieldTrack"] as! NSArray
							for Field_trackDic in fieldTrackArray as! [[String:Any]]
							{
							var MainDict:NSMutableDictionary = NSMutableDictionary()
							var Field_trackstr = ""
							Field_trackstr = (Field_trackDic["toClientNamePlace"] as? String)!
							
							var OriginAddress = ""
							OriginAddress = (Field_trackDic["outFromAddress"] as? String)!
							let LanlongArray:NSMutableArray = NSMutableArray()
							var DestinationAddress = ""
							DestinationAddress = (Field_trackDic["inAddress"] as? String)!
							print(" DestinationAddress.....",DestinationAddress)
							self.self.DestinationInLatlong = (Field_trackDic["inLatLong"] as? String)!
							MainDict.setObject(self.DestinationInLatlong, forKey: "inLatLong" as NSCopying)
							print("DestinationInLatlong.....",self.DestinationInLatlong)
							LanlongArray.add(MainDict)
							print("LanlongArray----",LanlongArray)
							self.meetingOutcome = (Field_trackDic["meetingOutcome"] as? String)!
							print("meetingOutcome...",self.meetingOutcome)
							self.RetrivedempVisitId = (Field_trackDic["empVisitId"] as? NSInteger)!
							
							
							print("RetrivedempVisitId----",self.RetrivedempVisitId)
							
							//var a = 1
								self.PreviousempVisitId = 1
								self.PreviousempVisitId = self.RetrivedempVisitId-self.PreviousempVisitId
								print("Decrement value",self.PreviousempVisitId)


							
							
							let clean = self.DestinationInLatlong.replacingOccurrences(of: "[\\[\\] ]", with: "", options: .regularExpression, range: nil)
							let values = clean.components(separatedBy: ",")
							var coords = [CLLocation]()
							for i in stride(from: 0, to: values.count, by: 2) {
								if let lat = Double(values[i]),
									let long = Double(values[i+1]) {
									let coord = CLLocation(latitude: lat, longitude: long)
									coords.append(coord)
									let marker = GMSMarker()
									let newPosition = CLLocationCoordinate2D(latitude: lat, longitude: long)
									marker.position = newPosition
									marker.title = DestinationAddress
									
									marker.map = self.mapView
									print("Latlongs...",coord)
									print("Latlong...",coords.append(coord))
								}
							}
							
							
							self.TrackempVisitId = (Field_trackDic["empVisitId"] as? NSInteger)!
							print("TrackempVisitId----",self.TrackempVisitId)
							let fieldVisitTrackDetailsArray = Field_trackDic["fieldVisitTrackDetails"] as! NSArray
							print("fieldVisitTrackDetails--",fieldVisitTrackDetailsArray)
						}
							
					}
					else
					{
						self.PreviousMeetingView.isHidden = true
						
						//visit Purpose textfield validation
						self.VisitPuposetxtfld.addTarget(self, action: #selector(self.actionTextFieldIsEditingChanged), for: UIControl.Event.editingChanged)
						self.Submitbrn.isEnabled = false
						self.Submitbrn.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.6487585616, blue: 0.06666666667, alpha: 0.2948148545)

					}
					
			}
		}
	}
	task.resume()
}
func GoogleMapPolyline()
{
	PolylineAPI()
}

func PolylineAPI()
{
	
	let defaults = UserDefaults.standard
	RetrivedcustId = defaults.integer(forKey: "custId")
	RetrivedempId = defaults.integer(forKey: "empId")
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
	let now = Date()
	let CurrentdateString = formatter.string(from:now)
	print("CurrentdateStringsecond",CurrentdateString)
	let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": CurrentdateString as Any] as [String : Any]
	
	var StartPoint = Baseurl.shared().baseURL
	var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild"
	let urlstring = "\(StartPoint)\(Endpoint1)"
	print("First",urlstring)
	let url = NSURL(string: urlstring)
	
	//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
	_ = URLSession.shared
	var request = URLRequest(url: url as! URL)
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
			print("fieldTrackDic responseJSON",responseJSON)
			DispatchQueue.main.async {
				let path = GMSMutablePath()
				let fieldTrackArray = responseJSON["fieldTrack"] as? [Any]
				for visit in fieldTrackArray! {
					let fieldVisit = visit as? [String:Any]
					let latLongString = fieldVisit!["inLatLong"] as? String
					self.Inaddress = (fieldVisit!["inAddress"] as? String)!
					print("In address values...",self.Inaddress as Any)
					
//					for (index, name) in fieldTrackArray!
//						.enumerated()
//					{
//						//YOUR LOGIC....
//						print("Index values",name)
//						print("Index Integer numbers values..",index)//0, 1, 2, 3 ...
//					//}
					
					let latLong = latLongString?.components(separatedBy: ",")
					let latitude = Double(latLong![0].replacingOccurrences(of: " ", with: ""))
					let longitude = Double(latLong![1].replacingOccurrences(of: " ", with: ""))
					path.add(CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
					
					let marker = GMSMarker()
					marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
						marker.title = self.Inaddress
					
					//print("addressString....",self.addressString)
					//marker.snippet = "India"
					
					let labelMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
						
//						let Indexstrnumbers = String(index)
//						print("Indexstrnumbers",Indexstrnumbers)

					
					marker.map = self.mapView
				//}
				
				let polyline = GMSPolyline(path: path)
				polyline.strokeColor = .blue
				polyline.strokeWidth = 1.0
				polyline.spans = [GMSStyleSpan(color: .blue)]
				polyline.map = self.mapView
				
			}
		}}
	}
	task.resume()
}



@objc func keyboardWillShow(sender: NSNotification) {
	 self.view.frame.origin.y = -200 // Move view 150 points upward
}

@objc func keyboardWillHide(sender: NSNotification) {
	 self.view.frame.origin.y = 0 // Move view to original position
}
//	@objc func keyboardWillShow(notification: Notification) {
//
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            print("notification: Keyboard will show")
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }

}








