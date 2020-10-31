//
//  PendingHeadercell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 7/28/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class PendingHeadercell: UITableViewCell {
    
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
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
