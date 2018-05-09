//
//  HomePageModel.swift
//  smartCity
//
//  Created by MuY on 2018/3/28.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation

struct HomePageModel:HandyJSON{
    var rollPics = [RollPics]()// "rollPics数组[] 顶部图片"
    var isParking:Int = 0      //    是否有停车(0没有1有)
    var isMessage:Int = 0     //     0没有1有
    var wallet:String = ""    //     钱包
    var serverMessage :String = ""    //    服务通知
    var  parkinglots = [ParkingList]() //附近停车场
    
}
struct RollPics:HandyJSON {
    var rollImageUrl:String = ""    //    图片URL地址
    var  hypeLink:String = ""    //跳转链接
    var msg :String = ""    //    备注消息
}
struct ParkingList:HandyJSON{
    var  parkingAddress:String = ""   //停车场地址
    var isChargePile:Int = 0    //是否含有充电桩（0没有1有）
    var parkingId:String = ""           //停车场编号
    var parkingName:String = ""         //停车场名字
    var latitude:Double = 0    //   停车场纬度
    var longitude:Double = 0   //  停车场经度
    var imageUrl:String = ""     //    图片url
    var parkingPrice:String = ""     //    停车价格
    var chargePrice:String = ""   //    充电价格
    var insideEmptyNo:Int = 0     //    剩余室内数量
    var outsideEmptyNo:Int = 0    //    剩余室外数
    var slowChargeEmptyNo:Int = 0    //    剩余慢充数量
    var fastChargeEmptyNo:Int = 0    //    剩余快充数量
    var tag:String = ""     //    停车场：24小时、室外停车、室内停车  充电桩：24小时、不对外开放、免费停车
    var parkingType:Int = 0    //    1 露天停车， 2 室内停车，6室内充电桩，7占道泊位充电桩
    var  parkingNo:Int = 0    //     停车场总车位数
    var distance:Float = 0   //    距离
}

