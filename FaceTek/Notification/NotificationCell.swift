//
//  NotificationCell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/9/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

	
	@IBOutlet weak var notificationHeaderlbl: UILabel!
	
	@IBOutlet weak var NotificationDatelbl: UILabel!
	
	@IBOutlet weak var Notificationmsglbl: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
