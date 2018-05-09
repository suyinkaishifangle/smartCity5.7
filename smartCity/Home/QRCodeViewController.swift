//
//  QRCodeViewController.swift
//  smartcity
//
//  Created by csoone on 2017/2/23.
//  Copyright © 2017年 ShuCai. All rights reserved.
//

import UIKit

import AVFoundation

class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //控制线的上下移动
    var up = false
    //扫码和输入编号button的数组
    var buttonArray = [UIButton]()
    //右上角相册选择按钮
    var photoItem:UIBarButtonItem!
    //扫描线初始位置
    var originalTop:CGFloat = -10
    var link:CADisplayLink!//计时器
    //中间的探测区域绿框
     var scanRectView:UIView!
    //摄像设备
    var device:AVCaptureDevice!
    //输入流
    var input:AVCaptureDeviceInput!
    //输出流
    var output:AVCaptureMetadataOutput!
    //连接对象
    var session:AVCaptureSession?
    //预览区域
    var preview:AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lightButton: UIButton!//手电
    @IBOutlet weak var lineY: NSLayoutConstraint!//线Y的位置
    @IBOutlet weak var frameImage: UIImageView!//背景框
    @IBOutlet weak var saomaButton: UIButton!//扫码按钮
    @IBOutlet weak var zhongDuanNoButton: UIButton!
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "QRCodeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫码充电"
        view.backgroundColor = UIColor.black
        //设置导航栏
        photoItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(QRCodeViewController.selectPhotoFormPhotoLibrary(_:)))
        self.navigationItem.rightBarButtonItem = photoItem
        
        self.setupCamera()
        //通过CADisplayLink定时器设置线移动
        link = CADisplayLink(target: self, selector: #selector(move))
        link.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        buttonArray = [saomaButton,zhongDuanNoButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
        if link != nil{
           link.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        }
    }
    //视图消失后关闭定时器
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.session != nil{
            if (self.session?.isRunning)! {
                self.session?.stopRunning()
                self.link.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            }
        }
    }
    func setupCamera(){
        
        do{
            //1.获取摄像设备
            self.device = AVCaptureDevice.default(for: AVMediaType.video)
            //2.创建输入流
            if device != nil{
                self.input = try AVCaptureDeviceInput(device: device)
                //3.创建输出流
                self.output = AVCaptureMetadataOutput()
                //设置代理 在主线程刷新
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                //4.初始化连接对象
                self.session = AVCaptureSession()
                //设置高质量采集率
                if UIScreen.main.bounds.size.height<500 {
                    self.session?.sessionPreset = AVCaptureSession.Preset.vga640x480
                }else{
                    self.session?.sessionPreset = AVCaptureSession.Preset.high
                }
                //组合
                self.session?.addInput(self.input)
                self.session?.addOutput(self.output)
                //设置扫码格式支持的码(一定要在 session 添加 addOutput之后再设置 否则会崩溃)
                self.output.metadataObjectTypes = [.qr,.code128,.code39]
                //这里设置的是全屏可探测
                self.preview = AVCaptureVideoPreviewLayer(session:self.session!)
                self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.preview.frame = UIScreen.main.bounds
                self.view.layer.insertSublayer(self.preview, at:0)
                //开始捕获
                self.session?.startRunning()
            }else{
                LWMessage.show(message: "获取摄像设备失败")
            }
        }catch _ {
            //打印错误消息
            let alertController = UIAlertController(title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", preferredStyle: .alert)
            let completeAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            alertController.addAction(completeAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    //摄像头捕获
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        var stringValue:String?
        // metadataObjects这个参数是我们需要的
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            if stringValue != nil{
                 print("扫码二维码结果：\(stringValue!)")
                self.navigationController?.popViewController(animated: true)
            }else{
                showAlertViewWithMsg("不能识别的二维码")
            }
        }
        //二维码获取成功需要停止定时器
         self.link.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
        self.session?.stopRunning()
    }
    
    @objc func move(){
        if (up == true) {
            self.lineY.constant += 2;
            if self.lineY.constant >= originalTop + frameImage.frame.size.height  {
                up = false
            }
        }else {
            self.lineY.constant -= 2;
            if self.lineY.constant <= originalTop {
                up = true
            }
        }
    }
    
    //闪光灯
    @IBAction func openLight(_ sender: UIButton) {
        let isLightOpened = self.isLightOpened()
        //可以用来调整开灯关灯的按钮状态
        self.openTheLight(open: !isLightOpened)
    }
    
     func isLightOpened()->Bool{
        //判断设备是否有闪光灯
        if device?.hasTorch == nil{
            return false
        }else{
            if device?.torchMode == AVCaptureDevice.TorchMode.on{//闪光灯已经打开
                return true
            }else{
                return false
            }
        }
    }
    ///打开闪光灯的方法
     func openTheLight(open:Bool){
        if device?.hasTorch == nil{
            showAlertViewWithMsg("闪光灯故障")
        }else{
            if open{//打开
                if  device?.torchMode != AVCaptureDevice.TorchMode.on || device?.flashMode != AVCaptureDevice.FlashMode.on{
                    do{
                        try device?.lockForConfiguration()
                        device?.torchMode = AVCaptureDevice.TorchMode.on
                        device?.flashMode = AVCaptureDevice.FlashMode.on
                        device?.unlockForConfiguration()
                    }catch{
                        debugPrint(error)
                    }
                }
            }else{//关闭闪光灯
                if  device?.torchMode != AVCaptureDevice.TorchMode.off || device?.flashMode != AVCaptureDevice.FlashMode.off{
                    do{
                        try device?.lockForConfiguration()
                        device?.torchMode = AVCaptureDevice.TorchMode.off
                        device?.flashMode = AVCaptureDevice.FlashMode.off
                        device?.unlockForConfiguration()
                    }catch{
                        debugPrint(error)
                    }
                }
            }
        }
    }
    
    //从相册中选择图片
    @objc func selectPhotoFormPhotoLibrary(_ sender : AnyObject){
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //允许编辑
        picture.allowsEditing = true
        picture.delegate = self
        self.present(picture, animated: true, completion: nil)
    }
    
    //选择相册中的图片完成，进行获取二维码信息
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type = (info as NSDictionary).object(forKey: UIImagePickerControllerMediaType)as! String
        session?.stopRunning()
        if type == "public.image" {
            //识别二维码的方法
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let context = CIContext(options: nil)
            //CIImage保存图像数据的类
            let ciImage = CIImage.init(image: image)
            //CIDetector这个类用于识别、检测静止图片或者视频中的显著特征
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
            let array = detector?.features(in: ciImage!)
            //跳转的方法
            if array!.count > 0 {
                let array = detector?.features(in: ciImage!)
                let result : CIQRCodeFeature = array!.first as! CIQRCodeFeature
                if result.messageString != nil{
                     self.navigationController?.popViewController(animated: true)
                    print("扫码本地图片结果：\(result.messageString!)")
                }
            }else{
                self.dismiss(animated: true, completion: nil)
                showAlertViewWithMsg("不能识别的类型")
            }
        }
    }
    func showAlertViewWithMsg(_ msg:String){
        //9.0以下版本这样
//UIAlertView(title: "提示", message:msg, delegate:nil, cancelButtonTitle: "确定").show()
        let alertController = UIAlertController(title: "提醒", message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    @IBAction func saoMaButtonClick(_ sender: UIButton) {
        for button in buttonArray{
            if button == sender{
                button.setImage(UIImage(named: sender.tag == 10 ? "Scan-code-pressed" : "input-pressed"), for: .normal)
            }else{
                button.setImage(UIImage(named: sender.tag != 10 ? "Scan-code-default" : "input-defauit"), for: .normal)
            }
        }
    }
}
