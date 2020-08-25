//
//  FieldVisitVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 8/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import GoogleMaps

class FieldVisitVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var Fieldvisitoutbtn: UIButton!
    var lat = String()
    var long = String()
    var address: String = ""
    var empAttndInDateTime : String = ""
    var empAttndOutDateTime : String = ""
    var RetrivedcustId = Int()
    var RetrivedempId = Int()
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    let defaults = UserDefaults.standard
    RetrivedcustId = defaults.integer(forKey: "custId")
    print("RetrivedcustId----",RetrivedcustId)
    RetrivedempId = defaults.integer(forKey: "empId")
    print("RetrivedempId----",RetrivedempId)
        Fieldvisit_OUT()

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             let newLocation = locations.last // find your device location
            print("newLocation",newLocation)
             mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 20.0) // show your device location on map
             mapView.settings.myLocationButton = true // show current location button
            let lat1 = (newLocation?.coordinate.latitude)! // get current location latitude
            let long = (newLocation?.coordinate.longitude)! //get current location longitude

            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: lat1, longitude: long)
            print("latlanvalues------",location)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
                if let locationName = placeMark?.addressDictionary?["Name"] as? NSString
            {
                print(locationName)
            }

            // Street address
                if let street = placeMark?.addressDictionary?["Thoroughfare"] as? NSString
            {
                print(street)
            }

            // City
                if let city = placeMark?.addressDictionary?["City"] as? NSString
            {
                print(city)
            }

            // Zip code
                if let zip = placeMark?.addressDictionary?["ZIP"] as? NSString
            {
                print(zip)
            }

            // Country
                if let country = placeMark?.addressDictionary?["Country"] as? NSString
            {
                print(country)
            }
            
            
    //        getAddress { (address) in
    //            print("Location------",address)
    //        }
            
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
                self.Fieldvisitoutbtn.setTitleColor(.yellow, for: .normal)
            } else {
                self.Fieldvisitoutbtn.setTitleColor(.red, for: .normal)
                self.Fieldvisitoutbtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
            }
            
        }
                            
        }
                
        }
            task.resume()
            
        }
    @objc func pressButton(button: UIButton) {
        NSLog("pressed!")
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
                }
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.animate(toViewingAngle: 45)
        mapView.delegate = self
    }

        
    }
    

    

