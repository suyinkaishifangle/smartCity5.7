//
//  MineViewController.swift
//  smartcity
//
//  Created by ShuCai on 16/10/6.
//  Copyright © 2016年 ShuCai. All rights reserved.
//

import UIKit



class MineViewController: UIViewController,testDelegete,UITableViewDelegate,UITableViewDataSource{
    
    var detailLabel:UILabel?
    @IBOutlet weak var _tableView: UITableView!
    
    var datasource:[[(title:String,imageIcon:UIImage?)]]
    = [[("我的账户",#imageLiteral(resourceName: "mine_wallet"))],
      [("",nil)],
      [("账户充值",#imageLiteral(resourceName: "mine_AccountRecharge")),("车辆管理",#imageLiteral(resourceName: "mine_ChargingRecord")),("我的消息",#imageLiteral(resourceName: "mine_wallet"))],
      [("充电记录",#imageLiteral(resourceName: "mine_ChargingRecord")),("停车记录",#imageLiteral(resourceName: "mine_ChargingRecord")),("发票与报销",#imageLiteral(resourceName: "mine_ChargingRecord"))],
      [("离线地图",#imageLiteral(resourceName: "mine_ChargingRecord")),("分享马仆",#imageLiteral(resourceName: "mine_ChargingRecord")),("关于我们",#imageLiteral(resourceName: "mine_ParkingRecord"))],
      [("",nil)]
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MineViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        title = "个人中心"
        super.viewDidLoad()
        _tableView.register(UINib.init(nibName: "MineAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MineAccountTableViewCell")
    } 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let meHeadView = Bundle.main.loadNibNamed("MineHeadView", owner: self, options: nil)?.last as! MineHeadView
            meHeadView.nickName.text  =  "点击登录"
            return meHeadView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 150
        }else if section == 1{
            return 0.001
        }
        return 10
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 60
        }
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineAccountTableViewCell") as! MineAccountTableViewCell
            return cell
        }else if indexPath.section == 5{
            let cell = UITableViewCell()
            let logoutLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_width, height: 44))
            logoutLabel.text = "退出登录"
            logoutLabel.font = UIFont.boldSystemFont(ofSize: 16)
            logoutLabel.textColor = UIColor.blue
            logoutLabel.textAlignment = .center
            cell.contentView.addSubview(logoutLabel)
            return cell
        }else{
            let model = datasource[indexPath.section][indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                detailLabel = UILabel.init(frame: CGRect.init(x: 60, y: 0, width: SCREEN_width - 60, height: 44))
                detailLabel?.text = model.title
                cell?.contentView.addSubview(detailLabel!)
            }
            cell?.imageView?.image = model.imageIcon
            cell?.accessoryType = .disclosureIndicator
           
            return cell!
        }
        
        
        }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let logView = LogInView.init(frame: UIScreen.main.bounds)
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.addSubview(logView)
    }
    func testFunc(index: Int) {
        print("测试代理---\(index)")
        
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



