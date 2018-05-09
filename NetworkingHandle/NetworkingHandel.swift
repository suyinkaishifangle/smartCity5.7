//
//  NetworkingHandel.swift
//  smartcity
//
//  Created by 所能 on 2018/4/13.
//  Copyright © 2018年 csoone. All rights reserved.
//

import UIKit
import Foundation
let HOST:String = "https://parking.csoone.com/testapp"//正式服务器

let HttpCache = "HttpRequestCache"

enum ResponseType {
    case data
    case msg
}
enum RequestType{
    case RequestTypeGet
    case RequestTypePost
    case RequestTypeUpLoad//图片上传
}

struct BaseHandle:HandyJSON{
    var code:Int?
    var msg:String = ""
    var data:Any?
}

class NetWorkHandle:NSObject{

    //返回类型 有时候在数据成功后只返回msg 如上传成功等
    var responseType:ResponseType?
    //接口参数名  在一个页面有多个接口的时候方便标记
    var needToken:Bool?
    var showToast:Bool?
    var binTag:String = ""
    var currentView:UIView?

    init(binTag:String,currentView:UIView?){
        self.binTag = binTag
        self.currentView = currentView
        responseType = .data
        needToken = true
        showToast = true
    }
    
    //MARK: - Get方法(默认方法)
    /**
     # Get不需要进行缓存
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     */
    func httpGetRequest(url:String,params:[String:Any]?, finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?) ->Void){
        httpRequestWith(url: url, params: params, requstType: .RequestTypeGet, isCache: false, cacheKey: nil, imageData: nil, finish: finish)
    }
   
    /**
     # Get需要进行缓存
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     */
    func httpGetCacheRequest(url:String,params:[String:Any]?, finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?)->Void){
        httpRequestWith(url: url, params: params, requstType: .RequestTypeGet, isCache: false, cacheKey: nil, imageData: nil, finish: finish)
    }
    
    //MARK: - - Post方法
    /**
     # Post不需要缓存
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     */
    
    func httpPostRequest(url:String,params:[String:Any]?, finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?)->Void){
        httpRequestWith(url: url, params: params, requstType: .RequestTypePost, isCache: false, cacheKey: nil,imageData: nil,  finish: finish)
    }

    /**
     # Post需要缓存
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     */
    func httpPostCacheRequest(url:String,params:[String:Any]?, finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?)->Void){
        httpRequestWith(url: url, params: params, requstType: .RequestTypePost, isCache: false, cacheKey: nil, imageData: nil, finish: finish)
    }
    
    //MARK: -- 上传图片方法
    /**
     # 上传单张图片
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     - Parameter  imageData: 图片
     */
    func upLoadDataWith(url:String,params:[String:Any]?,imageData:[(imageName:String,fileName:String,image:UIImage)], finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?)->Void){
        httpRequestWith(url: url, params: params, requstType: .RequestTypeUpLoad, isCache: false, cacheKey: nil,imageData: imageData, finish: finish)
    }
    
    //MARK: - - 网络请求统一处理
    /**
     # 网络请求统一处理
     - Parameter  url: 接口名
     - Parameter  params: 参数，如果不需要可以nil
     - Parameter  dataArray: 图片数组
     - Parameter  isCache: 是否缓存标志
     - Parameter  cacheKey: 缓存的对应key值
     - Parameter  imageData:  图片数组（里面是图片的数据）
     */
    func httpRequestWith(url:String,params:[String:Any]?,requstType:RequestType,isCache:Bool,cacheKey:String?,imageData:[(imageName:String,fileName:String,image:UIImage)]?,finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?) ->Void){
        var param = params
        if param == nil{
            param = [String:Any]()
        }
        //通用的字段放里面
        if needToken == true{
            let phone = UserDefaults.standard.object(forKey: "userPhone") as? String
            let token = UserDefaults.standard.object(forKey: "userToken") as? String
            if phone != nil{
                param!["token"] = token
            }
            if token != nil{
                param!["phone"] = phone
            }
        }
        //打印日志
        print("<\(binTag)>地址->", url)
        for (key,value) in param!{
            print("<\(binTag)>参数-> \(key)=\(value)")
        }
        //设置YYCache属性
        let cache = YYCache.init(name:HttpCache)
        cache?.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = true
        cache?.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = true
        
        if showToast == true && currentView != nil{
            LWProgressHUD.shared.show(currentView: currentView!)
        }
        var cacheData:Any?
        if isCache == true{
            cacheData  = cache?.object(forKey: cacheKey!)
            if cacheData != nil{
                returnDataWithRequestData(requestData: cacheData! as! Data, finish: finish)
                return
            }
        }
        
        let manager = AFHTTPSessionManager.manager_swift()
        manager.responseSerializer.acceptableContentTypes = ["application/json","text/json","text/javascript","text/html"]
        manager.requestSerializer.timeoutInterval = 15
        let securityPolicy = AFSecurityPolicy.default()
        securityPolicy.allowInvalidCertificates = true
        let cerpath = Bundle.main.path(forResource: "nginx", ofType: "cer")
        let cerData = NSData(contentsOfFile: cerpath!)
        securityPolicy.pinnedCertificates = [cerData! as Data]
        manager.securityPolicy = securityPolicy
        manager.securityPolicy.validatesDomainName = false
        
        // weak var weakSelf = self
        switch requstType {
        //get请求
        case .RequestTypeGet:
            manager.get(url, parameters: param, progress: nil, success: { (task, rsponseObject) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.disposeDataWith(responseData:rsponseObject , cacheUrl: url, cacheData: cacheData, isCache: isCache, cache: cache!, cacheKey: cacheKey, finish: finish)
            }, failure: { (task, error) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.showErrorMsg(error: error)
            })
            
        //post请求
        case .RequestTypePost:
            manager.post(url, parameters: param, progress: nil, success: { (operation, rsponseObject) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.disposeDataWith(responseData:rsponseObject, cacheUrl: url, cacheData: cacheData, isCache: isCache, cache: cache!, cacheKey: cacheKey, finish: finish)
            }, failure: { (operation, error) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.showErrorMsg(error: error)
            })
            
        //图片上传
        case .RequestTypeUpLoad:
            let timeInterval = NSDate().timeIntervalSince1970 * 1000
            manager.post(url, parameters: param, constructingBodyWith: { (data) in
                for (index,_image) in imageData!.enumerated(){
                    //压缩
                    let representaionImage = UIImageJPEGRepresentation(_image.image,0.5)
                    data.appendPart(withFileData: representaionImage!, name: _image.imageName, fileName: "\(_image.fileName)\(Int64(timeInterval))\(index+1).jpg", mimeType: "image/jpg")
                }
            }, progress: nil, success: { (operation, rsponseObject) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.disposeDataWith(responseData:rsponseObject  , cacheUrl: url, cacheData: cacheData, isCache: isCache, cache: nil, cacheKey: nil, finish: finish)
            }, failure: { (operation, error) in
                if self.showToast == true{
                    LWProgressHUD.shared.dismiss()
                }
                self.showErrorMsg(error: error)
            })
        }
    }
    //MARK: - 统一处理请求到的数据
    func  disposeDataWith(responseData:Any?,cacheUrl:String,cacheData:Any?,isCache:Bool,cache:YYCache?,cacheKey:String?,finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?) ->Void){
        
       let json = getJsonStringFromDictioanry(dict: responseData as! NSDictionary)
          print("<\(self.binTag)>的原始数据:\(json)")
        if isCache == true{
            //进行缓存
            cache?.setObject(json as NSCoding, forKey: cacheKey!)
        }
        //不管缓不缓存都需要显示数据
        returnDataWithRequestData(requestData: responseData, finish: finish)
        
    }
    //根据返回的数据进行统一的格式处理 解析
    func returnDataWithRequestData(requestData:Any?,finish:@escaping (_ succeed:Bool,_ result:Any?,_ code:Int?) ->Void){
            if requestData is NSDictionary{
                //去除null空值
//                let  response = (requestData as! NSDictionary).replacingNullsWithBlanks() as NSDictionary
                let jsonModel:BaseHandle = JSONDeserializer<BaseHandle>.deserializeFrom(dict: requestData as? NSDictionary)!
                //code 0 成功 -1失败
                if jsonModel.code == 0{
                    finish(true,responseType == .data ? jsonModel.data : jsonModel.msg,0)
                }else if jsonModel.code == 2 || jsonModel.code == -9 || jsonModel.code == -8{
                    //特殊数字需要做的事情
                  //  showLogView(code:jsonModel.code!)
                }else{
                    if currentView != nil{
                       LWMessage.show(message: jsonModel.msg == "" ? "数据异常": "\(jsonModel.msg)", window: currentView!.window)
                    }
                    finish(false,jsonModel.msg,jsonModel.code)
                }
            }else{
                if currentView != nil{
                   LWMessage.show(message:  "数据格式错误", window: currentView!.window)
                }
                finish(false,"数据格式错误",nil)
            }
    }
    //网络请求失败后弹窗提示用户原因
    func showErrorMsg(error:Error){
        
        LWMessage.show(message:  "连接服务器失败,错误提示：\(error.localizedDescription)", window: self.currentView!.window)
        debugPrint("网络请求错误--->：\(error.localizedDescription)")
    }
}

