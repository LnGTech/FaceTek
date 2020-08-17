//
//  LocationPermissionVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/31/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LocationPermissionVC: UIViewController {

    @IBOutlet weak var Allowbtnn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Allowbtnn.layer.cornerRadius = 10
        Allowbtnn.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AllowBtn(_ sender: Any) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//                   let RegistrationVC = storyBoard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
//                   self.present(RegistrationVC, animated:true, completion:nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let RegistrationVC = storyBoard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(RegistrationVC, animated: true)
        
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
