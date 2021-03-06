//
//  ExpensesClaimFormVC.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//suresh

import UIKit
import Alamofire
import SwiftyJSON

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
class ExpensesClaimFormVC: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
 {
	
	
	@IBOutlet weak var taskheight: NSLayoutConstraint!
	@IBOutlet weak var tasknamebckview: UIView!
	@IBOutlet weak var Expensetasknamelbl: UILabel!
	
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
	var taskid = Int()
	var tasknamestr = String()



	@IBOutlet weak var Imagepic: UIImageView!
	
	@IBOutlet weak var imagecancelBtn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		imagecancelBtn.isHidden = true
		
//		self.tasknameviewheight?.constant = 0
//		self.Datebckviewheight?.constant = 80

		
		
		let defaults = UserDefaults.standard
		
		//taskid = ("\(defaults.integer(forKey: "taskidkey") ?? 0)")
		taskid = UserDefaults.standard.integer(forKey: "taskidkey")
		print("add taskid..",taskid)
		tasknamestr = UserDefaults.standard.string(forKey: "tasknamekey") ?? ""
		print("add Expense tasknamestr",tasknamestr)
		
		Expensetasknamelbl.text = tasknamestr
		let ExpensetasknamelblAttributes :Dictionary = [NSAttributedStringKey.font : Expensetasknamelbl.font]
		Expensetasknamelbl.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		Expensetasknamelbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)!
		let ExpensetasknamelblAtributes :Dictionary = [NSAttributedStringKey.font : ExpenseTypetxtfld.font]
		ExpenseTypetxtfld.textColor = #colorLiteral(red: 0.4556630711, green: 0.4556630711, blue: 0.4556630711, alpha: 1)
		
		
		var taskName = StructOperation.glovalVariable.taskName;
		print("taskName...",taskName)
		
		if (taskName != "")
		{
			print("taskname true")
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in

			self.view.layoutIfNeeded()
			}, completion: nil)
		}
		else
		{
			
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [self] in
//			self.tsknamehight?.constant = 0
				self.taskheight?.constant = 0

			self.view.layoutIfNeeded()
			}, completion: nil)
			print("taskname false")
		}
		
		
		

		
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

		ExpenseClaimTextview.text = "Remarks (Optional)"
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
			SubmitBtn.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
		}
	}
	
	//Datepicker
	@objc func FromDatesetDatePicker() {
           
		
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
		
		var image = self.Imagepic.image
		let imageData:Data =  UIImagePNGRepresentation(image!)!
		let base64String = imageData.base64EncodedString()
		print("image stored",base64String)
		let parameters = [
			"refCustId": RetrivedcustId,
			"refEmpId": RetrivedempId,
			"refClientTaskId": taskid,
			"empExpDate": ConvertedCurrentDatestr,
			"empExpType": ExpenseTypetxtfld.text as Any,
			"empExpAmount": ExpenseAmttxtfld.text as Any,
			"empExpClaimRemarks": ExpenseClaimTextview.text,
			"claimAttachments":[["claimAttachment": base64String]]] as [String : Any]
		
		var StartPoint = Baseurl.shared().baseURL
		var Endpoint = "/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/insertEmpExpenseClaim"
		
		//let url: NSURL = NSURL(string:"http://36.255.87.28:8080/attnd-api-gateway-service/api/customer/Mob/employee/expenseClaim/insertEmpExpenseClaim")!
		
		_ = URLSession.shared
		let url: NSURL = NSURL(string:"\(StartPoint)\(Endpoint)")!
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

	
	@IBAction func TakePicBtnclk(_ sender: Any) {
		ImageSelectedView.isHidden = true
		
		//self.btnEdit.setTitleColor(UIColor.white, for: .normal)
		//self.btnEdit.isUserInteractionEnabled = true

		let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
			self.openCamera()
		}))

//		alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//			//self.openGallary()
//		}))

		alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

		/*If you want work actionsheet on ipad
		then you have to use popoverPresentationController to present the actionsheet,
		otherwise app will crash on iPad */
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			alert.popoverPresentationController?.sourceView = sender as! UIView
			alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
			alert.popoverPresentationController?.permittedArrowDirections = .up
		default:
			break
		}

		self.present(alert, animated: true, completion: nil)
		
	}
	
	func openCamera()
	{
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerController.SourceType.camera
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
		}
		else
		{
			let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func ChoosePicBtnclk(_ sender: Any) {
		ImageSelectedView.isHidden = true

		let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//				alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//					self.openCamera()
//				}))

				alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
					self.openGallery()
				}))

				alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

				/*If you want work actionsheet on ipad
				then you have to use popoverPresentationController to present the actionsheet,
				otherwise app will crash on iPad */
				switch UIDevice.current.userInterfaceIdiom {
				case .pad:
					alert.popoverPresentationController?.sourceView = sender as! UIView
					alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
					alert.popoverPresentationController?.permittedArrowDirections = .up
				default:
					break
				}

				self.present(alert, animated: true, completion: nil)
				
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			imagecancelBtn.isHidden = false

		   // imageViewPic.contentMode = .scaleToFill
			Imagepic.image = pickedImage
			
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	func openGallery()
	{
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
			self.present(imagePicker, animated: true, completion: nil)
		}
		else
		{
			let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	@IBAction func imgcancelBtnclk(_ sender: Any) {
		imagecancelBtn.isHidden = true
		//Imagepic.isHidden = true
		Imagepic.removeFromSuperview()  // this removes it from your view hierarchy
		Imagepic = nil;
	}
	
	@IBAction func Submitbtnclk(_ sender: Any) {
		FormAPISubmitData()
		
	}
	
}
