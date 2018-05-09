//
//  WithOutDataView.swift
//  smartcity
//
//  Created by csoone on 2017/4/6.
//  Copyright © 2017年 ShuCai. All rights reserved.
//

import UIKit

class WithOutDataMaskView: UIView {

    var titleString:String?
    var finsh: (() -> Void)?
    init(frame:CGRect,title:String,buttonClick:(() -> Void)?) {
        super.init(frame: frame)
        self.finsh = buttonClick
        self.titleString = title
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.backgroundColor = UIColor.groupTableViewBackground
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 40))
        label.center = CGPoint.init(x: self.center.x, y: self.center.y*0.6)
        label.textAlignment = .center
        label.text = titleString
        label.textColor = UIColor.darkGray
        self.addSubview(label)
        let button = UIButton.init(frame: CGRect.init(x:0 , y: 0, width: 70, height: 30))
        button.center = CGPoint.init(x: self.center.x, y: self.center.y*0.6 + 40)
        button.setTitle("重新获取", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(getData), for:.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1 / UIScreen.main.scale
        button.layer.borderColor = UIColor.darkGray.cgColor
        self.addSubview(button)
    }
    @objc func getData(){
        finsh!()
    }
    

}
