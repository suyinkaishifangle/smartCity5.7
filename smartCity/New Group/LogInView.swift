//
//  LogInView.swift
//  smartCity
//
//  Created by MuY on 2018/5/3.
//  Copyright © 2018年 MuY. All rights reserved.
//

import UIKit

class LogInView: UIView,UITextFieldDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        let maskView = UIView()
        maskView.backgroundColor = UIColor.white
        maskView.layer.cornerRadius = 8
        maskView.layer.masksToBounds = true
        self.addSubview(maskView)
        
        maskView.snp.makeConstraints { (make) in
            //宽300 高200 水平垂直居中
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        //标题
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = "登录"
        titleLabel.textAlignment = .center
        maskView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(50)
        }
        //取消按钮
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage.init(named: "login_close"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        maskView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(0)
            make.height.width.equalTo(50)
        }
        //手机号码输入框
        let phoneTF = UITextField()
        phoneTF.placeholder = "请输入手机号码"
        phoneTF.keyboardType = .numberPad
        phoneTF.borderStyle = .none
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        maskView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview().offset(-12)
            make.height.equalTo(50)
        }
        //下划线
        let line = UILabel()
        line.backgroundColor = UIColor.lightGray
        maskView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
             make.trailing.equalTo(-20)
            make.top.equalTo(phoneTF.snp.bottom)
            make.height.equalTo(0.5)
        }
        //下一步
        let nextButton = UIButton()
        nextButton.layer.cornerRadius = 8
        nextButton.layer.masksToBounds = true
        nextButton.backgroundColor = UIColor.lightGray
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        maskView.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
             make.trailing.equalTo(-20)
            make.bottom.equalTo(maskView.snp.bottom).offset(-10)
            make.height.equalTo(50)
        }
    }
    
   @objc func nextButtonClick(){
        cancelButtonClick()
    }
    @objc func cancelButtonClick(){
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.alpha = 0
        }) { (complete) -> Void in
            self.removeFromSuperview()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return ((textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString).length <= 11
    }
    

}
