//
//  NotificationVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/9/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

	var NotificationArray:NSMutableArray = NSMutableArray()
	var MainDict:NSMutableDictionary = NSMutableDictionary()
	@IBOutlet weak var notificationtbl: UITableView!
	
	@IBOutlet weak var NotificationPopupview: UIView!
	
	
	@IBOutlet weak var headerlbl: UILabel!
	
	@IBOutlet weak var datelbl: UILabel!
	
	@IBOutlet weak var messgaelbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.notificationtbl.rowHeight = 85.0
		NotificationPopupview.isHidden = true


		notificationtbl.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")

		NotificationPopupview.center = self.view.center
		NotificationPopupview.backgroundColor = UIColor.white
		NotificationPopupview.layer.shadowColor = UIColor.darkGray.cgColor
		NotificationPopupview.layer.shadowOpacity = 1
		NotificationPopupview.layer.shadowOffset = CGSize.zero
		NotificationPopupview.layer.shadowRadius = 5
		self.view.addSubview(NotificationPopupview)
		
		
		headerlbl.font = UIFont(name: "Montserrat-Medium", size: 20.0)!
		let notificationHeaderlblatributes :Dictionary = [NSAttributedStringKey.font : headerlbl.font]
		headerlbl.textColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		
		datelbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
		let NotificationDatelblatributes :Dictionary = [NSAttributedStringKey.font : datelbl.font]
		datelbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
		
		messgaelbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
		let Notificationmsglblatributes :Dictionary = [NSAttributedStringKey.font : messgaelbl.font]
		messgaelbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
		
		
		
		NotificationAPI()
        // Do any additional setup after loading the view.
    }
    func NotificationAPI()
	{
		
		let defaults = UserDefaults.standard
		let brIdvalue = defaults.integer(forKey: "brId")
		let custIdvalu = defaults.integer(forKey: "custId")
		print("brIdvalue----",brIdvalue)
		print("custIdvalu----",custIdvalu)

		
		let parameters = ["brId": 12, "custId": 11]

			//create the url with URL
			let url = URL(string: "http://122.166.248.191:8080/attnd-api-gateway-service/api/customer/mobile/pushNotification/getByBrIdAndCustId")! //change the url

			//create the session object
			let session = URLSession.shared

			//now create the URLRequest object using the url object
			var request = URLRequest(url: url)
			request.httpMethod = "POST" //set http method as POST

			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
			} catch let error {
				print(error.localizedDescription)
			}

			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")

			//create dataTask using the session object to send data to the server
		let task = session.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in

				guard error == nil else {
					return
				}

				guard let data = data else {
					return
				}

				do {
					//create json object from data
					if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
						
						let pushNotificationDetailsArray = json["pushNotificationDetails"] as! NSArray
						print("pushNotificationDetailsArray..",pushNotificationDetailsArray)
						
						for Dic in pushNotificationDetailsArray as! [[String:Any]]

						{
						
						let notificationHeaderstr = Dic["notificationHeader"] as? String
							let notificationSentOnstr = Dic["notificationSentOn"] as? String
							
							let notificationMessagestr = Dic["notificationMessage"] as? String
							
							
							MainDict.setObject(notificationHeaderstr, forKey: "notificationHeader" as NSCopying)
							MainDict.setObject(notificationSentOnstr, forKey: "notificationSentOn" as NSCopying)
							
							MainDict.setObject(notificationMessagestr, forKey: "notificationMessage" as NSCopying)

							self.NotificationArray.add(self.MainDict)


						}

						DispatchQueue.main.async {
							self.notificationtbl.reloadData()
						}
						// handle json...
					}
				} catch let error {
					print(error.localizedDescription)
				}
			})
			task.resume()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return self.NotificationArray.count
		}
		
		// create a cell for each table view row
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
			
			
			cell.notificationHeaderlbl.font = UIFont(name: "Montserrat-Medium", size: 20.0)!
			let notificationHeaderlblatributes :Dictionary = [NSAttributedStringKey.font : cell.notificationHeaderlbl.font]
			cell.notificationHeaderlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8111867336)
			
			cell.NotificationDatelbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let NotificationDatelblatributes :Dictionary = [NSAttributedStringKey.font : cell.NotificationDatelbl.font]
			cell.NotificationDatelbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
			
			cell.Notificationmsglbl.font = UIFont(name: "Montserrat-Medium", size: 14.0)!
			let Notificationmsglblatributes :Dictionary = [NSAttributedStringKey.font : cell.Notificationmsglbl.font]
			cell.Notificationmsglbl.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
			
			
			let dicsubtaskDetails = NotificationArray.object(at: indexPath.row) as? NSDictionary
			cell.notificationHeaderlbl.text = dicsubtaskDetails?.value(forKey: "notificationHeader") as? String
			cell.NotificationDatelbl.text = dicsubtaskDetails?.value(forKey: "notificationSentOn") as? String
			cell.Notificationmsglbl.text = dicsubtaskDetails?.value(forKey: "notificationMessage") as? String

			return cell
		}
		
		// method to run when table view cell is tapped
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			print("You tapped cell number \(indexPath.row).")
			NotificationPopupview.isHidden = false
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
			
			let dicsubtaskDetails = NotificationArray.object(at: indexPath.row) as? NSDictionary
			cell.notificationHeaderlbl.text = dicsubtaskDetails?.value(forKey: "notificationHeader") as? String
			
			headerlbl.text = dicsubtaskDetails?.value(forKey: "notificationHeader") as? String
			cell.NotificationDatelbl.text = dicsubtaskDetails?.value(forKey: "notificationSentOn") as? String
			datelbl.text = dicsubtaskDetails?.value(forKey: "notificationSentOn") as? String
			cell.Notificationmsglbl.text = dicsubtaskDetails?.value(forKey: "notificationMessage") as? String

			messgaelbl.text = dicsubtaskDetails?.value(forKey: "notificationMessage") as? String

			
		}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 85;//Choose your custom row height
	}
	
	@IBAction func closebtn(_ sender: Any) {
		
		NotificationPopupview.isHidden = true
	}
	
	@IBAction func BckBtn(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)

	}
	

}
