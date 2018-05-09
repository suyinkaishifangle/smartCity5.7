//
//  HomeTagCollectionViewCell.swift
//  smartCity
//
//  Created by MuY on 2018/4/5.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class HomeTagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(model:(image:UIImage,title:String)){
        headImage.image = model.image
        titleLabel.text = model.title
    }

}
