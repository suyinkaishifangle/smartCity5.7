//
//  ParkingDatasource.swift
//  smartCity
//
//  Created by MuY on 2018/4/10.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

final class ParkingDatasource: NSObject {

    static let shared = ParkingDatasource()
    private override init() {}
    
    class Condition{
        var lot:String = "" // 经度
        var lat:String = "" //纬度
        var cityName:String = "" //城市名称
        var sort:Int = 0 //  "0 默认综合 1停车价格最低，2充电价格最低， 3免费停车，4，24小时 5,停车场空闲优先，6停车场距离最近
        var keyword:String = ""
    }
    
    var data = [ParkingList]()
    let condition = Condition()
    
    @objc dynamic var conditionHaveBeenChanged:Bool = false
    @objc dynamic var datasourceHaveBeenChanges:Bool = false
    
  var islast = false //判断是否是最后一条数据
    var isUpdata = false //防止重复加载
    var currentPage = 1
    
    func getData(view:UIView){
         currentPage = 1
        weak var weakSelf = self
        let handle = NetWorkHandle.init(binTag: "停车场列表", currentView: view)
        let  param =  ["lot":condition.lot,"lat":condition.lat,"cityName":condition.cityName,"sort":condition.sort,"pageSize":15,"pageNum":currentPage,"keyword":condition.keyword] as [String : Any]
        handle.httpPostRequest(url: ApiManager.ParkingApi.parkingNumListAddress, params: param) { (success, result, _) in
            if success{
                var array = [ParkingList]()
                let jsonArray = JSONDeserializer<ParkingList>.deserializeModelArrayFrom(array: result as? NSArray)
                array = jsonArray! as! [ParkingList]
               weakSelf?.currentPage += 1
                weakSelf?.islast = array.count <= 0 ? true : false
                weakSelf?.data = array
               weakSelf?.datasourceHaveBeenChanges = true
            }
        }
    }
    //上拉加载更多
    func loadMore(view:UIView){
        print("more")
        if islast == true{
            return
        }
        if isUpdata == true{
            return
        }
         weak var weakSelf = self
        isUpdata = true
        let handle = NetWorkHandle.init(binTag: "停车场列表", currentView: view)
        let  param =  ["lot":condition.lot,"lat":condition.lat,"cityName":condition.cityName,"sort":condition.sort,"pageSize":15,"pageNum":currentPage,"keyword":condition.keyword] as [String : Any]
        handle.httpPostRequest(url: ApiManager.ParkingApi.parkingNumListAddress, params: param) { (success, result, _) in
            weakSelf?.isUpdata = false
            if success{
                for dict in result as! NSArray{
                    weakSelf?.data.append(JSONDeserializer<ParkingList>.deserializeFrom(dict: dict as? NSDictionary)!)
                }
                weakSelf?.currentPage += 1
                weakSelf?.islast = (result as! NSArray).count <= 0 ? true : false
                weakSelf?.datasourceHaveBeenChanges = true
            }
        }
    }
}
