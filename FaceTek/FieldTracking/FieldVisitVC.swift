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
        var address: String = ""
    var Langitudeestr: String = ""
    
    var Latitudestr:Float = 0.0

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
        

                getAddress { (address) in
                    print("Location------",address)
                }

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             let newLocation = locations.last // find your device location
            print("newLocation",newLocation)
             mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 20.0) // show your device location on map
             mapView.settings.myLocationButton = true // show current location button
            let lat = (newLocation?.coordinate.latitude)! // get current location latitude
            let long = (newLocation?.coordinate.longitude)! //get current location longitude
        Latitudestr = Float((newLocation?.coordinate.latitude)!)
print("Latitudestr..",Latitudestr)
        Langitudeestr = String(newLocation!.coordinate.latitude)

           
    }
    
    
    func getAddress(handler: @escaping (String) -> Void)
    {
        //convert lat and long values double
        let lat = Double(Latitudestr)
        print("Facetek lat value",lat as Any)
        
        let Long = Double(Langitudeestr)
        print("Facetek LongitudestrData value",Long as Any)

        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: 12.93254753, longitude: 77.60804704)
        //let location = CLLocation(latitude: lat!, longitude: Long!)

        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
            
           // Passing address back
           handler(address)
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
}
    

    

