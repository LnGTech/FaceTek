//
//  Expensecell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 11/18/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class Expensecell: UITableViewCell {

	@IBOutlet weak var ExpenseBackview: UIView!
	@IBOutlet weak var Viewmore_Btmview: UIView!
	
	
	@IBOutlet weak var ClaimDateLbl: UILabel!
	
	@IBOutlet weak var ExpenseDateLbl: UILabel!
	
	@IBOutlet weak var ExpenseAmtLbl: UILabel!
	
	@IBOutlet weak var ExpenseApprovedAmtLbl: UILabel!
	
	
	@IBOutlet weak var ExpenseTypeLbl: UILabel!
	
	
	//Text Labels
	
	@IBOutlet weak var ClaimDatetxtLbl: UILabel!
	
	@IBOutlet weak var ExpenseDatetxtLbl: UILabel!
	
	@IBOutlet weak var ExpenseAmounttxtLbl: UILabel!
	
	@IBOutlet weak var ExpenseAprovedtxtLbl: UILabel!
	
	@IBOutlet weak var ExpenseTypetxtLbl: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
