//
//  LeaveHistoryHeadercell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/15/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LeaveHistoryHeadercell: UITableViewCell {

	@IBOutlet weak var LeaveHistorystatusview: UIView!
	
	@IBOutlet weak var LeavestsLbl: UILabel!
	@IBOutlet weak var LeaveHistorystsLbl: UIView!
	
	@IBOutlet weak var LeaveHistoryRejectedLbl: UILabel!
	
	@IBOutlet weak var Rejectedimg: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
