//
//  MyTeamVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Alamofire
import SwiftyJSON

class MyTeamVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,GMSMapViewDelegate {
	
	
	
	
	
	@IBOutlet weak var mapView: GMSMapView!
	var latstr : String = ""
	var longstr : String = ""
	var addressString : String = ""
	var RetrivedempId = Int()
	var MyTeamempId = Int()



    var MyTeamData = NSMutableDictionary()
    var MyTeamArray = NSMutableArray()
	@IBOutlet weak var MyTeamtbl: UITableView!
	@IBOutlet weak var Nodataview: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.MyTeamtbl.delegate = self
		self.MyTeamtbl.dataSource = self
		self.MyTeamtbl.rowHeight = 65
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 0.9680276113)
		view.addSubview(statusBarView)
		Nodataview.isHidden = true
		  MyTeamtbl.register(UINib(nibName: "MyTeamtblCell", bundle: nil), forCellReuseIdentifier: "MyTeamtblCell")
		
		let defaults = UserDefaults.standard
		var RetrivedcustId = defaults.integer(forKey: "custId")
		print(" RetrivedcustId----",RetrivedcustId)
		
		var RetrivedempId = defaults.integer(forKey: "empId")
		print(" RetrivedempId----",RetrivedempId)
		
		var RetrivedbrId = defaults.integer(forKey: "brId")
		print(" RetrivedbrId----",RetrivedbrId)

		
		let parameters = ["brId": RetrivedbrId as Any,"custId": RetrivedcustId as Any,"empId": RetrivedempId as Any] as [String : Any]
			   
				var StartPoint = Baseurl.shared().baseURL
				var Endpoint1 = "/attnd-api-gateway-service/api/customer/employee/fieldVisit/getMyTeamDetails"
				let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint1)")!
				
				//let url: NSURL = NSURL(string:"http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/employee/leave/getEmpPendingLeaveByCustIdAndEmpId")!
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
						print("Pending Leaves Json Response",responseJSON)
						DispatchQueue.main.async {
				let statusDic = responseJSON["status"]! as! NSDictionary
				print("status------",statusDic)
				let LeavePendingCode = statusDic["code"] as? NSInteger
				print("LeavePendingCode-----",LeavePendingCode as Any)
							 if (LeavePendingCode == 200)
							{
								
//								let empnamestr = statusDic["empName"] as? String
//
//
								 self.MyTeamtbl.isHidden = false
								
							   
								
							 }
							else
							{
		 
							  print("Not   Leaves")
								self.Nodataview.isHidden = false
							 }
										 
							
							 self.MyTeamData = NSMutableDictionary()
							if responseJSON != nil{
								self.MyTeamData = (responseJSON as NSDictionary).mutableCopy() as! NSMutableDictionary
								
								if let temp = self.MyTeamData.value(forKey: "reportingEmployees") as? NSArray{
									self.MyTeamArray = temp.mutableCopy() as! NSMutableArray
								}
								
							  

							}
						self.MyTeamtbl.reloadData()
		//                }
						}
					}
				}
				task.resume()
		
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
	
	
//	func numberOfSections(in tableView: UITableView) -> Int {
//			return self.marLeavesData.count
//		   }
//
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return self.MyTeamArray.count
		}
		
		  
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let MyTeamtblCell = tableView.dequeueReusableCell(withIdentifier: "MyTeamtblCell", for: indexPath) as! MyTeamtblCell
		let dicShiftDetails = MyTeamArray.object(at: indexPath.row) as? NSDictionary
	
		MyTeamtblCell.nameLbl.text = dicShiftDetails?.value(forKey: "empName") as? String
		MyTeamtblCell.MobilenumberLbl.text = dicShiftDetails?.value(forKey: "empMobileNo") as? String
		let borderBottom = CALayer()
		let borderWidth = CGFloat(1.0)
		borderBottom.borderColor = UIColor.lightGray.cgColor
		borderBottom.frame = CGRect(x: 0, y: MyTeamtblCell.MyTeamcellview.frame.height - 1.0, width: MyTeamtblCell.MyTeamcellview.frame.width , height: MyTeamtblCell.MyTeamcellview.frame.height - 1.0)
	    borderBottom.borderWidth = borderWidth
		MyTeamtblCell.MyTeamcellview.layer.addSublayer(borderBottom)
		MyTeamtblCell.MyTeamcellview.layer.masksToBounds = true
		MyTeamtblCell.img.layer.borderWidth = 1
		MyTeamtblCell.img.layer.masksToBounds = false
		MyTeamtblCell.img.layer.borderColor = UIColor.green.cgColor
		MyTeamtblCell.img.layer.backgroundColor = UIColor.green.cgColor
		MyTeamtblCell.img.layer.cornerRadius = MyTeamtblCell.img.frame.height/2
		MyTeamtblCell.img.clipsToBounds = true
	//           }
		return MyTeamtblCell
		   }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let dicShiftDetails = MyTeamArray.object(at: indexPath.row) as? NSDictionary
		
		
		
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		
		MyTeamempId = (dicShiftDetails?.value(forKey: "empId") as? NSInteger)!
		print("Stored empid",MyTeamempId)
		
		UserDefaults.standard.set(self.MyTeamempId, forKey: "MyTeamempId")

		
		let MyTeamGoogleMapVC = storyBoard.instantiateViewController(withIdentifier: "MyTeamGoogleMapVC") as! MyTeamGoogleMapVC
		self.present(MyTeamGoogleMapVC, animated:true, completion:nil)
        
    }
	
    
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
