//
//  BaseNavigationController.swift
//  smartCity
//
//  Created by niko on 16/11/30.
//  Copyright © 2016年 smartCity. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    //var enableRightGesture:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航是否透明
        navigationBar.isTranslucent = false
        
//        interactivePopGestureRecognizer!.delegate = self
       // configureNavBarTheme()
    }
  //  func configureNavBarTheme(){
        
        //设置是否透明
    
        //设置背景色
        // navigationBar.barTintColor = UIColor.white
        //item字体颜色
       // navigationBar.tintColor = UIColor.blue
//        navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.black]
         // 去掉导航栏底部阴影
         // navigationBar.shadowImage = UIImage()
    //}
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count >= 1{
            viewController.hidesBottomBarWhenPushed = true
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "Return_N"), style: .plain, target: self, action: #selector(backBtnClick))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
//    @objc func backBtnClick() {
//        popViewController(animated: true)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//extension BaseNavigationController:UIGestureRecognizerDelegate{
//        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//            if (self.viewControllers.count <= 1) {
//                return false
//            }
//            return self.enableRightGesture;
//        }
//}

