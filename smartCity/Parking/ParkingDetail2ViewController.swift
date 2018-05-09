//
//  ParkingDetail2ViewController.swift
//  smartCity
//
//  Created by MuY on 2018/4/24.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class ParkingDetail2ViewController: UIViewController {

    @IBOutlet weak var sdsdf: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    var pplotid:String?
   // var datasourceModel:ParkingDetailModel?
    @IBOutlet weak var parkingType: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var parkingAddress: UILabel!
    @IBOutlet weak var chargeEmptyNo: UILabel!
    @IBOutlet weak var parkingEmptyNo: UILabel!
    @IBOutlet weak var parkingOprator: UILabel!
    @IBOutlet weak var payWay: UILabel!
    @IBOutlet weak var chargePrice: UILabel!
    @IBOutlet weak var parkingPrice: UILabel!
    @IBOutlet weak var totalChargePileNo: UILabel!
    @IBOutlet weak var totalPrkingNo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
viewHeight.constant = 900
        
       getData(currentView: view)
    }
    func refreshView(model:ParkingDetailModel){
        headImage.sd_setImage(with: URL.init(string: model.imageUrl), completed: nil)
        parkingName.text = model.parkingName
        openTime.text = "开放时间：\(model.openTime)"
        parkingType.text = "停车类型:\(model.parkingType)"
        parkingAddress.text = model.parkingAddress
        parkingEmptyNo.text = "室内：\(model.insideEmptyNo) 室外：\(model.outsideEmptyNo)"
        chargeEmptyNo.text = "快充：\(model.fastChargeEmptyNo) 慢充：\(model.slowChargeEmptyNo)"
        
        parkingOprator.text = model.parkingOperator
        payWay.text = model.payWay
        chargePrice.text = "未知"
        parkingPrice.text = "未知"
        totalPrkingNo.text = "室内：\(model.insideNo) 室外：\(model.outsideNo)"
        totalChargePileNo.text = "快充：\(model.fastChargeNo) 慢充：\(model.slowChargeNo)"
    }
    func getData(currentView:UIView){
        weak var weakSelf = self
        let handle = NetWorkHandle.init(binTag: "站点详情", currentView: currentView)
        handle.httpPostRequest(url: ApiManager.ParkingApi.parkingDetailAddress, params: ["pplotid":pplotid!]) { (complete, result, _) in
            
            if complete{
                let model:ParkingDetailModel = JSONDeserializer<ParkingDetailModel>.deserializeFrom(dict: result as? NSDictionary)!
              //  weakSelf?.datasourceModel = model
               weakSelf?.refreshView(model: model)
                
            }
        }
    }
    @IBAction func daoHangButtonClick(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
