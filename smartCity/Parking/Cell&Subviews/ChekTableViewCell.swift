//
//  ChekTableViewCell.swift
//  smartCity
//
//  Created by MuY on 2018/4/11.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class ChekTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
