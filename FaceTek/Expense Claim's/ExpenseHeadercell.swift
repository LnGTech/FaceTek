//
//  ExpenseHeadercell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 11/18/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ExpenseHeadercell: UITableViewCell {

	@IBOutlet weak var HeadercellBackVieew: UIView!
	
	@IBOutlet weak var ExpenseClaimLbl: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
