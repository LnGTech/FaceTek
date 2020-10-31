//
//  MyTeamGoogleMapVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/29/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Alamofire
import SwiftyJSON

class MyTeamGoogleMapVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate {

	
	private var isAlreadyLoading = false

	@IBOutlet weak var FieldvisitDetailsLbl: UILabel!
	@IBOutlet weak var MyteamGooglemapFormtbl: UITableView!
	
	@IBOutlet weak var VisitStatusLbl: UILabel!
	
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var MyTeamGooglemapFormview: UIView!
	
	@IBOutlet weak var FieldvisitDetailsview: UIView!
	
	@IBOutlet weak var Closebtnview: UIView!
	@IBOutlet weak var FormLblBckview: UIView!
	
	@IBOutlet weak var Dateview: UIView!
	@IBOutlet weak var mapView: GMSMapView!
	
	@IBOutlet weak var Datetxtfle: UITextField!
	@IBOutlet weak var DateSelectionBtn: UIButton!
	//UI Label Outlet's
	
	@IBOutlet weak var PlaceClientDataLbl: UILabel!
	
	@IBOutlet weak var VisitDatetimeDataLbl: UILabel!
	
	
	@IBOutlet weak var TimeSpentDataLbl: UILabel!
	
	@IBOutlet weak var KmtravelDataLbl: UILabel!
	
	@IBOutlet weak var VisitPurposeDataLbl: UILabel!
	
	@IBOutlet weak var VisitOutcomeDataLbl: UILabel!
	
	
	@IBOutlet weak var AddressDataLbl: UITextView!
	
	
	@IBOutlet weak var PlaceClientLbltxt: UILabel!
	
	@IBOutlet weak var VisitDatetimeLbltxt: UILabel!
	
	@IBOutlet weak var TimespentLbltxt: UILabel!
	
	@IBOutlet weak var KmtravelLbltxt: UILabel!
	
	@IBOutlet weak var VisitPurposeLbltxt: UILabel!
	
	@IBOutlet weak var VisitOutcomeLbltxt: UILabel!
	
	@IBOutlet weak var AdressLbltxt: UILabel!
	let Datepicker = UIDatePicker()

    var MarkerdataArray:NSMutableArray = NSMutableArray()

	
	var empVisitId = Int()

	var latstr : String = ""
	var longstr : String = ""
	var addressString : String = ""
	var Visitpurpose : String = ""
	var MarkerSelectedVisitIdvalue : String = ""


	var RetrivedcustId = Int()
	var RetrivedMyTeamempId = Int()
	var locationManager = CLLocationManager()
    var ConvertedCurrentDatestr = NSString()


//    var titlesArray = ["Place/Client Name","Visit Date & Time","Time spent","Km travel","Visit Purpose","Visit Outcome","Address"]

    var titlesArray = ["Place/Client Name"]

	
    override func viewDidLoad() {
        super.viewDidLoad()
		

		FieldvisitDetailsLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		FieldvisitDetailsLbl.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)


		mapView.delegate = self
		MyTeamGooglemapFormview.isHidden = true
		VisitStatusLbl.isHidden = true
		

		MyTeamGooglemapFormview.layer.cornerRadius = 20
		MyTeamGooglemapFormview.clipsToBounds = true
		MyTeamGooglemapFormview.layer.masksToBounds = false
		MyTeamGooglemapFormview.layer.shadowRadius = 7
		MyTeamGooglemapFormview.layer.shadowOpacity = 0.6
		MyTeamGooglemapFormview.layer.shadowOffset = CGSize(width: 0, height: 5)
		MyTeamGooglemapFormview.layer.shadowColor = UIColor.black.cgColor
		

		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("My team RetrivedcustId----",RetrivedcustId)
		RetrivedMyTeamempId = defaults.integer(forKey: "MyTeamempId")
		print("RetrivedMyTeamempId----",RetrivedMyTeamempId)
		self.Dateview.layer.borderWidth = 1

		Dateview.layer.borderColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)
		
		Datetxtfle.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)
		DateSelectionBtn.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)

		DateSelectionBtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)


		//self.customView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2156862745, blue: 0.5725490196, alpha: 1)

		
		if CLLocationManager.locationServicesEnabled(){
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		self.locationManager.distanceFilter = 500
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		}
		
//		MyTeamGooglemapFormview.layer.masksToBounds = false
//		MyTeamGooglemapFormview.layer.cornerRadius = MyTeamGooglemapFormview.frame.height/2
//        MyTeamGooglemapFormview.layer.shadowColor = UIColor.black.cgColor
//        MyTeamGooglemapFormview.layer.shadowPath = UIBezierPath(roundedRect: MyTeamGooglemapFormview.bounds, cornerRadius: MyTeamGooglemapFormview.layer.cornerRadius).cgPath
//        MyTeamGooglemapFormview.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        MyTeamGooglemapFormview.layer.shadowOpacity = 0.5
//        MyTeamGooglemapFormview.layer.shadowRadius = 1.0
		
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MMM-yyyy"
		Datetxtfle.text = formatter.string(from: Datepicker.date)
		 //var ConvertedDatestr = ""
		ConvertedCurrentDatestr = formattedDateFromString(dateString:
			Datetxtfle.text!, withFormat: "yyyy-MM-dd")! as NSString
		
		let borderBottom = CALayer()
		let borderWidth = CGFloat(2.0)
		borderBottom.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		borderBottom.frame = CGRect(x: 0, y: FieldvisitDetailsview.frame.height - 1.0, width: FieldvisitDetailsview.frame.width , height: FieldvisitDetailsview.frame.height - 1.0)
		borderBottom.borderWidth = borderWidth
		FieldvisitDetailsview.layer.addSublayer(borderBottom)
		FieldvisitDetailsview.layer.masksToBounds = true

		// Creates the Top border
		let borderTop = CALayer()
		borderTop.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		borderTop.frame = CGRect(x: 0, y: 0, width: Closebtnview.frame.width, height: 1)
		borderTop.borderWidth = borderWidth
		Closebtnview.layer.addSublayer(borderTop)
		Closebtnview.layer.masksToBounds = true
		
		
		GoogleMapPolyline()
		

        // Do any additional setup after loading the view.
    }
	

	
	
	@objc func pressButton(button: UIButton) {
		print("Log values..")
		
		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
		
		toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
		
		Datetxtfle.inputAccessoryView = toolbar
		Datetxtfle.inputView = Datepicker
		
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
            
            Datetxtfle.inputAccessoryView = toolbar
            Datetxtfle.inputView = Datepicker
             
        }
        
        @objc func doneDatePicker(){
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            Datetxtfle.text = formatter.string(from: Datepicker.date)
             //var ConvertedDatestr = ""
            ConvertedCurrentDatestr = formattedDateFromString(dateString:
                Datetxtfle.text!, withFormat: "yyyy-MM-dd")! as NSString
            print("ConvertedCurrentDatestr---",ConvertedCurrentDatestr)
            //AbsentAPIMethod()
			GoogleMapPolyline()
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker(){
            self.view.endEditing(true)
    };
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
	
	
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])

	{
		let newLocation = locations.last // find your device location
		mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 16) // show your device location on map
		mapView.settings.myLocationButton = true // show current location button
		let lat = (newLocation?.coordinate.latitude)! // get current location latitude
		let long = (newLocation?.coordinate.longitude)!
		latstr = String(lat)
		print("latstr....",latstr)
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
//				    let marker = GMSMarker()
//				    marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
//				    marker.title = self.addressString
//				    marker.map = self.mapView
//				    print("address location",self.addressString)
			}
		})
	}
    
func GoogleMapPolyline()
	{
			
			let defaults = UserDefaults.standard
			RetrivedcustId = defaults.integer(forKey: "custId")
			print("My team RetrivedcustId----",RetrivedcustId)
			RetrivedMyTeamempId = defaults.integer(forKey: "MyTeamempId")
			print("RetrivedMyTeamempId----",RetrivedMyTeamempId)
		
		
		
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			let now = Date()
			let CurrentdateString = formatter.string(from:now)
			print("CurrentdateString",CurrentdateString)
			//let parameters = ["custId": "74" as Any,"empId": "353" as Any,"visitDate": ConvertedCurrentDatestr as Any] as [String : Any]
		print("ConvertedCurrentDatestr23",ConvertedCurrentDatestr)
		
		let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedMyTeamempId as Any,"visitDate": ConvertedCurrentDatestr as Any] as [String : Any]
		
		//let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": CurrentdateString as Any] as [String : Any]
		
			let url: NSURL = NSURL(string:"http://52.183.137.54:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
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
					print(" My Team fieldTrackDic responseJSON",responseJSON)
					
					
					
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
							let Inaddress = fieldVisit!["inAddress"] as? String
							let toClientNamePlace = (fieldVisit!["toClientNamePlace"] as? String)!
							
							let visitEndDateTime = (fieldVisit!["visitEndDateTime"] as? String)!
							
							self.empVisitId = (fieldVisit?["empVisitId"] as? NSInteger)!
							print("empVisitId...",self.empVisitId)
					

							let ConvertempVisitId = String(self.empVisitId)

							let latLong = latLongString?.components(separatedBy: ",")
							let latitude = Double(latLong![0].replacingOccurrences(of: " ", with: ""))
							let longitude = Double(latLong![1].replacingOccurrences(of: " ", with: ""))
							path.add(CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
							
							let marker = GMSMarker()
							marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
							marker.title = ConvertempVisitId
							marker.snippet = ConvertempVisitId
							
							self.MarkerSelectedVisitIdvalue = marker.title!
							print("snippet values",marker.snippet)
							print("snippet values----",self.MarkerSelectedVisitIdvalue)

							
							print("addressString....",self.addressString)
							//marker.snippet = "India"
							
							let labelMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
								
								//let Indexstrnumbers = String(index)
								//print("Indexstrnumbers",Indexstrnumbers)

								
							let label = UILabel()
							//label.text = Indexstrnumbers
							//label.text = Indexstrnumbers
							label.backgroundColor = UIColor.blue
							label.sizeToFit()
							labelMarker.iconView = label
							labelMarker.map = self.mapView
								
							
							marker.map = self.mapView
						}
						
						let polyline = GMSPolyline(path: path)
						polyline.strokeColor = .blue
						polyline.strokeWidth = 1.0
						polyline.spans = [GMSStyleSpan(color: .blue)]
						polyline.map = self.mapView
						self.VisitStatusLbl.isHidden = true

					
					}
					else
					{
						
						self.VisitStatusLbl.isHidden = false

						print("statusDic---",statusDic)
						let message = statusDic["message"] as? NSString
						
						//self.VisitStatusLbl.isHidden = false
						self.VisitStatusLbl.text = message as String?
						
						self.mapView.addSubview(self.VisitStatusLbl)

						
						
						print("Visi UnAvailable")
						
						

						print("message-----",message as Any)
						
					}
					}
				}}
			//}
			task.resume()
		}
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		
		
		MyTeamGooglemapFormview.isHidden = false
		//MarkerSelectedVisitIdvalue = marker.title!
		print("marker tapped:", marker.title)
		print("Retrived snippet values....",MarkerSelectedVisitIdvalue)
		var Markerselect = marker.title
		
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("My team RetrivedcustId----",RetrivedcustId)
		RetrivedMyTeamempId = defaults.integer(forKey: "MyTeamempId")
		print("RetrivedMyTeamempId----",RetrivedMyTeamempId)
		let formatter = DateFormatter()
				formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
				let now = Date()
				let CurrentdateString = formatter.string(from:now)
				print("CurrentdateStringsecond",CurrentdateString)
		
		print("ConvertedCurrentDatestr second",ConvertedCurrentDatestr)
		
				let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedMyTeamempId as Any,"visitDate": ConvertedCurrentDatestr as Any] as [String : Any]
				let url: NSURL = NSURL(string:"http://52.183.137.54:8080/attnd-api-gateway-service/api/customer/employee/fieldVisit/getFieldVisitTrackDetailsWithAChild")!
				_ = URLSession.shared
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
								
								self.empVisitId = (fieldVisit?["empVisitId"] as? NSInteger)!
										print("empVisitId...",self.empVisitId)
								let MarkerselectedConvertedempVisitId = String(self.empVisitId)
								if (MarkerselectedConvertedempVisitId == Markerselect) {
									
									var MainDict:NSMutableDictionary = NSMutableDictionary()
									
									
																		let attributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.PlaceClientDataLbl.font]
									self.PlaceClientLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.PlaceClientLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
									
									let VisitDatetimeattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.VisitDatetimeLbltxt.font]
									self.VisitDatetimeLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitDatetimeLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
									
									let TimespentattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.TimespentLbltxt.font]
									self.TimespentLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.TimespentLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
									let KmtravelattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.KmtravelLbltxt.font]
									self.KmtravelLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.KmtravelLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)

									
									let VisitpurposeattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.VisitPurposeLbltxt.font]
									self.VisitPurposeLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitPurposeLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)

									let VisitOutcomeattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.VisitOutcomeLbltxt.font]
									self.VisitOutcomeLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitOutcomeLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)
									
									let AddressattributesLbltxt :Dictionary = [NSAttributedStringKey.font : self.AdressLbltxt.font]
									self.AdressLbltxt.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.AdressLbltxt.textColor = #colorLiteral(red: 0.6519868338, green: 0.6519868338, blue: 0.6519868338, alpha: 1)

									//UILable API Data
									var toClientNamePlace = (fieldVisit!["toClientNamePlace"] as? String)!
									self.PlaceClientDataLbl.text = toClientNamePlace
									let attributes :Dictionary = [NSAttributedStringKey.font : self.PlaceClientDataLbl.font]
									self.PlaceClientDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.PlaceClientDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									
									MainDict.setObject(toClientNamePlace, forKey: "toClientNamePlace" as NSCopying)
									
									var visitEndDateTime = (fieldVisit!["visitEndDateTime"] as? String)!
									self.VisitDatetimeDataLbl.text = visitEndDateTime
									let VisitDatetimeDataattributes :Dictionary = [NSAttributedStringKey.font : self.VisitDatetimeDataLbl.font]
									self.VisitDatetimeDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitDatetimeDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									MainDict.setObject(visitEndDateTime, forKey: "visitEndDateTime" as NSCopying)
									
									var timeSpent = (fieldVisit!["timeSpent"] as? String)!
									
									self.TimeSpentDataLbl.text = timeSpent
									let TimespentDataattributes :Dictionary = [NSAttributedStringKey.font : self.TimeSpentDataLbl.font]
									self.TimeSpentDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.TimeSpentDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									MainDict.setObject(timeSpent, forKey: "timeSpent" as NSCopying)
									
									var kmTravelled = (fieldVisit?["kmTravelled"] as? NSNumber)!
									print("kmTravelled----",kmTravelled)
									
									
									let temp:NSNumber = kmTravelled
									let tempString = temp.stringValue

									
									//var ConvertKmtravel = String(kmTravelled)
									
									self.KmtravelDataLbl.text = tempString
									
									let KmtraveledDataattributes :Dictionary = [NSAttributedStringKey.font : self.KmtravelDataLbl.font]
									self.KmtravelDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.KmtravelDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									
									MainDict.setObject(kmTravelled, forKey: "kmTravelled" as NSCopying)
//
									
									var visitPurpose = (fieldVisit!["visitPurpose"] as? String)!
									
									self.VisitPurposeDataLbl.text = visitPurpose
									let VisitPurposeDataattributes :Dictionary = [NSAttributedStringKey.font : self.VisitPurposeDataLbl.font]
									self.VisitPurposeDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitPurposeDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									
									
									MainDict.setObject(visitPurpose, forKey: "visitPurpose" as NSCopying)
									var meetingOutcome = (fieldVisit!["meetingOutcome"] as? String)!
									
									self.VisitOutcomeDataLbl.text = meetingOutcome
									
									let VisitOutcomeDataattributes :Dictionary = [NSAttributedStringKey.font : self.VisitOutcomeDataLbl.font]
									self.VisitOutcomeDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.VisitOutcomeDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									
									MainDict.setObject(meetingOutcome, forKey: "meetingOutcome" as NSCopying)
									
									var inAddress = (fieldVisit!["inAddress"] as? String)!
									self.AddressDataLbl.text = inAddress
									
									let AddressDataattributes :Dictionary = [NSAttributedStringKey.font : self.AddressDataLbl.font]
									self.AddressDataLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
									self.AddressDataLbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
									
									MainDict.setObject(inAddress, forKey: "inAddress" as NSCopying)
									print("Marker selected IntoClientNamePlaceaddress values...",toClientNamePlace as Any)
									
									self.MarkerdataArray.add(MainDict)
									
//
								}
									
								}
								
								
							}
						
							
							
							
						}
					}
		}
				
		
				task.resume()
		
		
		
		
           return true
    }
	
	
	@IBAction func CloseBtnclk(_ sender: Any) {
		
		MyTeamGooglemapFormview.isHidden = true
		

		
		
	}
	
	
	}
	
	

