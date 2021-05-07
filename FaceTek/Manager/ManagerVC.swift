//
//  ManagerVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ManagerVC: UIViewController {
    
    
    var Absentstr = String()
    var Leavesstr = String()

    @IBOutlet weak var Dateview: UIView!
    
    var Managerstr = ""
    
    
    @IBOutlet weak var TitleLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Dateview.layer.borderWidth = 1
        //Dateview.layer.borderColor = UIColor.blue.cgColor
         Dateview.layer.borderColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
         TitleLbl.text = Managerstr
          if (TitleLbl.text == "Absent Details")
        {
            print("Absent-------")
        }
       else if (TitleLbl.text == "Leave Details")
       {
           print("Leave-------")
       }
       else if (TitleLbl.text == "Late comers")
             {
                 print("Late comers-------")
             }
         else
        {
             print("Early leavers--------")
        }
    }
    

    
    @IBAction func CancelBtnclk(_ sender: Any) {
 
        self.presentingViewController?.dismiss(animated: false, completion: nil)
     }
     
}
