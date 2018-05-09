//
//  CircularBeadAndLineClass.swift
//  smartCity
//
//  Created by MuY on 2018/4/5.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation


class LineLabel:UILabel{
    override func awakeFromNib() {
        super.awakeFromNib()
        for line in self.constraints{
            if line.constant == 1{
                line.constant = 1/UIScreen.main.scale
            }
        }
    }
}
//imageView的圆角
class CircularBeadImageView:UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}
