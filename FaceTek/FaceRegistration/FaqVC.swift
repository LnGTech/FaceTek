//
//  FaqVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class FaqVC: UIViewController {
    var ValueData = ""
    
    
    @IBOutlet weak var Textview: UITextView!
    @IBOutlet weak var FaqWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
        
        
        var ValueData = ""
        let str = ValueData.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        print("ValueData Html",str)

        
        
        
        FaqAPIMethod()

        
        
        }
        
    

    func FaqAPIMethod()
    {
            
            print("calling API Dropdown data")
            
            
            let parameters = [
                "key": "faq"] as [String : Any]
            
            //create the url with URL
            //let url = URL(string: "https://www.webliststore.biz/app_api/api/authenticate_user")! //change the url
            
		
		
            
            //let url: NSURL = NSURL(string: "http://122.166.152.106:8080/attnd-api-gateway-service/api/customer/mobile/app/policyandfaq/getAllBykey")!
            
            
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/mobile/app/policyandfaq/getAllBykey"
		
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
		
		
            //http://122.166.152.106:8080/serenityuat/inmatesignup/validateMobileNo
            //customActivityIndicatory(self.view, startAnimate: true)

            
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url as URL)
            request.httpMethod = "POST" //set http method as POST
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //create dataTask using the ses
            //request.setValue(Verificationtoken, forHTTPHeaderField: "Authentication")
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print("Json Response",responseJSON)
                    
                    
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        let FaqArray = responseJSON["data"] as! NSArray
                                                print("Array values----",FaqArray)
                                            
                                            
                                                for FaqsubDic in FaqArray as! [[String:Any]]
                                                {
                                                    var MainDict:NSMutableDictionary = NSMutableDictionary()
                                            
                                            
                                            
                                            
                                                    self.ValueData = (FaqsubDic["value"] as? String)!

                                                    print("ValueData-------",self.ValueData)
                                                    MainDict.setObject(self.ValueData, forKey: "value" as NSCopying)
                                                   

                                                    let StringData = "" + self.ValueData + "";

                                                    
print("StringData---",StringData)
                                                    
                                                    
                                                    let data = StringData.data(using: String.Encoding.unicode)! // mind "!"
                                                    let attrStr = try? NSAttributedString( // do catch
                                                        data: data,
                                                        options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                        documentAttributes: nil)
                                                    // suppose we have an UILabel, but any element with NSAttributedString will do
                                                    self.Textview.attributedText = attrStr
                                                    //self.Textview.font = .systemFont(ofSize: 18)

                                                    self.Textview.font = UIFont.preferredFont(forTextStyle: .body)
                                                    
                                                }

                        
                        //self.customActivityIndicatory(self.view, startAnimate: false)
                    }
                }
                
                
            }
            task.resume()
            
        }
    
    
    
    
    
    
    @IBAction func CancelBtn(_ sender: Any) {
    
    self.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
}
