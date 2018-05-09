//
//  LWMessage.swift
//  smartCity
//
//  Created by MuY on 2018/3/29.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation
import UIKit

class LWMessage{
    public  class func show(message:String){
        
        var window = (UIApplication.shared.delegate as! AppDelegate).window
        let windows = UIApplication.shared.windows
        for win in windows{
            let viewName = NSStringFromClass(win.classForCoder)
            if viewName == "UIRemoteKeyboardWindow" {
                window = win
                break
            }
        }
        
        setUI(message: message, window: window)
    }
    
    public  class func show(message:String,window:UIWindow?){
        
        var theWindow = window
        let windows = UIApplication.shared.windows
        for win in windows{
            let viewName = NSStringFromClass(win.classForCoder)
            if viewName == "UIRemoteKeyboardWindow" {
                theWindow = win
                break
            }
        }
        setUI(message: message, window: theWindow)
    }
    
    private   class func setUI(message:String,window:UIWindow?){
        let messageLable:UILabel = UILabel()
        let size = (message as NSString).size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)])
        
        var width:CGFloat = 0
        var height:CGFloat = 0
        if size.width + 20 > SCREEN_width{
            width = SCREEN_width - 80
            height = getTextHeight(text: message, font: UIFont.systemFont(ofSize: 17), width: SCREEN_width - 80)+10
        }else{
            width = size.width + 20
            height = size.height + 20
        }
        messageLable.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        if window != nil {
            messageLable.center = CGPoint(x: window!.bounds.size.width / 2, y: window!.bounds.size.height / 2)
        }else{
            let window2 = (UIApplication.shared.delegate as! AppDelegate).window
            messageLable.center = CGPoint(x: (window2?.bounds.size.width)! / 2, y: (window2?.bounds.size.height)! / 2)
        }
        
        
        messageLable.text = message
        messageLable.numberOfLines = 0
        messageLable.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        messageLable.textColor = UIColor.white
        
        
        messageLable.textAlignment = NSTextAlignment.center
        messageLable.layer.cornerRadius = 4
        messageLable.layer.masksToBounds = true
        window?.addSubview(messageLable)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            messageLable.alpha = 0
        }) { (complete) -> Void in
            messageLable.removeFromSuperview()
        }
        
    }

}
