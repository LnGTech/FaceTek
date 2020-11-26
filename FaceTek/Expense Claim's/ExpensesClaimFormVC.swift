//
//  ExpensesClaimFormVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

extension UIViewController {
func ExpenseClaimdismissKey()
{
let dismisstap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.ExpenseClaimdismissKeyboard))
dismisstap.cancelsTouchesInView = false
view.addGestureRecognizer(dismisstap)
}
@objc func ExpenseClaimdismissKeyboard()
{
view.endEditing(true)
	
}
}
class ExpensesClaimFormVC: UIViewController,UITextViewDelegate,UITextFieldDelegate {
	
	@IBOutlet weak var ExpensetitleLbl: UILabel!
	@IBOutlet weak var ExpenseClaimTextview: UITextView!
	@IBOutlet weak var ExpenseDatetxtfld: UITextField!
	@IBOutlet weak var ExpenseTypetxtfld: UITextField!
	@IBOutlet weak var ExpenseAmttxtfld: UITextField!
	@IBOutlet weak var AttachfileActionView: UIView!
	@IBOutlet weak var ImageSelectedView: UIView!
	@IBOutlet weak var SelectedDateview: UIView!
	
	@IBOutlet weak var ClaimPopupview: UIView!
	
	@IBOutlet weak var SubmitBtn: UIButton!
    let Datepicker = UIDatePicker()
    var ConvertedCurrentDatestr = String()
	var Currentdatestr : String = ""

	override func viewDidLoad() {
        super.viewDidLoad()
		let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarView.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.2980392157, blue: 0.5450980392, alpha: 1)
		view.addSubview(statusBarView)
		ImageSelectedView.isHidden = true
		ExpenseClaimTextview.delegate = self
		ExpenseDatetxtfld.delegate = self
		ExpenseTypetxtfld.delegate = self
		ExpenseAmttxtfld.delegate = self
		ExpenseClaimdismissKey()
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		Currentdatestr = dateFormatter.string(from: today)
		//ExpenseDatetxtfld.text = Currentdatestr
		self.ClaimPopupview.isHidden = true

		//Textview Place holder code
		ExpenseClaimTextview.text = "Remarks (Optional)"
		ExpenseClaimTextview.textColor = UIColor.lightGray
		//UIView Action Target
		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.AttachfileActionClk))
		self.AttachfileActionView.addGestureRecognizer(gesture)
		//Image or Attached File Selected View
		ImageSelectedView.layer.cornerRadius = 5
		ImageSelectedView.clipsToBounds = true
		ImageSelectedView.layer.masksToBounds = false
		ImageSelectedView.layer.shadowRadius = 20
		ImageSelectedView.layer.shadowOpacity = 0.6
		ImageSelectedView.layer.shadowOffset = CGSize(width: 0, height: 20)
		ImageSelectedView.layer.shadowColor = UIColor.darkGray.cgColor
		//ExpenseAmttxtfld Validation
		SubmitBtn.isEnabled = false
		ExpenseAmttxtfld.addTarget(self, action: #selector(ExpenseAmount), for: UIControl.Event.editingChanged)
		ExpenseDatetxtfld.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)
		
		//Color codes
		let ExpenseClaimtitleLblattributes :Dictionary = [NSAttributedStringKey.font : ExpensetitleLbl.font]
		ExpensetitleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		ExpensetitleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 21.0)!
		
		let ExpenseDatetxtfldAttributes :Dictionary = [NSAttributedStringKey.font : ExpenseDatetxtfld.font]
		ExpenseDatetxtfld.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ExpenseDatetxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let ExpenseTypetxtfldAttributes :Dictionary = [NSAttributedStringKey.font : ExpenseTypetxtfld.font]
		ExpenseTypetxtfld.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ExpenseTypetxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let ExpenseAmttxtfldAttributes :Dictionary = [NSAttributedStringKey.font : ExpenseAmttxtfld.font]
		ExpenseAmttxtfld.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ExpenseAmttxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		
		
		ExpenseDatetxtfld.attributedPlaceholder = NSAttributedString(string: "Expense Date", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)])
		ExpenseDatetxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		ExpenseTypetxtfld.attributedPlaceholder = NSAttributedString(string: "Expense Type", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)])
		ExpenseTypetxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		ExpenseAmttxtfld.attributedPlaceholder = NSAttributedString(string: "Amount", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)])
		ExpenseAmttxtfld.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!

		ExpenseClaimTextview.text = "Enter Remarks"
        ExpenseClaimTextview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		ExpenseClaimTextview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!

        ExpenseClaimTextview.delegate = self
		

		
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let currentPoint = touch.location(in: )
			ImageSelectedView.isHidden = true
		}
	}
	@objc func AttachfileActionClk(sender : UITapGestureRecognizer) {
		ImageSelectedView.isHidden = false

	}
//	func textViewDidBeginEditing(_ textView: UITextView) {
//		if ExpenseClaimTextview.textColor == UIColor.lightGray {
//		ExpenseClaimTextview.text = ""
//		ExpenseClaimTextview.textColor = UIColor.black
//		}
//	}
	func textViewDidBeginEditing(_ textView: UITextView) {
        if ExpenseClaimTextview.text == "Enter Remarks" {
            ExpenseClaimTextview.text = ""
            ExpenseClaimTextview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ExpenseClaimTextview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            ExpenseClaimTextview.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if ExpenseClaimTextview.text == "" {
            ExpenseClaimTextview.text = "Enter Remarks"
            ExpenseClaimTextview.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
			ExpenseClaimTextview.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
        }
    }
	
	
	
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
	{
		ExpenseDatetxtfld.resignFirstResponder()
		ExpenseTypetxtfld.resignFirstResponder()
		ExpenseAmttxtfld.resignFirstResponder()
		return true;
	}
	@objc func ExpenseAmount(sender: UITextField) {
		if sender.text!.isEmpty {
			// textfield is empty
			print("textfield is empty")
		} else {
			print("text field is not empty")
			SubmitBtn.isEnabled = true
			SubmitBtn.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
		}
	}
	
	//Datepicker
	@objc func FromDatesetDatePicker() {
           
            //ToolBar
//            let toolbar = UIToolbar();
//            toolbar.sizeToFit()
//            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
//            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//            ExpenseDatetxtfld.inputAccessoryView = toolbar
//            ExpenseDatetxtfld.inputView = Datepicker
		
		
		Datepicker.datePickerMode = .date

		let toolbar = UIToolbar();
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
			
		toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
		ExpenseDatetxtfld.inputAccessoryView = toolbar
		ExpenseDatetxtfld.inputView = Datepicker
		
             
        }
        
        @objc func doneDatePicker(){
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MMM-yyyy"
		ExpenseDatetxtfld.text = formatter.string(from: Datepicker.date)
             //var ConvertedDatestr = ""
		ConvertedCurrentDatestr = formattedDateFromString(dateString:
		ExpenseDatetxtfld.text!, withFormat: "yyyy-MM-dd")! as String
		print("ConvertedCurrentDatestr---",ConvertedCurrentDatestr)
            self.view.endEditing(true)
        }
        @objc func cancelDatePicker(){
            self.view.endEditing(true)
    };
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
	
	func FormAPISubmitData()
	{
		let defaults = UserDefaults.standard
		var RetrivedempId = defaults.integer(forKey: "empId")
		var RetrivedcustId = defaults.integer(forKey: "custId")
		
		let parameters = [
			"refCustId": RetrivedcustId,
			"refEmpId": RetrivedempId,
			"empExpDate": ConvertedCurrentDatestr,
			"empExpType": ExpenseTypetxtfld.text,
			"empExpAmount": ExpenseAmttxtfld.text,
			"empExpClaimRemarks": ExpenseClaimTextview.text,
			"claimAttachments": []] as [String : Any]
		
		let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/insertEmpExpenseClaim")!
		
		let session = URLSession.shared
		var request = URLRequest(url: url as URL)
		request.httpMethod = "POST"
		do {
		request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			
		} catch let error {
					print(error.localizedDescription)
				}
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
		guard let data = data, error == nil else {
		print(error?.localizedDescription ?? "No data")
						return
					}
		let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
		if let responseJSON = responseJSON as? [String: Any] {
		print("Expense Submit History Json Response",responseJSON)
		DispatchQueue.main.async {
		let statusDic = responseJSON["status"]! as! NSDictionary
		print("status------",statusDic)
		let Expensecode = statusDic["code"] as? NSInteger
		if (Expensecode == 200)
		{
			self.ClaimPopupview.isHidden = false
											
		}
			else
		{
			self.ClaimPopupview.isHidden = true

			print("false values")
			}

		}

	}
		DispatchQueue.main.async {
						}
					}
		task.resume()
		
	}
	
	
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)

	}
	
	@IBAction func OkBtnclk(_ sender: Any) {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let ExpenseClaimVC = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimVC") as! ExpenseClaimVC
		self.present(ExpenseClaimVC, animated:true, completion:nil)
		
	}
	
	@IBAction func Submitbtnclk(_ sender: Any) {
		FormAPISubmitData()
		
	}
	
}
