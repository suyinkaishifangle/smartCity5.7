//
//  LWProgressHUD.swift
//  smartCity
//
//  Created by MuY on 2018/3/30.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

 class LWProgressHUD: NSObject {
static let shared = LWProgressHUD()
    private override init() {}
    //背景view放window上面
    let maskView = UIView()
    //弹窗小方框
    let squareView = UIView()
    //创建一个旋转的小菊花
    let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    //写一个显示的函数
    func showInWindow(){
        //找到window,通过代理找window，记住就行了
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.addSubview(creatView())
    }
    //只显示在当前页面上
    func show(currentView:UIView){
        currentView.addSubview(creatView())
        
    }
    //设置view
    func creatView()->UIView{
        //设置maskView的坐标 大小设为屏幕的大小
        maskView.frame = BOUNDS
        //设置背景色   alpha为背景透明度 可以根据需求调整
        maskView.backgroundColor = UIColor.init(white: 0, alpha: 0)
        //设置小方框
        squareView.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        squareView.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 60)
        squareView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        //设置圆角
        squareView.layer.cornerRadius = 8
        //裁剪圆角
        squareView.layer.masksToBounds = true
        
        //设置indicatorView
        indicatorView.color = UIColor.white
        indicatorView.center = squareView.center
        //启动小菊花
        indicatorView.startAnimating()
      //把小方框和圆形进度条放到maskView上
        maskView.addSubview(squareView)
        maskView.addSubview(indicatorView)
        return maskView
    
        
    }
    //写一个消失的函数
    func dismiss(){
        //把maskView从父类移除
        maskView.removeFromSuperview()
    }
    //我们放到网络请求上去看一下
   
    
}
