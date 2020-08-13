//
//  ManagerLeavecell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/30/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class ManagerLeavecell: UITableViewCell {
    
    @IBOutlet weak var NameLbl: UILabel!
    
    
    @IBOutlet weak var DayscntLbl: UILabel!
    @IBOutlet weak var LeaveDatesLbl: UILabel!
    @IBOutlet weak var LeaveTypeLbl: UILabel!
    @IBOutlet weak var ShiftLbl: UILabel!

    @IBOutlet weak var RemarkLbl: UILabel!
    
    @IBOutlet weak var LeaveStsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
