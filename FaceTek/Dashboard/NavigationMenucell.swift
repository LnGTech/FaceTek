//
//  NavigationMenucell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/2/20.
//  Copyright © 2020 sureshbabu bandaru. All rights reserved.
//

import UIKit

class NavigationMenucell: UITableViewCell {

    @IBOutlet weak var NavigationMenuLbl: UILabel!
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
