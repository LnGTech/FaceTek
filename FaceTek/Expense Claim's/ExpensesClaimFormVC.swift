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
	
	@IBOutlet weak var ExpenseClaimTextview: UITextView!
	@IBOutlet weak var ExpenseDatetxtfld: UITextField!
	@IBOutlet weak var ExpenseTypetxtfld: UITextField!
	@IBOutlet weak var ExpenseAmttxtfld: UITextField!
	
	@IBOutlet weak var AttachfileActionView: UIView!
	
	@IBOutlet weak var ImageSelectedView: UIView!
	
	@IBOutlet weak var SelectedDateview: UIView!
	@IBOutlet weak var SubmitBtn: UIButton!
    let Datepicker = UIDatePicker()
    var ConvertedCurrentDatestr = String()


	
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
		
//		let DateGusture = UITapGestureRecognizer(target: self, action:  #selector(self.FromDatesetDatePicker))
//		self.SelectedDateview.addGestureRecognizer(DateGusture)

	ExpenseDatetxtfld.addTarget(self, action: #selector(FromDatesetDatePicker), for: .touchDown)
		
		
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
	func textViewDidBeginEditing(_ textView: UITextView) {

		if ExpenseClaimTextview.textColor == UIColor.lightGray {
			ExpenseClaimTextview.text = ""
			ExpenseClaimTextview.textColor = UIColor.black
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
			
			// text field is not empty
		}
	}
	
	//Datepicker
	@objc func FromDatesetDatePicker() {
            //Format Date
           // DatetxtFld.datePickerMode = .date
            
            //ToolBar
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
	
	@IBAction func BackBtnclk(_ sender: Any) {
		self.presentingViewController?.dismiss(animated: false, completion: nil)


	}
	
}
