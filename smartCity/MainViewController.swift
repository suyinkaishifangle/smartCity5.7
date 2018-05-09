//
//  MainViewController.swift
//  smartCity
//
//  Created by MuY on 2018/3/27.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    let barTitle = ["首页","导航","缴费","我的"]
    var childController = [UIViewController]()
    let nomalIMages = [#imageLiteral(resourceName: "tabbar_home_defauit"),#imageLiteral(resourceName: "tabbar_nearby_defauit"),#imageLiteral(resourceName: "tabbar_pay_defauit"),#imageLiteral(resourceName: "tabbar_mine-defauit")]
    let selectedImages = [#imageLiteral(resourceName: "tabbar_home_selected"),#imageLiteral(resourceName: "tabbar_mine-selected"),#imageLiteral(resourceName: "tabbar_pay_selected"),#imageLiteral(resourceName: "tabbar_mine-selected")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parkingVc = UIStoryboard.init(name: "Parking", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParkingViewController") as! ParkingViewController
        
        let paymentVc = UIStoryboard.init(name: "Payment", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        
         childController = [HomeViewController(),parkingVc,paymentVc,MineViewController()]
        
        
        for (index,child) in childController.enumerated(){
            child.tabBarItem.title = barTitle[index]
            child.tabBarItem.selectedImage = selectedImages[index]
            child.tabBarItem.image = nomalIMages[index]
           
            addChildViewController(BaseNavigationController.init(rootViewController: child) )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
