//
//  timesheettblcell.swift
//  FaceTek
//
//  Created by sureshbabu bandaru on 4/28/21.
//  Copyright © 2021 sureshbabu bandaru. All rights reserved.
//

import UIKit

class timesheettblcell: UITableViewCell {
	@IBOutlet weak var subtasktbllbl: UILabel!
	@IBOutlet weak var hrslbl: UILabel!
	@IBOutlet weak var tableviewsubtaskcellbackview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
