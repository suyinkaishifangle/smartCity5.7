//
//  PaymentViewController.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {
    
 
    
    @IBOutlet weak var toolBarView: UIView!//总金额tool
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var selectTotalPrice: UILabel!
    @IBOutlet weak var allSelectButton: UIButton!
    @IBOutlet weak var toolBarHeight: NSLayoutConstraint!//
    @IBOutlet weak var paymentButton: UIButton!
    
    
    //MARK:----------view生命周期--------
    override func viewDidLoad() {
        title = "缴费"
       
    }
   
    //MARK:----------全选按钮--------
    @IBAction func totalSelectButtonClick(_ sender: UIButton) {
     
    }
    
}

extension PaymentViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

