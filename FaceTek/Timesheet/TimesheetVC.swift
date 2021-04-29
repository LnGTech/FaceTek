//
//  TimesheetVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/28/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class TimesheetVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

	
	@IBOutlet weak var Topdatebckview: UIView!
	@IBOutlet weak var datetxtlbl: UILabel!
	@IBOutlet weak var datelbl: UITextField!
	
	@IBOutlet weak var custlbl: UILabel!
	
	@IBOutlet weak var selecttasklbl: UILabel!
	
	@IBOutlet weak var subtasklbl: UILabel!
	
	@IBOutlet weak var hourslbl: UILabel!
	@IBOutlet weak var Datetimeview: UIView!
	
	@IBOutlet weak var Selectcustview: UIView!
	
	@IBOutlet weak var SelectTaskview: UIView!
	
	
	@IBOutlet weak var tblbackview: UIView!
	
	@IBOutlet weak var tblsubtaskbckview: UIView!
	
	@IBOutlet weak var timesheettbl: UITableView!
	let MyAccountArray: [String] = ["GST filling and other paper related activities.filling other paper related activities", "Financial documents", "Employee Extra training certification." , "Client deal clouser and visiting." , "Financial new documents" , "Employee Extra training certification"]

	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		timesheettbl.register(UINib(nibName: "timesheettblcell", bundle: nil), forCellReuseIdentifier: "timesheettblcell")

		Topdatebckview.layer.shadowColor = UIColor.lightGray.cgColor
		Topdatebckview.layer.shadowOpacity = 3
		Topdatebckview.layer.shadowOffset = .zero
		Topdatebckview.layer.shadowRadius = 4

		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
		Topdatebckview.layer.borderWidth = 0.30
		Topdatebckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		Selectcustview.layer.borderWidth = 0.30
//		SelectTaskview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		SelectTaskview.layer.borderWidth = 0.30
//		tblbackview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblbackview.layer.borderWidth = 0.30
//		tblsubtaskbckview.layer.borderColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
//		tblsubtaskbckview.layer.borderWidth = 0.20
		
		datetxtlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let datetextattributes :Dictionary = [NSAttributedStringKey.font : datetxtlbl.font]
		datetxtlbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

		datelbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let dateattributes :Dictionary = [NSAttributedStringKey.font : datelbl.font]
		datelbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		custlbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let custattributes :Dictionary = [NSAttributedStringKey.font : custlbl.font]
		custlbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		selecttasklbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let selecttaskattributes :Dictionary = [NSAttributedStringKey.font : selecttasklbl.font]
		selecttasklbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		subtasklbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let subtasksatributes :Dictionary = [NSAttributedStringKey.font : subtasklbl.font]
		subtasklbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		hourslbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let hoursattributes :Dictionary = [NSAttributedStringKey.font : hourslbl.font]
		hourslbl.textColor = #colorLiteral(red: 0.9689681155, green: 0.6426868715, blue: 0.1272936669, alpha: 1)
		tblbackview.layer.shadowColor = UIColor.lightGray.cgColor
		tblbackview.layer.shadowOpacity = 5
		tblbackview.layer.shadowOffset = .zero
		tblbackview.layer.shadowRadius = 6
    }
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.MyAccountArray.count

		
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

	let cell = tableView.dequeueReusableCell(withIdentifier: "timesheettblcell") as! timesheettblcell
	
	cell.subtasktbllbl.text = self.MyAccountArray[indexPath.row]
	
		cell.tableviewsubtaskcellbackview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
		cell.tableviewsubtaskcellbackview.layer.borderWidth = 0.30
		
		cell.subtasktbllbl.font = UIFont(name: "Montserrat-Medium", size: 15.0)!
		let ClaimDatetxtLblattributes :Dictionary = [NSAttributedStringKey.font : cell.subtasktbllbl.font]
		cell.subtasktbllbl.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

		
	//let image = MyAccountIconImgs[indexPath.row]
	//cell.img.image = image
	return cell
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 76
		
	}
    


}
