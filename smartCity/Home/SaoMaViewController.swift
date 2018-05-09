//
//  SaoMaViewController.swift
//  smartcity
//
//  Created by csoone on 2017/3/16.
//  Copyright © 2017年 ShuCai. All rights reserved.
//

import UIKit

class SaoMaViewController: UIViewController {

    @IBOutlet weak var dollat: UIImageView!
    @IBOutlet weak var wallet: UILabel!
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SaoMaViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  "扫码"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyWalletButtonClick(_ sender: UIButton) {//充值
        
    }

    @IBAction func saoMaButtonClick(_ sender: UIButton) {//扫码充电
        let vc = QRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
}
}

