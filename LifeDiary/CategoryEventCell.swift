//
//  CategoryEventCell.swift
//  LifeDiary
//
//  Created by Машенька on 28.07.2020.
//  Copyright © 2020 m.v.deshina. All rights reserved.
//

import UIKit

class CategoryEventCell: UITableViewCell {

    @IBOutlet weak var eventColor: UIView!
    @IBOutlet weak var eventCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
