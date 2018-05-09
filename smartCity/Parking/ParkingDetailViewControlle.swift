//
//  ParkingDetailViewController.swift
//  smartCity
//
//  Created by MuY on 2018/4/19.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class ParkingDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var datasourceModel:ParkingDetailModel?
    var pplotid:String?
    var  detailLabel:UILabel!
    @IBOutlet weak var _tableView: UITableView!
    
    var datasource:[[(title:Any?,titleDetail:String)]] = [[(nil,"")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "站点详情"
        
        _tableView.register(UINib.init(nibName: "PakingDetailHeadTableViewCell", bundle: nil), forCellReuseIdentifier: "PakingDetailHeadTableViewCell")
        //教室没网络的情况下可以拿本地数据展示
        deserializeLocationJson(fileName: "站点详情数据") { (result) in
            let model:ParkingDetailModel = JSONDeserializer<ParkingDetailModel>.deserializeFrom(dict: result as? NSDictionary)!
            datasourceModel = model
            datasource = [[(nil,""),(#imageLiteral(resourceName: "map_address"),(model.parkingAddress)),(#imageLiteral(resourceName: "map_Parking_N"), "室内\(model.insideEmptyNo) | 室外\(model.outsideEmptyNo)"),(#imageLiteral(resourceName: "map_Charging_pile_N"),"快充\(model.fastChargeEmptyNo) | 慢充\(model.slowChargeEmptyNo)")],[("运 营 商",(model.parkingOperator)),("支付方式",(model.payWay)),("充电单价","未知"),("停 车 费","未知"),("车位数量","室内\(model.insideNo) 室外\(model.outsideNo)"),("电桩数量","快充 \(model.fastChargeNo) 慢充\(model.slowChargeNo)")]]
            _tableView.reloadData()
            
        }
       // 有网的时候用这个方法
       // getData(currentView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 10
        }
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 120
            }
            return 50
        }
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PakingDetailHeadTableViewCell") as! PakingDetailHeadTableViewCell
                if datasourceModel?.imageUrl != nil{
                    cell.headImage.sd_setImage(with: URL.init(string: (datasourceModel?.imageUrl)!), completed: nil)
                }

                cell.titleLabel.text = datasourceModel?.parkingName
                cell.openTimeLabel.text = datasourceModel?.openTime
                cell.typeLabel.text = datasourceModel?.parkingType
                return cell
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil{
                    cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                }
                cell?.imageView?.image = datasource[indexPath.section][indexPath.row].title as? UIImage
                cell?.textLabel?.text = datasource[indexPath.section][indexPath.row].titleDetail
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil{
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
                detailLabel = UILabel.init(frame: CGRect.init(x: 100, y: 0, width: SCREEN_width - 100 , height: 50))
                  cell?.contentView.addSubview(detailLabel)
            }
            cell?.textLabel?.text = datasource[indexPath.section][indexPath.row].title as? String
            cell?.textLabel?.textColor = UIColor.darkGray
            
            detailLabel.text = datasource[indexPath.section][indexPath.row].titleDetail
            detailLabel.textAlignment = .left
          
//            cell?.detailTextLabel?.text = datasource[indexPath.section][indexPath.row].titleDetail
           // cell?.detailTextLabel?.textAlignment = .left
            
            return cell!
        }
    }

    func getData(currentView:UIView){
       weak var weakSelf = self
        let handle = NetWorkHandle.init(binTag: "站点详情", currentView: currentView)
        handle.httpPostRequest(url: ApiManager.ParkingApi.parkingDetailAddress, params: ["pplotid":pplotid!]) { (complete, result, _) in
            
            if complete{
                let model:ParkingDetailModel = JSONDeserializer<ParkingDetailModel>.deserializeFrom(dict: result as? NSDictionary)!
                weakSelf?.datasourceModel = model
                weakSelf?.datasource = [[(nil,""),(#imageLiteral(resourceName: "map_address"),(model.parkingAddress)),(#imageLiteral(resourceName: "map_Parking_N"), "室内\(model.insideEmptyNo) | 室外\(model.outsideEmptyNo)"),(#imageLiteral(resourceName: "map_Charging_pile_N"),"快充\(model.fastChargeEmptyNo) | 慢充\(model.slowChargeEmptyNo)")],[("运 营 商",(model.parkingOperator)),("支付方式",(model.payWay)),("充电单价","未知"),("停 车 费","未知"),("车位数量","室内\(model.insideNo) 室外\(model.outsideNo)"),("电桩数量","快充 \(model.fastChargeNo) 慢充\(model.slowChargeNo)")]]
                weakSelf?._tableView.reloadData()
            }
        }
    }
   
}
