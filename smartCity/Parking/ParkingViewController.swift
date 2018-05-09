//
//  ParkingViewController.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class ParkingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //导航view
    var titleView:UIView!
    var  filterLastIndex = 0
    var filterView :FilterView?
    var _searchBar:UISearchBar!
    @IBOutlet weak var distanceBtn: UIButton!
    @IBOutlet weak var kongXianBtn: UIButton!
    @IBOutlet weak var paiXuBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    var filterBtnArray = [UIButton]()
    var datasource = ParkingDatasource.shared
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        datasource.addObserver(self, forKeyPath: "conditionHaveBeenChanged", options: [.new,.old], context: nil)
        datasource.addObserver(self, forKeyPath: "datasourceHaveBeenChanges", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch  keyPath! {
        case "conditionHaveBeenChanged":
            datasource.getData(view: view)
        case "datasourceHaveBeenChanges":
            _tableView.reloadData()
        default:
            break
        }
    }
    deinit {
        datasource.removeObserver(self, forKeyPath: "conditionHaveBeenChanged")
        datasource.removeObserver(self, forKeyPath: "datasourceHaveBeenChanges")
    }
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        filterBtnArray = [paiXuBtn,kongXianBtn,distanceBtn]
        
         titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 30))
         _searchBar = UISearchBar.init(frame: titleView.bounds)
        _searchBar.searchBarStyle = .minimal
        _searchBar.backgroundColor = UIColor.clear
        _searchBar.placeholder = "搜地点,找车位"
        _searchBar.delegate = self
        titleView.addSubview(_searchBar)
        navigationItem.titleView = titleView
        datasource.condition.lot = "103.956197"
        datasource.condition.lat = "30.731878"
        datasource.condition.cityName = "成都市"
        //教室没网络的情况下可以拿本地数据展示
        deserializeLocationJson(fileName: "停车场列表数据") { (model) in
           let jsonArray = JSONDeserializer<ParkingList>.deserializeModelArrayFrom(array: model as? NSArray)
            datasource.data = jsonArray! as! [ParkingList]
        }
        //有网的时候用这个方法
//        observeValue(forKeyPath: "conditionHaveBeenChanged", of: nil, change: nil, context: nil)
         _tableView.register(UINib.init(nibName: "HomeSection3TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeSection3TableViewCell")
        //下拉刷新
        weak var weakSelf = self
        _tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.datasource.conditionHaveBeenChanged = true
            weakSelf?._tableView.mj_header.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //真实网络请求打开这里
//        if datasource.data.count - indexPath.row == 1{
//            datasource.loadMore(view: view)
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSection3TableViewCell") as! HomeSection3TableViewCell
        let model = datasource.data[indexPath.row]
        cell.showData(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _searchBar.resignFirstResponder()
        let model = datasource.data[indexPath.row]
        if model.parkingId != ""{
            
            let vc = UIStoryboard.init(name: "Parking", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParkingDetail2ViewController") as! ParkingDetail2ViewController
              vc.pplotid = model.parkingId
            navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    //筛选按钮
    @IBAction func filterDataButtonClick(_ sender: UIButton) {
        _searchBar.resignFirstResponder()
        filterView?.removeFromSuperview()
        for button in filterBtnArray{
            if button == sender{
                button.setTitleColor(UIColor.blue, for: .normal)
                if button.tag == 10{
                    weak var weakSelf = self
                     filterView = FilterView.init(frame: CGRect.init(x: 0, y: 45 , width: SCREEN_width, height: SCREEN_height-45), titleArray: ["综合排序","停车价格最低","充电价格最低","免费停车","24小时"], lastSelected: filterLastIndex)
                    view.addSubview(filterView!)
                    filterView?.selectedIndex = { (index) in
                       weakSelf?.datasource.condition.sort = index
                        weakSelf?.filterLastIndex = index
                        weakSelf?.datasource.conditionHaveBeenChanged = true
                    }
                }else if button.tag == 11{
                   datasource.condition.sort = 5
                    datasource.conditionHaveBeenChanged = true
                }else{
                    datasource.condition.sort = 6
                    datasource.conditionHaveBeenChanged = true
                }
            }else{
                button.setTitleColor(UIColor.darkGray, for: .normal)
            }
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
extension ParkingViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            datasource.condition.sort = 0
            datasource.condition.keyword = searchText
            datasource.conditionHaveBeenChanged = true
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil{
            if searchBar.text != ""{
                datasource.condition.sort = 0
                datasource.condition.keyword = searchBar.text!
                datasource.conditionHaveBeenChanged = true
            }
            
        }
    }
}
