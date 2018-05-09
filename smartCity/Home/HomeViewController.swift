//
//  HomeViewController.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController,SDCycleScrollViewDelegate {
    
    var locationManager = CLLocationManager()
    var sdcycleScrollView:SDCycleScrollView!
    var dataSource:HomePageModel?
    var maskView:UIView?
    @IBOutlet weak var _tableView: UITableView!
    //    override func viewWillLayoutSubviews() {
    //
    //        super.viewWillLayoutSubviews()
    //        sdcycleScrollView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160)
    //
    //      _tableView.reloadData()
    //    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadLocation()
         // navigationController?.navigationBar.isTranslucent = false
                if #available(iOS 11.0, *) {
                    _tableView.contentInsetAdjustmentBehavior = .never
                    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
                    _tableView.scrollIndicatorInsets = _tableView.contentInset
                }else{
                    self.automaticallyAdjustsScrollViewInsets = false
              }
         //教室没网络的情况下可以拿本地数据展示
        deserializeLocationJson(fileName: "首页数据") { (model) in
             let model =    JSONDeserializer<HomePageModel>.deserializeFrom(dict: model as? NSDictionary)
            dataSource = model
            _tableView.reloadData()
        }
        //有网的时候用这个方法
       // getData(view: view)
        //把自定义的单元格注册到tableview里
        _tableView.register(UINib.init(nibName: "HomeSection1TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeSection1TableViewCell")
        
        _tableView.register(UINib.init(nibName: "HomeSection3TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeSection3TableViewCell")
        
        sdcycleScrollView =
            SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_width, height: 160), delegate: self, placeholderImage: UIImage.init(named: "home_bananer"))
        sdcycleScrollView.autoScrollTimeInterval = 3
    }
    
    func getData(view:UIView){
        weak var weakSelf = self
        let handle = NetWorkHandle.init(binTag: "首页", currentView: view)
        let param = ["longitude":"103.956197","latitude":"30.731878"]
        handle.httpPostRequest(url: ApiManager.HomeApi.homePageAddress, params: param) { (success, result, _) in
            if success{
                let model =    JSONDeserializer<HomePageModel>.deserializeFrom(dict: result as? NSDictionary)
                weakSelf?.dataSource = model
                weakSelf?._tableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    //设置section数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //设置区头高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 44
        }
        return 0.001
    }
    //设置区尾
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return 10
        }
        return 0.001
    }
    //设置tableview的区头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2{
            maskView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            maskView?.backgroundColor = UIColor.white
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: (maskView?.bounds.size.width)!, height: 44))
            label.text = "- 附近停车场 -"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            //            let line = UILabel.init(frame: CGRect.init(x: 0, y: maskView.bounds.size.height - SCALE, width: SCREEN_width, height: 1/UIScreen.main.scale))
            //            line.backgroundColor = UIColor.lightGray
            
            maskView?.addSubview(label)
            //maskView.addSubview(line)
            return maskView
        }
        return nil
        
    }
    
    //设置row的高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }else if indexPath.section == 1{
            return 80
        }else{
            return 135
        }
    }
    //设置每个section下的row的数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 2{
            return 1
        }
        //这里的5只是一个暂时的数字
        return (dataSource?.parkinglots.count)!
    }
    //设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = UITableViewCell()
            var imageArray = [String]()
                if (dataSource?.rollPics.count)! > 0{
                    for pic in (self.dataSource?.rollPics)!{
                        imageArray.append(pic.rollImageUrl)
                    }
                    sdcycleScrollView.imageURLStringsGroup = imageArray
                }
            cell.selectionStyle = .none
            cell.contentView.addSubview(sdcycleScrollView)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSection1TableViewCell")
                as! HomeSection1TableViewCell
            cell.superVC = self
            cell.selectionStyle = .none
            return cell
        }else{
            //第三个section里面也需要自定义单元格，可以暂时先写一个默认的
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSection3TableViewCell")
                as! HomeSection3TableViewCell
            if dataSource?.parkinglots != nil{
                let model = dataSource?.parkinglots[indexPath.row]
                cell.showData(model: model!)
            }
            return cell
        }
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("点击了第\(index)张图")
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    //打开定位
    func loadLocation(){
        locationManager.delegate = self
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //始终允许访问位置信息
        locationManager.requestAlwaysAuthorization()
        //使用应用程序期间允许访问位置数据
        locationManager.requestWhenInUseAuthorization()
        //开启定位
        locationManager.startUpdatingLocation()
        
    }
    
    //获取定位信息
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //取得locations数组的最后一个
        let location:CLLocation = locations[locations.count-1]
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            if locations.count > 0{
                LonLatToCity(currLocation:locations.last!)
            }
            //停止定位
            locationManager.stopUpdatingLocation()
        }
    }
    
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("定位失败")
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity(currLocation:CLLocation) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            if(error == nil){
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                print(mark.country)
            } else{
               print("城市解析失败")
            }
        }
    }
}

