//
//  Tools.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation
import UIKit

let SCALE = UIScreen.main.scale
let BOUNDS = UIScreen.main.bounds
let SCREEN_width = UIScreen.main.bounds.width
let SCREEN_height = UIScreen.main.bounds.height

/// JSONString转换为字典
///
/// - Parameter jsonString: json
/// - Returns: 字典
func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
    
    
}

//字典转json字符串
func getJsonStringFromDictioanry(dict:NSDictionary)->String{
    if (!JSONSerialization.isValidJSONObject(dict) ){
        return ""
    }
    let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    let jsonString = String.init(data: data!, encoding: .utf8)
    return jsonString!
    
}

func getAttributyString(_ sourceArray:Array<(string:String?,color:UIColor,size:CGFloat)>)->NSMutableAttributedString{
    let resultString = NSMutableAttributedString()
    for source in sourceArray {
        if source.string != nil{
            resultString.append(NSAttributedString(string: source.string!, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: source.size),NSAttributedStringKey.foregroundColor:source.color]))
        }
        
    }
    return resultString
}

//根据宽度计算高度
func getTextHeight(text:String,font:UIFont,width:CGFloat)->CGFloat{
    var textSize = (text as NSString).boundingRect(with: CGSize.init(width: width, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    if textSize.height <= 20{
        textSize.height = 20
    }
    return textSize.height
    
}
//根据高度计算宽度
func getTextWidth(text:String,font:UIFont,height:CGFloat)->CGFloat{
    var textSize = (text as NSString).boundingRect(with: CGSize.init(width: 0, height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    if textSize.width <= 20{
        textSize.width = 20
    }
    return textSize.width
    
}
//解析本地数据
func deserializeLocationJson(fileName:String,finish:(_ json:Any)->Void){
    
    let path = Bundle.main.path(forResource:fileName, ofType: "json")
    if path != nil{
        let data =  try? Data(contentsOf: URL(fileURLWithPath: path!))
        if data != nil{
            let json:NSDictionary = try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            finish(json["data"]!)
        }else{
            print("获取本地文件路径错误")
        }
    }else{
        print("数据错误")
    }
}

