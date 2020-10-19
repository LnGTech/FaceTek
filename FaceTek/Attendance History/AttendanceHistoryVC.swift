//
//  AttendanceHistoryVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/16/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import FSCalendar


class AttendanceHistoryVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
	private weak var calendar: FSCalendar!

	@IBOutlet weak var segctrl: UISegmentedControl!
	
	@IBOutlet weak var Fscalendarview: UIView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		
		let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 340, height: 300))
		calendar.dataSource = self
		calendar.delegate = self
		Fscalendarview.addSubview(calendar)
		


		self.calendar = calendar


    }
    

}
