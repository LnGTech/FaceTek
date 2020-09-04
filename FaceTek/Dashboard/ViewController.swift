//
//  ViewController.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/1/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
	
	var showTabBar = false;
	let reuseIdentifier = "DashboardCell" // also
	var isMenuVisible:Bool!
	var shouldIAllow = true
	var manager:CLLocationManager!
	var button: HamburgerButton! = nil
	
	@IBOutlet weak var hamburgerView: UIView!
	
	@IBOutlet var menu:UIView!
	@IBOutlet weak var BackView: UIView!
	@IBOutlet weak var collectionview: UICollectionView!
	@IBOutlet weak var NavigationMenuTbl: UITableView!
	@IBOutlet weak var LeavemanagementView: UIView!
	
	var DashboardArray = ["GPS BASED","FACE RECOGNITION","QR CODE","PROXIMITY BASED"]
	
	var DashboardIconImgs: [UIImage] = [UIImage(named: "gps.png")!,UIImage(named: "face.png")!,UIImage(named: "qrcode.png")!,UIImage(named: "proxe.png")!,]
	
	//Tableview
	var NavigationMenuArray = ["Registration","Faq"]
	//var NavigationimageArray = ["Faqicon.png","Faqicon.png"]
	
	//var NavigationimageArray: [UIImage] = [UIImage(named: "Home_user.png")!]
	
	var NavigationimageArray: [UIImage] = [UIImage(named: "Home_user.png")!,UIImage(named: "Faq.png")!]
	
	//var NavigationimageArray: [UIImage] = [UIImage(named: "payment.png")!,UIImage(named: "amenities.png")!,UIImage(named: "gust.png")!,UIImage(named: "transfer.png")!,UIImage(named: "conversion.png")!,UIImage(named: "booking.png")!,UIImage(named: "leave.png")!,UIImage(named: "latenight.png")!,UIImage(named: "complaints.png")!]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkUsersLocationServicesAuthorization()
		shouldIAllow = false
		
		let defaults = UserDefaults.standard
		defaults.set("Coding Explorer", forKey: "userNameKey")
		
		menu.isHidden = true
		isMenuVisible = true
		LeavemanagementView.isHidden = false
		collectionview.isHidden = false
		BackView.isHidden = false
		
		//Hamburger button
		self.button = HamburgerButton(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
		self.button.addTarget(self, action: #selector(ViewController.toggle(_:)), for:.touchUpInside)
		self.hamburgerView.addSubview(button)
		
		NavigationMenuTbl.register(UINib(nibName: "NavigationMenucell", bundle: nil), forCellReuseIdentifier: "NavigationMenucell")
		
		LeavemanagementView.layer.borderWidth = 1
		LeavemanagementView.layer.borderColor = UIColor.blue.cgColor
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if showTabBar {
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let tabBarController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController")
			self.present(tabBarController, animated:true, completion:nil)
		}
	}
	
	@objc func toggle(_ sender: AnyObject!) {
		self.toggleComparision()
		menu.isHidden = false
		self.button.showsMenu = !self.button.showsMenu
	}
	//Menu code
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		//        self.view.endEditing(true)
		//        isMenuVisible = false;
		//        self.button.showsMenu = !self.button.showsMenu
		//        self.toggleComparision()
	}
	
	@IBAction func closeMenu(_ sender: Any) {
		toggle(sender as AnyObject)
	}
	
	func toggleComparision()
	{
		if (isMenuVisible)
		{
			UIView.transition(with: menu, duration: 0.3, options: .beginFromCurrentState, animations: {
				var frame = self.menu.frame
				frame.origin.x = 0
				self.menu.frame = frame
				self.isMenuVisible = false;
				self.menu.isHidden = false
			})
		} else {
			UIView.transition(with: menu, duration: 0.3, options: .beginFromCurrentState, animations: {
				var frame = self.menu.frame
				frame.origin.x = -self.view.frame.size.width
				self.menu.frame = frame
			}) { (finished) in
				if finished {
					self.isMenuVisible = true
					self.menu.isHidden = true
				}
			}
		}
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.DashboardArray.count
		
	}
	
	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// get a reference to our storyboard cell
		let DashboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DashboardCell
		
		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		DashboardCell.DashboardLbl.text = self.DashboardArray[indexPath.item]
		let image = DashboardIconImgs[indexPath.row]
		DashboardCell.DashboardImage.image = image
		DashboardCell.layer.borderWidth = 1.0
		DashboardCell.layer.borderColor = UIColor.blue.cgColor
		return DashboardCell
		
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
		
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let noOfCellsInRow = 2
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
		return CGSize(width: size, height: 110)
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var count:Int?
		if tableView == self.NavigationMenuTbl {
			count = NavigationMenuArray.count
		}
		
		//        if tableView == self.Menutbl {
		//            count =  NavigationmenuArray.count
		//        }
		return count!
		
	}
	
	// create a cell for each table view row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// create a new cell if needed or reuse an old one
		let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationMenucell", for: indexPath) as! NavigationMenucell
		// set the text from the data model
		cell.NavigationMenuLbl?.text = self.NavigationMenuArray[indexPath.row]
		let image = NavigationimageArray[indexPath.row]
		cell.imageview.image = image
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		if indexPath.row == 0 {
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let RegistrationVC = storyBoard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
			self.navigationController?.pushViewController(RegistrationVC, animated: true)
			//self.present(RegistrationVC, animated:true, completion:nil)
		} else if indexPath.item == 1 {
			let storyBoard = UIStoryboard(name: "Main", bundle:nil)
			let PrivacyPolicyVC = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
			self.navigationController?.pushViewController(PrivacyPolicyVC, animated:false)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
		print("locations = \(locations)")
		//gpsResult.text = "success"
	}
	
	// authorization status
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			print("restricted") //we have got the location access
		case .denied, .notDetermined, .restricted:
			let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
			let LocationPermissionVC = storyBoard.instantiateViewController(withIdentifier: "LocationPermissionVC") as! LocationPermissionVC
			self.navigationController?.pushViewController(LocationPermissionVC, animated: true)
		default:
			print("location accessed")
		}
	}
	
	func checkUsersLocationServicesAuthorization(){
		if manager == nil {
			manager = CLLocationManager()
			manager.delegate = self
		}
		manager.requestAlwaysAuthorization()
	}
}
