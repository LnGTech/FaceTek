//
//  PendingLeavescellTableViewCell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/28/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class PendingLeavescellTableViewCell: UITableViewCell {

	
	
	@IBOutlet weak var FromtxtLbl: UILabel!
	
	@IBOutlet weak var TotxtLbl: UILabel!
	
	@IBOutlet weak var RemarkstxtLbl: UILabel!
	@IBOutlet weak var FromLbl: UILabel!
    
    @IBOutlet weak var ToLbl: UILabel!
    @IBOutlet weak var RemarksLbl: UILabel!
    
    
    @IBOutlet weak var LeaveTypeLbl: UILabel!
    
    
    @IBOutlet weak var RejctLbl: UILabel!
    
    @IBOutlet weak var AcceptLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
