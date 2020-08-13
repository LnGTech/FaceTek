//
//  AbsentHeaderCell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/25/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class AbsentHeaderCell: UITableViewCell {

    @IBOutlet weak var lblTimings: UILabel!
    @IBOutlet weak var lblShiftName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var Btnclk: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
