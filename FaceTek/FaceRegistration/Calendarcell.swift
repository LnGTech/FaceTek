//
//  Calendarcell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/27/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class Calendarcell: UITableViewCell {

    @IBOutlet weak var Bckview: UIView!
    
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var EventdayLbl: UILabel!
    
    @IBOutlet weak var DateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
