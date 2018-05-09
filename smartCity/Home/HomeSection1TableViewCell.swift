//
//  HomeSection1TableViewCell.swift
//  smartCity
//
//  Created by MuY on 2018/4/2.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class HomeSection1TableViewCell: UITableViewCell {

    var superVC:UIViewController?
    @IBAction func parkingButtonClick(_ sender: UIButton) {
        let vc = ParkingDetailViewController()
        superVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saoMaButtonClick(_ sender: Any) {
        superVC?.navigationController?.pushViewController(SaoMaViewController(), animated: true)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
