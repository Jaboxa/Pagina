//
//  StoryTableViewCell.swift
//  Pagina
//
//  Created by Alice Darner on 2018-02-06.
//  Copyright © 2018 dogbird. All rights reserved.
//

import UIKit
import Firebase

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
