//
//  PrivacyPolicyVC.swift
//  Serenity_Hostels
//
//  Created by sureshbabu bandaru on 3/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var PrivacyPOplicyview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        let borderBottom = CALayer()
        let borderWidth = CGFloat(10.0)
        borderBottom.borderColor = #colorLiteral(red: 0.831372549, green: 0.6862745098, blue: 0.2156862745, alpha: 1)
        borderBottom.frame = CGRect(x: 0, y: PrivacyPOplicyview.frame.height - 1.0, width: PrivacyPOplicyview.frame.width , height: PrivacyPOplicyview.frame.height - 10.0)
        borderBottom.borderWidth = borderWidth
        PrivacyPOplicyview.layer.addSublayer(borderBottom)
        PrivacyPOplicyview.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        PrivacyPOplicyview.layer.borderWidth = 10.0
        PrivacyPOplicyview.layer.borderColor = UIColor.clear.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func CancelBtn(_ sender: Any) {
        
        
        
        navigationController?.popViewController(animated: true)

        //presentingViewController!.dismiss(animated: true, completion: nil)

        
    }
    
    
    @IBAction func close(_ sender: Any) {
        //presentingViewController!.dismiss(animated: true, completion: nil)

        navigationController?.popViewController(animated: true)

        
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
