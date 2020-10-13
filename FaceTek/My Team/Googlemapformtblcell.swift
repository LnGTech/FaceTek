//
//  Googlemapformtblcell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/29/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class Googlemapformtblcell: UITableViewCell {

	@IBOutlet weak var ClientPlaceView: UIView!
	
	
	@IBOutlet weak var VisitDatetimeView: UIView!
	
	@IBOutlet weak var timespentView: UIView!
	
	@IBOutlet weak var KmtravelView: UIView!
	
	@IBOutlet weak var VisitPurposeView: UIView!
	
	
	@IBOutlet weak var VisitOutcomeView: UIView!
	
	@IBOutlet weak var AddressView: UIView!
	
	
	@IBOutlet weak var ClientPlaceNameLbl: UILabel!
	
	@IBOutlet weak var VisitDtetimeLbl: UILabel!
	
	@IBOutlet weak var TimespentLbl: UILabel!
	
	@IBOutlet weak var KmtravelLbl: UILabel!
	
	
	@IBOutlet weak var VisitPurposeLbl: UILabel!
	
	@IBOutlet weak var VisitOutcomeLbl: UILabel!
	
	@IBOutlet weak var AddressLbl: UILabel!
	
	
	@IBOutlet weak var ClientPlacetxtLbl: UILabel!
	
	@IBOutlet weak var VisitdatetxtLbl: UILabel!
	
	
	
	@IBOutlet weak var timespenttxtLbl: UILabel!
	
	@IBOutlet weak var KmTraveltxtLbl: UILabel!
	
	@IBOutlet weak var VisitpurposetxtLbl: UILabel!
	
	@IBOutlet weak var VisitOutcometxtLbl: UILabel!
	
	
	@IBOutlet weak var AddresstxtLbl: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
