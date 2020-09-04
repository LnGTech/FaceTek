//
//  ViewController.swift
//  OnboardingScreens
//
//  Created by sureshbabu bandaru on 5/25/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit
import CoreLocation

class PageController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var Nextbtn: UIButton!
	@IBOutlet weak var periodLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	var pageIndex: Int = 0
	var periodLabelTitle: String!
	var dateLabelTitle: String!
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var pageControl: UIPageControl!
	@IBOutlet var btnGetStarted: UIButton!
	@IBOutlet var btnSignIn: UIButton!
	var scrollWidth: CGFloat! = 0.0
	var scrollHeight: CGFloat! = 0.0
	
	//data for the slides
	var titles = ["Camera","Smart Attendance","GPS Location","Leave Management"]
	var Bottomtitles = ["Register Your Face","Mark Your Attendance On Daily \n Basis!","GPS Location Based Attendance","Plan Your Leaves And Get Instant"]
	var Bottomsecondtitles = [""," Basis!","","Approval!"]
	var descs = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit."]
	var imgs = ["camera_icon.png","attendence.png","map icon.png","leavemanagement.png"]
	
	//get dynamic width and height of scrollview and save it
	override func viewDidLayoutSubviews() {
		scrollWidth = scrollView.frame.size.width
		scrollHeight = scrollView.frame.size.height
	}
	
	override func viewDidLoad() {
		
		self.view.layoutIfNeeded()
		//to call viewDidLayoutSubviews() and get dynamic width and height of scrollview
		self.scrollView.delegate = self
		scrollView.isPagingEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		//crete the slides and add them
		var frame = CGRect(x: 0, y: 100, width: 0, height: 0)
		for index in 0..<titles.count {
			frame.origin.x = scrollWidth * CGFloat(index)
			frame.size = CGSize(width: scrollWidth, height: scrollHeight)
			let slide = UIView(frame: frame)
			//subviews
			let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
			imageView.frame = CGRect(x:0,y:0,width:180,height:180)
			imageView.contentMode = .scaleAspectFit
			imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
			let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+0,width:scrollWidth-64,height:30))
			txt1.textAlignment = .center
			txt1.textColor = UIColor.white
			txt1.font = UIFont.boldSystemFont(ofSize: 20.0)
			txt1.text = titles[index]
			let txt2 = UILabel.init(frame: CGRect(x:0,y:imageView.frame.maxY+30,width:scrollWidth-10,height:40))
			txt2.textAlignment = .center
			txt2.textColor = UIColor.white
			//txt2.font = UIFont.boldSystemFont(ofSize:20.0)
			//txt2.font = UIFont.boldSystemFont(ofSize: 20.0)
			txt2.font = UIFont.systemFont(ofSize: 18.0)
			txt2.numberOfLines = 2
			txt2.lineBreakMode = NSLineBreakMode.byWordWrapping
			txt2.text = Bottomtitles[index]
			let txt3 = UILabel.init(frame: CGRect(x:0,y:imageView.frame.maxY+60,width:scrollWidth-0,height:40))
			txt3.textAlignment = .center
			txt3.textColor = UIColor.white
			//txt2.font = UIFont.boldSystemFont(ofSize:20.0)
			//txt3.font = UIFont.systemFont(ofSize: 18.0)
			txt3.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin)
			txt3.font = UIFont.boldSystemFont(ofSize: 18.0)
			txt3.numberOfLines = 2
			txt3.lineBreakMode = NSLineBreakMode.byWordWrapping
			txt3.text = Bottomsecondtitles[index]
			slide.addSubview(imageView)
			slide.addSubview(txt1)
			slide.addSubview(txt2)
			slide.addSubview(txt3)
			scrollView.addSubview(slide)
		}
		
		//set width of scrollview to accomodate all the slides
		scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
		//disable vertical scroll/bounce
		self.scrollView.contentSize.height = 1.0
		//initial state
		pageControl.numberOfPages = titles.count
		pageControl.numberOfPages = Bottomtitles.count
		pageControl.numberOfPages = Bottomsecondtitles.count
		pageControl.currentPage = 0
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Hide the navigation bar on the this view controller
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	@IBAction func pageChanged(_ sender: Any) {
		scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		setIndiactorForCurrentPage()
	}
	
	func setIndiactorForCurrentPage()  {
		let page = (scrollView?.contentOffset.x)!/scrollWidth
		pageControl?.currentPage = Int(page)
		if(pageControl?.currentPage == 0) {
			//camera
			Nextbtn.backgroundColor = UIColor.clear
			Nextbtn.setTitle("NEXT", for: .normal)
			Nextbtn.setTitleColor(.white, for: .normal)
		}
		else if(pageControl?.currentPage == 1) {
			//smart attendance
			Nextbtn.backgroundColor = UIColor.clear
			Nextbtn.setTitle("NEXT", for: .normal)
			Nextbtn.setTitleColor(.white, for: .normal)
		} else if(pageControl?.currentPage == 2) {
			//location
			Nextbtn.setTitle("NEXT", for: .normal)
			Nextbtn.backgroundColor = UIColor.clear
			Nextbtn.setTitleColor(.white, for: .normal)
		} else if(pageControl?.currentPage == 3) {
			//leave management
			Nextbtn.backgroundColor = UIColor.white
			Nextbtn.setTitle("GOT IT", for: .normal)
			Nextbtn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
			Nextbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
			Nextbtn.addTarget(self, action: #selector(MainHomeview(_:)), for: .touchUpInside)
		}
	}
	
	func scrollRight() {
		print(scrollView.contentOffset.x)
		if scrollView.contentOffset.x < self.view.bounds.width * CGFloat(imgs.count - 1) {
			scrollView.contentOffset.x +=  self.view.bounds.width
		}
	}
	
	@IBAction func SkipBtn(_ sender: Any) {
		goToMainView()
	}
	
	@IBAction func NextBtnclk(_ sender: Any) {
		let pageWidth:CGFloat = scrollView.frame.width
		let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
		// Change the indicator
		self.pageControl.currentPage = Int(currentPage);
		// Change the text accordingly
		if Int(currentPage) == 0{
			// textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
		}else if Int(currentPage) == 1{
			//textView.text = "I write mobile tutorials mainly targeting iOS"
		}else if Int(currentPage) == 2{
			// textView.text = "And sometimes I write games tutorials about Unity"
		}else{
			Nextbtn.backgroundColor = UIColor.white
			Nextbtn.setTitle("GOT IT", for: .normal)
			Nextbtn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
			Nextbtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
			Nextbtn.addTarget(self, action: #selector(MainHomeview(_:)), for: .touchUpInside)
			UIView.animate(withDuration: 1.0, animations: { () -> Void in
				//self.startButton.alpha = 1.0
			})
		}
		scrollRight()
	}
	
	@objc func MainHomeview(_ button: UIButton) {
		goToMainView()
	}
	
	private func goToMainView() {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let ViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
		let navVC = UINavigationController.init(rootViewController: ViewController)
		
		navVC.modalPresentationStyle = .fullScreen
		navVC.navigationBar.isHidden = true
		self.present(navVC, animated:true, completion:nil)
	}
	
}
