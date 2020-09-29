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

class MyTeamGoogleMapVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

	@IBOutlet weak var mapView: GMSMapView!
	var latstr : String = ""
	var longstr : String = ""
	var addressString : String = ""
	var RetrivedcustId = Int()
	var RetrivedempId = Int()
	var locationManager = CLLocationManager()



	
    override func viewDidLoad() {
        super.viewDidLoad()
		let defaults = UserDefaults.standard
		RetrivedcustId = defaults.integer(forKey: "custId")
		print("My team RetrivedcustId----",RetrivedcustId)
		RetrivedempId = defaults.integer(forKey: "empId")
		print("RetrivedempId----",RetrivedempId)
		
		if CLLocationManager.locationServicesEnabled(){
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		self.locationManager.distanceFilter = 500
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		}
		
		GoogleMapPolyline()

        // Do any additional setup after loading the view.
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
			let parameters = ["custId": "74" as Any,"empId": "354" as Any,"visitDate": "2020-09-29" as Any] as [String : Any]
		
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

}
