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

	
	
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var Fieldvisitoutbtn: UIButton!
	@IBOutlet weak var FieldVisitInbtn: UIButton!
	
	@IBOutlet weak var FldvisitFormView: UIView!
	@IBOutlet weak var FieldvisitBckview: UIView!
	@IBOutlet weak var Cancelbtn: UIButton!
	@IBOutlet weak var Submitbrn: UIButton!
	@IBOutlet weak var Selectplacelbl: UILabel!
	
	
	@IBOutlet weak var ClientView: UIView!
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
	
	
	var OriginLatLong : String = ""
	var latstr : String = ""
	var longstr : String = ""
	var empVisitId = Int()
	var TrackempVisitId = Int()
	var timer = Timer()
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
		ClientTxtfld.delegate = self
		VisitPuposetxtfld.delegate = self

		
		//Touch anywhere key board hide method
		dismissKey()
		self.SelectPlaceDrptble.delegate = self
		self.SelectPlaceDrptble.dataSource = self
		FieldVisit_Popupview.isHidden = true
		//    //Field visit - IN and OUT button text color code
		self.FieldVisitInbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
		self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
		self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
		self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
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
		//Key board Hide touch any where
//		let touchtap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//		view.addGestureRecognizer(touchtap)
//
		
		//Address Textview
		Adresstxtview.text = "Reason"
        Adresstxtview.textColor = UIColor.lightGray
        Adresstxtview.font = UIFont(name: "verdana", size: 13.0)
        Adresstxtview.returnKeyType = .done
        Adresstxtview.delegate = self
		//key board show and Hide
		NotificationCenter.default.addObserver(self, selector: #selector(FieldVisitVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FieldVisitVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		//Field Visit form Top and Bottom Green line code
		// Creates the bottom border
		let borderBottom = CALayer()
		let borderWidth = CGFloat(2.0)
		borderBottom.borderColor = UIColor.green.cgColor
		borderBottom.frame = CGRect(x: 0, y: FldvisitFormView.frame.height - 1.0, width: FldvisitFormView.frame.width , height: FldvisitFormView.frame.height - 1.0)
		borderBottom.borderWidth = borderWidth
		FldvisitFormView.layer.addSublayer(borderBottom)
		FldvisitFormView.layer.masksToBounds = true

		// Creates the Top border
		let borderTop = CALayer()
		borderTop.borderColor = UIColor.green.cgColor
		borderTop.frame = CGRect(x: 0, y: 0, width: FldvisitFormView.frame.width, height: 1)
		borderTop.borderWidth = borderWidth
		FldvisitFormView.layer.addSublayer(borderTop)
		FldvisitFormView.layer.masksToBounds = true

		
		

//Previous meeting Validations
		if (Adresstxtview.text == addressString)
		{
			PreviousMeetingView.isHidden = false
		}
		else{
			PreviousMeetingView.isHidden = true
			
		}
		
		
		GoogleMapPolyline()
		
		
		
	}
//	@objc override func dismissKeyboard() {
//
//		view.endEditing(true)
//	}
	
	
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
		
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		RetrivedempId = defaults.integer(forKey: "empId")
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
				
				let ItemsDict = responseJSON["empAttendanceStatus"] as? [String:Any]
				DispatchQueue.main.async
					{
						self.empAttndInDateTime = ItemsDict?["empAttndInDateTime"] as? String ?? ""
						self.empAttndOutDateTime = ItemsDict?["empAttndOutDateTime"] as? String ?? ""
						if (self.empAttndInDateTime == "NA") {
							//            self.Fieldvisitoutbtn.setTitleColor(.lightGray, for: .normal)
							//            self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
							
						} else {
							
							if CLLocationManager.locationServicesEnabled(){
								self.locationManager.delegate = self
								self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
								self.locationManager.distanceFilter = 500
								self.locationManager.requestWhenInUseAuthorization()
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
	//Dropdown API for Field-Visit form
	func selectPlaceDrpdown()
	{
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		RetrivedempId = defaults.integer(forKey: "empId")
		let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any] as [String : Any]
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getVisitClientPlaceDDList")!
		let session = URLSession.shared
		var request = URLRequest(url: url as URL)
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
				DispatchQueue.main.async
					{
						let SelectPlaceArray = responseJSON["clientPlaceScheduleList"] as! NSArray
						for SelectPlaceDic in SelectPlaceArray as! [[String:Any]]
						{
							var MainDict:NSMutableDictionary = NSMutableDictionary()
							var SelectPlacestr = ""
							SelectPlacestr = (SelectPlaceDic["visitClientPlace"] as? String)!
							MainDict.setObject(SelectPlacestr, forKey: "visitClientPlace" as NSCopying)
							self.SelectPlaceArray.add(MainDict)
							
						}
						self.SelectPlaceDrptble.reloadData()
				}
			}
		}
		task.resume()
	}
	//Field visit - OUT form submit
	func FieldvisitFormsubmitAPI()
	{
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		RetrivedempId = defaults.integer(forKey: "empId")
		let latlanstr = latstr + ", " + longstr
		print("latlanstr..",latlanstr)
		let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"outFromLatLong": latlanstr as Any,"outFromAddress":Adresstxtview.text,"toClientNamePlace":"koilakuntla","visitPurpose":VisitPuposetxtfld.text,"prevVisitId":"2","meetingOutcome":"Approved","empVisitScheduleId":"2"] as [String : Any]
		
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
			
			print("insertFieldVisitOutDetailsWithScheduleId",responseJSON)
			if let responseJSON = responseJSON as? [String: Any] {
				self.empVisitId = Int()
				self.empVisitId = (responseJSON["empVisitId"] as? NSInteger)!
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
					self.scheduledTimerWithTimeInterval()
					DispatchQueue.main.async {
						let statusDic = responseJSON["status"]! as! NSDictionary
						let code = statusDic["code"] as! NSInteger
						if(code == 200)
						{
							
							self.insertTrackFieldVisit_updateCounting()
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
	
	func scheduledTimerWithTimeInterval(){
		
		timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.insertTrackFieldVisit_updateCounting), userInfo: nil, repeats: true)
	}
	////ksdsds
	//Background calling API
	@objc func insertTrackFieldVisit_updateCounting(){
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		RetrivedempId = defaults.integer(forKey: "empId")
		
		let latlanstr = latstr + ", " + longstr
		
		print("Background latlanstr...",latlanstr)
		let formatter = DateFormatter()
		//2016-12-08 03:37:22 +0000
		//formatter.dateFormat = "yyyy-MM-dd"
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let now = Date()
		let CurrentdateString = formatter.string(from:now)
		print("CurrentdateString",CurrentdateString)
		
		let parameters = [["custId": RetrivedcustId ,"empId": RetrivedempId,"empVisitId": empVisitId,"trackDateTime": CurrentdateString,"trackLatLong":latlanstr, "trackAddress":addressString, "trackDistance":"0.5","trackBattery":"99"] as [String : Any]]
		
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/insertTrackFieldVisit")!
		//create the session object
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
			
			print("insertTrackFieldVisit---",responseJSON)
			if let responseJSON = responseJSON as? [String: Any] {
				DispatchQueue.main.async
					{
						
				}
				
				
			}
			
			
		}
		task.resume()
		
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
		drpcell.selectPlacedrpLbl!.text = Selectplacestr
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
		Selectplacelbl.text = Selectplacestr
		DrpDownview.isHidden = true
		
		if (drpcell.selectPlacedrpLbl.text == "Others")
		{
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
				self.SelectPlaceViewconstriant?.constant = 45
				self.view.layoutIfNeeded()
			}, completion: nil)
		}
		else if(drpcell.selectPlacedrpLbl.text == "SH5")
		{
			ClientTxtfld.isHidden = true
			ClientView.backgroundColor = UIColor.gray
			let label = UILabel(frame: CGRect(x: 0, y: 5, width: 200, height: 23))
			//label.center = CGPoint(x: 160, y: 284)
			label.textAlignment = NSTextAlignment.left
			label.text = "Catact details"
			label.backgroundColor = UIColor.clear
			
			var Cantactsubview = UIView()

			Cantactsubview.frame = CGRect.init(x: 0, y: 30, width: 322, height: 65)
			Cantactsubview.backgroundColor = UIColor.clear     //give color to the view
			Cantactsubview.layer.borderColor = UIColor.gray.cgColor
			Cantactsubview.layer.borderWidth = 1.0
			//Cantactsubview.center = self.view.center
			//self.ClientView.addSubview(Cantactsubview)
			self.ClientView.addSubview(label)
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
				self.SelectPlaceViewconstriant?.constant = 100
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

		
		
		
	}
	@objc func pressButton(button: UIButton) {
		NSLog("pressed!")
		ClientTxtfld.text?.removeAll()
		VisitPuposetxtfld.text?.removeAll()
		FieldvisitBckview.isHidden = false
		Adresstxtview.text = addressString
	}
	@IBAction func Cancelbtnclk(_ sender: Any) {
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
		self.Fieldvisitoutbtn.setTitleColor(.darkGray, for: .normal)
		
	}
	@IBAction func FieldvisitOUT_Submitbtnclk(_ sender: Any) {
		
		
		
		FieldvisitFormsubmitAPI()
		
		self.FieldVisitInbtn.setTitleColor(.black, for: .normal)
		self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		FieldVisitInbtn.isEnabled = true
		Fieldvisitoutbtn.isEnabled = false
		self.Fieldvisitoutbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
		self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
		self.FieldVisitInbtn.addTarget(self, action: #selector(self.pressINButton(button:)), for: .touchUpInside)
		
	}
	
	
	
	
	@IBAction func OkBtnclk(_ sender: Any) {
		FieldvisitBckview.isHidden = true
		FieldVisit_Popupview.isHidden = true
		
	}
	
	
	//Field-Visit In update API
	@objc func pressINButton(button: UIButton) {
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		RetrivedempId = defaults.integer(forKey: "empId")
		
		let latlanstr = latstr + ", " + longstr
		
		
		
		print("Update latlanstr",latlanstr)
		print("empVisitId---",empVisitId)
		let parameters = ["custId": RetrivedcustId as Any,"empId":RetrivedempId as Any,"empVisitId": empVisitId as Any,"inLatLong": latlanstr as Any,"inAddress":addressString as Any,"kmTravelled":"5"] as [String : Any]
		
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/updateFieldVisitInDetails")!
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
			
			print("update Response---",responseJSON)
			if let responseJSON = responseJSON as? [String: Any] {
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
					self.scheduledTimerWithTimeInterval()
					DispatchQueue.main.async {
						let statusDic = responseJSON["status"]! as! NSDictionary
						let code = statusDic["code"] as! NSInteger
						if(code == 200)
						{
							self.mapView.addSubview(self.self.FieldVisitIn_PopupView)
							self.FieldVisitIn_PopupView.isHidden = false
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
	
	@IBAction func FieldVisit_InOkbtnclk(_ sender: Any) {
		
		FieldVisitIn_PopupView.isHidden = true
		FieldVisitInbtn.isEnabled = false
		Fieldvisitoutbtn.isEnabled = true
		self.FieldVisitInbtn.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for: .normal)
		self.FieldVisitInbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
		self.Fieldvisitoutbtn.setTitleColor(.black, for: .normal)
		self.Fieldvisitoutbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		
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
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
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
				print("fieldTrackDic responseJSON",responseJSON)
				DispatchQueue.main.async
					{
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
		print("CurrentdateString",CurrentdateString)
		let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": CurrentdateString as Any] as [String : Any]
		let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
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
				print("fieldTrackDic responseJSON",responseJSON)
				DispatchQueue.main.async {
					let path = GMSMutablePath()
					let fieldTrackArray = responseJSON["fieldTrack"] as? [Any]
					for visit in fieldTrackArray! {
						let fieldVisit = visit as? [String:Any]
						let latLongString = fieldVisit!["inLatLong"] as? String
						let Inaddress = fieldVisit!["inAddress"] as? String
						print("In address values...",Inaddress as Any)
						
						for (index, name) in fieldTrackArray!
							.enumerated()
						{
							//YOUR LOGIC....
							print("Index values",name)
							print("Index Integer numbers values..",index)//0, 1, 2, 3 ...
						//}
						
						let latLong = latLongString?.components(separatedBy: ",")
						let latitude = Double(latLong![0].replacingOccurrences(of: " ", with: ""))
						let longitude = Double(latLong![1].replacingOccurrences(of: " ", with: ""))
						path.add(CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
						
						let marker = GMSMarker()
						marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
						marker.title = Inaddress
						
						print("addressString....",self.addressString)
						//marker.snippet = "India"
						
						let labelMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
							
							let Indexstrnumbers = String(index)
							print("Indexstrnumbers",Indexstrnumbers)

							
						let label = UILabel()
						//label.text = Indexstrnumbers
						label.text = Indexstrnumbers
						label.backgroundColor = UIColor.blue
						label.sizeToFit()
						labelMarker.iconView = label
						labelMarker.map = self.mapView
							
							
						
						
//
//						let lbl = UILabel()
//						lbl.text = "ABC 123"
//						lbl.textColor = UIColor.black
//						lbl.backgroundColor = UIColor.cyan
//						// add label to viewAn
//						//lbl.frame = viewAn.bounds
//						self.mapView.addSubview(lbl)
						
						marker.map = self.mapView
					}
					
//					path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
//					path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
//					path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
//					path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
//					path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
					
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
	
	func textViewDidBeginEditing(_ textView: UITextView) {
        if Adresstxtview.text == "Reason" {
            Adresstxtview.text = ""
            Adresstxtview.textColor = UIColor.black
            Adresstxtview.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            Adresstxtview.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if Adresstxtview.text == "" {
            Adresstxtview.text = "Reason"
            Adresstxtview.textColor = UIColor.lightGray
            Adresstxtview.font = UIFont(name: "verdana", size: 13.0)
        }
    }
	
	@objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
	
	}








