//
//  MyTeamtblCell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 9/24/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class MyTeamtblCell: UITableViewCell {
	
	@IBOutlet weak var nameLbl: UILabel!
	
	@IBOutlet weak var MobilenumberLbl: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
