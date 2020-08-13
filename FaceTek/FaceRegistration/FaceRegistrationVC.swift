//
//  FaceRegistrationVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/6/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class FaceRegistrationVC: UIViewController {

    var custbrCode = String()
    var Employeenamestr = String()


    @IBOutlet weak var EmplyeeNameLbl: UILabel!
    
    @IBOutlet weak var BrcodeLbl: UILabel!
    
    @IBOutlet weak var UserNameView: UIView!
    
    @IBOutlet weak var CompanyCodeview: UIView!
    
    @IBOutlet weak var CompanyIdview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
		custbrCode = defaults.string(forKey: "brCode") ?? ""
        Employeenamestr = defaults.string(forKey: "employeeName") ?? ""
        
        //Brach code conver capital letters
        //var CapitalcustbrCode = (custbrCode.uppercased())

        print("custbrCode----",custbrCode)
        print("employeeName----",Employeenamestr)

        EmplyeeNameLbl.text = Employeenamestr
        BrcodeLbl.text = custbrCode.uppercased()
        
        
        //Username Bottom line color
        let borderBottom = CALayer()
        let borderWidth = CGFloat(10.0)
        borderBottom.borderColor = UIColor.darkGray.cgColor
        borderBottom.frame = CGRect(x: 0, y: UserNameView.frame.height - 1.0, width: UserNameView.frame.width , height: UserNameView.frame.height - 1.0)
        borderBottom.borderWidth = borderWidth
        UserNameView.layer.addSublayer(borderBottom)
        UserNameView.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        UserNameView.layer.borderWidth = 10.0
        UserNameView.layer.borderColor = UIColor.clear.cgColor
        
        
        
        //Company name Bottom line color
        let CompanynameViewborderBottom = CALayer()
        //let borderWidth = CGFloat(10.0)
        CompanynameViewborderBottom.borderColor = UIColor.darkGray.cgColor
        CompanynameViewborderBottom.frame = CGRect(x: 0, y: CompanyCodeview.frame.height - 1.0, width: CompanyCodeview.frame.width , height: CompanyCodeview.frame.height - 1.0)
        CompanynameViewborderBottom.borderWidth = borderWidth
        CompanyCodeview.layer.addSublayer(CompanynameViewborderBottom)
        CompanyCodeview.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        CompanyCodeview.layer.borderWidth = 10.0
        CompanyCodeview.layer.borderColor = UIColor.clear.cgColor
        
        
        
        //Company iDcard name Bottom line color
        let CompanyidViewborderBottom = CALayer()
        //let borderWidth = CGFloat(10.0)
        CompanyidViewborderBottom.borderColor = UIColor.darkGray.cgColor
        CompanyidViewborderBottom.frame = CGRect(x: 0, y: CompanyIdview.frame.height - 1.0, width: CompanyIdview.frame.width , height: CompanyIdview.frame.height - 1.0)
        CompanyidViewborderBottom.borderWidth = borderWidth
        CompanyIdview.layer.addSublayer(CompanyidViewborderBottom)
        CompanyIdview.layer.masksToBounds = true
        //Textfield border and bottom line color code
        
        CompanyIdview.layer.borderWidth = 10.0
        CompanyIdview.layer.borderColor = UIColor.clear.cgColor
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func FaceRegisterBtn(_ sender: Any) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let CaptureVC = storyBoard.instantiateViewController(withIdentifier: "CaptureVC") as! CaptureVC
//        self.present(CaptureVC, animated:true, completion:nil)
//
    

        let objRecVC = RecognitionViewController(screen:  UIScreen.main)
        objRecVC.modalPresentationStyle = .fullScreen
		//self.navigationController?.pushViewController(objRecVC, animated:true)
		self.present(objRecVC, animated: true, completion: nil)
    
    
    
       // let objRecVC = RecognitionViewController(screen:  UIScreen.main)
                                   
                                                              // self.navigationController?.pushViewController(objRecVC, animated:false)

        
    
    }
    
    
    @IBAction func cancel(_ sender: Any) {
    
         self.presentingViewController?.dismiss(animated: false, completion: nil)
        
        //self.navigationController?.popViewController(animated: true)


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
