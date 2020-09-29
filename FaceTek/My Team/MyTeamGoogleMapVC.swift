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

class MyTeamGoogleMapVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var MyteamGooglemapFormtbl: UITableView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var MyTeamGooglemapFormview: UIView!
	@IBOutlet weak var Dateview: UIView!
	@IBOutlet weak var mapView: GMSMapView!
	
	@IBOutlet weak var Datetxtfle: UITextField!
	@IBOutlet weak var DateSelectionBtn: UIButton!
    let Datepicker = UIDatePicker()

	
	
	
	var latstr : String = ""
	var longstr : String = ""
	var addressString : String = ""
	var RetrivedcustId = Int()
	var RetrivedempId = Int()
	var locationManager = CLLocationManager()
    var ConvertedCurrentDatestr = NSString()


    var titlesArray = ["Place/Client Name","Visit Date & Time","Time spent","Km travel","Visit Purpose","Visit Outcome","Address"]


	
    override func viewDidLoad() {
        super.viewDidLoad()
		mapView.delegate = self
		MyTeamGooglemapFormview.isHidden = true
		
		MyteamGooglemapFormtbl.register(UINib(nibName: "Googlemapformtblcell", bundle: nil), forCellReuseIdentifier: "Googlemapformtblcell")

		

		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("My team RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
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
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MMM-yyyy"
		Datetxtfle.text = formatter.string(from: Datepicker.date)
		 //var ConvertedDatestr = ""
		ConvertedCurrentDatestr = formattedDateFromString(dateString:
			Datetxtfle.text!, withFormat: "yyyy-MM-dd")! as NSString
		
		
		
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
			RetrivedempId = defaults.integer(forKey: "empId")
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			let now = Date()
			let CurrentdateString = formatter.string(from:now)
			print("CurrentdateString",CurrentdateString)
			let parameters = ["custId": "74" as Any,"empId": "354" as Any,"visitDate": ConvertedCurrentDatestr as Any] as [String : Any]
		
		//let parameters = ["custId": RetrivedcustId as Any,"empId": RetrivedempId as Any,"visitDate": CurrentdateString as Any] as [String : Any]
		
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
//							print("In address values...",Inaddress as Any)
//
//							for (index, name) in fieldTrackArray!
//								.enumerated()
//							{
//								//YOUR LOGIC....
//								print("Index values",name)
//								print("Index Integer numbers values..",index)//0, 1, 2, 3 ...
//							//}
							
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
								
								//let Indexstrnumbers = String(index)
								//print("Indexstrnumbers",Indexstrnumbers)

								
							let label = UILabel()
							//label.text = Indexstrnumbers
							//label.text = Indexstrnumbers
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
			//}
			task.resume()
		}
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		MyTeamGooglemapFormview.isHidden = false

		print("marker tapped:", marker.title)
           return true
    }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var count:Int?
		if tableView == self.MyteamGooglemapFormtbl {
		count = titlesArray.count
		return count!
			}
				//if tableView == self.Dropdowntbl {
//		if tableView == self.Dropdowntbl {
//		count =  LeavetypeDropdownArray.count
//			}
		return count!
		}
		
		// create a cell for each table view row
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cellToReturn = UITableViewCell() // Dummy value
		if tableView == self.MyteamGooglemapFormtbl {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Googlemapformtblcell") as! Googlemapformtblcell
		cell.accessoryType = .disclosureIndicator
		cell.titleLbl?.text = self.titlesArray[indexPath.row]
		cellToReturn = cell
			}
//		} else if tableView == self.Dropdowntbl {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "Dropdowncell") as! Dropdowncell
//		let responseDict = self.LeavetypeDropdownArray[indexPath.row] as! NSMutableDictionary
//							_ = LeavetypeDropdownArray[indexPath.row]
//		print("Retrived data",responseDict)
//		self.LeavetypeDropdownArray.add(MainDict)
//		print("Leave Type Array",LeavetypeDropdownArray)
//		var custLeaveNamestr : String?
//		custLeaveNamestr = responseDict["custLeaveName"] as? String
//		print("custLeaveNamestr",custLeaveNamestr)
//		cell.DropdownLbl!.text = custLeaveNamestr
//		cellToReturn = cell
//			   }
		return cellToReturn
		}
		
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
			
		{
			print("Tapped")
			}
		
		
		func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
			return 76
		
		}
	}
	
	

