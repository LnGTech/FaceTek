//
//  StepThree.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/10/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class StepThree: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Btnclk(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let ViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(ViewController, animated:true, completion:nil)
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
