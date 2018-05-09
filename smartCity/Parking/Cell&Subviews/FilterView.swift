//
//  FilterView.swift
//  smartCity
//
//  Created by MuY on 2018/4/11.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class FilterView: UIView,UITableViewDelegate,UITableViewDataSource {

    var lastSelected = 0
    var selectedIndex:((Int)->Void)?
    var datasource = [String]()
    var _tableView:UITableView!
    
    init(frame:CGRect,titleArray:[String],lastSelected:Int){
       super.init(frame: frame)
        self.datasource = titleArray
        self.lastSelected = lastSelected
        InitView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func InitView(){
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        let maskButton = UIButton.init(frame: self.bounds)
        maskButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        _tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: Int(SCREEN_width), height: datasource.count * 44), style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.backgroundColor = UIColor.clear
        _tableView.register(UINib(nibName: "ChekTableViewCell", bundle: nil), forCellReuseIdentifier: "ChekTableViewCell")
        self.addSubview(maskButton)
        self.addSubview(_tableView)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    @objc func dismiss(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .allowUserInteraction, animations: {
            weakSelf?.alpha = 0
        }) { (complete) in
            weakSelf?.removeFromSuperview()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChekTableViewCell") as! ChekTableViewCell
        cell.titleLabel.text = datasource[indexPath.row]
        if lastSelected == indexPath.row{
            cell.selectImage.isHidden = false
        }else{
            cell.selectImage.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for i in 0..<datasource.count{
            let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as! ChekTableViewCell
            if i == indexPath.row{
                //如果是选中的当前单元格，那么 图片显示否者图片隐藏
                cell.selectImage.isHidden = false
            }else{
                cell.selectImage.isHidden = true
            }
        }
        if selectedIndex != nil{
           selectedIndex!(indexPath.row)
            dismiss()
        }
    }
}
