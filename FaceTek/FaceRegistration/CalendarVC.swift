//
//  CalendarVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/27/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var Calendartbl: UITableView!
    
    
    var DayArray = ["Wed","Wed","Sun","Fri","Wed","Sat","Fri","Sun","Mon","Mon","Sun","Sat","Fri"]

    var CalendarEventdayArray = ["New Year","Makara Sankranti","Republic Day","Maha Shivaratri","Ugadi","Ganesh Chaturthi","Gandhi Jayanti","Maha Navami,Ayudapooja","Vijaya Dashami","Kannada Rajyothsava","Deepavali","Christmas"]

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calendartbl.register(UINib(nibName: "Calendarcell", bundle: nil), forCellReuseIdentifier: "Calendarcell")
        
        
      


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count:Int?
        
        if tableView == self.Calendartbl {
            count = CalendarEventdayArray.count
        }
       
        return count!
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "Calendarcell", for: indexPath) as! Calendarcell
        //cell.accessoryType = .disclosureIndicator
        
        
        
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(2.0)
        borderBottom.borderColor = UIColor.gray.cgColor
        borderBottom.frame = CGRect(x: 0, y: cell.Bckview.frame.height - 1.0, width: cell.Bckview.frame.width , height: cell.Bckview.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        cell.Bckview.layer.addSublayer(borderBottom)
        cell.Bckview.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        cell.Bckview.layer.borderWidth = 2.0
        cell.Bckview.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        // set the shadow properties
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 4.0
        
        
        
        
        
        // set the text from the data model
        cell.EventdayLbl?.text = self.CalendarEventdayArray[indexPath.row]
        
        cell.DayLbl?.text = self.DayArray[indexPath.row]

        
        
        //        let image = NavigationMenuArray[indexPath.row]
        //
        //        cell.slideMenuimgicon.image = image
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    @IBAction func cancelBtn(_ sender: Any) {
        
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)

        
       // navigationController?.popViewController(animated: true)

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
