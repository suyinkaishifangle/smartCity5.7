//
//  BaseViewController.swift
//  smartCity
//
//  Created by MuY on 2018/4/25.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var maskViewRefreshData:(()->Void)?
    var maskViewTitle = "暂无数据"
    var maskView:WithOutDataMaskView!
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
         maskView = WithOutDataMaskView.init(frame: BOUNDS, title: maskViewTitle) {
            weakSelf?.maskViewRefreshData?()
        }
        maskView.isHidden = true
        view.addSubview(maskView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
