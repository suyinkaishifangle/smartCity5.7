//
//  ParkingModel.swift
//  smartCity
//
//  Created by MuY on 2018/4/19.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation

struct ParkingDetailModel:HandyJSON {
    var  parkingAddress:String = ""   // 停车场地址
    var isChargePile:Int = 0    //是否含有充电桩（0没有1有）
    var parkingName:String = ""   // 停车场名字
    var latitude:Double = 0   //  停车场纬度
    var longitude:Double = 0   //停车场经度
    var imageUrl:String  = ""  //   图片url
    var payWay:String  = ""  //   支付方式
    var operatorStatus:String  = ""  //   运营商性质
    var parkingOperator:String = ""   //  运营商
    var parkingReferencee:String = ""   //   停车场收费参考
    var chargeReferencee:String = ""   //    2
    var parkingInfo:String  = ""  //   停车场基本信息简介
    var insideNo:Int = 0 //   室内停车场总车位数
    var outsideNo:Int = 0 //  室外停车场总车位数
    var slowChargeEmptyNo:Int = 0 //   剩余慢充数量
    var slowChargeNo:Int = 0 //    慢充总数量
    var fastChargeNo:Int = 0 //        快充总数量
    var fastChargeEmptyNo:Int = 0 //   剩余快充数量
    var outsideEmptyNo :Int = 0 //          剩余室外数量
    var parkingId:Int = 0 //   计费模型
    var insideEmptyNo:Int = 0 //     剩余室内数
    var parkingType:String = ""   //   类型
    var openTime:String = ""   //   开放时间
    var distance:Float = 0    //   距离
    var stopNo:Int = 0    // 车位总共停车次数
}

