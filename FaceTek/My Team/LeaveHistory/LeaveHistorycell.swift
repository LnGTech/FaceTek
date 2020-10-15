//
//  LeaveHistorycell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 10/15/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class LeaveHistorycell: UITableViewCell {

	@IBOutlet weak var LeaveHistorycellBackview: UIView!
	
	@IBOutlet weak var DateLbl: UILabel!
	
	@IBOutlet weak var NoofdaysLbl: UILabel!
	
	@IBOutlet weak var LeavetypeLbl: UILabel!
	
	@IBOutlet weak var Remarktxtview: UITextView!
	
	@IBOutlet weak var LeavedatetxtLbl: UILabel!
	
	@IBOutlet weak var NofodaystxtLbl: UILabel!
	
	@IBOutlet weak var LeavetypetxtLbl: UILabel!
	
	@IBOutlet weak var LeaveremarktxtLbl: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
