//
//  protocolTest.swift
//  smartCity
//
//  Created by MuY on 2018/4/28.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation

protocol testDelegete{
    func testFunc(index:Int)
}

class ProtocolTest: NSObject {
    static let shared = ProtocolTest()
    private override init() {}
    //定时器
    var timer: DispatchSourceTimer?
    var timer2:Timer?
    var timer3:Timer?
    var timer4:CADisplayLink?
    
    var delegete:testDelegete?
    
    func getData(){
        
        self.delegete?.testFunc(index: 10)
    }
    //一：队列方法
    func timerStart1(_ sender: UIButton){
        var num:Int = 5
        //flag(标记) + queue(队列)
        timer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        //设置最迟开始时间和重复间隔
        //- parameter: deadline 截止时间, 计时器最迟开始时间;
        //- parameter: repeating 时间间隔;
        //- parameter: leeway 容忍时间;
        // 参数leeway, 指的是一个期望的容忍时间，比如将它设置为1秒，意味着系统有可能在定时器时间到达的前1秒或者后1秒才真正触发定时器。在调用时推荐设置一个合理的 leeway 值。需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
        //在主线程中创建一个定时器
        //        timer?.schedule(deadline: <#T##DispatchTime#>, repeating: <#T##DispatchTimeInterval#>, leeway: <#T##DispatchTimeInterval#>)
        
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler {
            if num <= 0{
                //取消
                DispatchQueue.main.async(execute: {
                    sender.setTitle("重新获取", for: .normal)
                    sender.isUserInteractionEnabled = true
                })
                // 暂停计时器
                self.timer?.suspend()
                // 暂停后重启计时器
                self.timer?.resume()
            }else{
                num -= 1
                //该处设定要执行的事件，比如说要定时器控制的界面的刷新等等，记住，要用主线程刷新，不然会有延迟
                DispatchQueue.main.async(execute: {
                    sender.setTitle("\(num)s", for: .normal)
                    sender.isUserInteractionEnabled = false
                })
            }
        }
        //执行
        timer?.resume()
        //销毁，取消
        //self.timer?.cancel()
        //self.timer = nil
    }
    //二：实例方法
    func timerStart2(){
        // 初始化
        //        - parameter: fireAt 设置指定时间, 计时器将在该时间开启;
        //        - parameter: interval 时间间隔, 重复操作中代表间隔多久执行一次;
        //        - parameter: target "selector"的执行者;
        //        - parameter: selector 计时器触发的Action, 需要执行的操作;
        //        - parameter: userInfo 想通过timer传递的数据;
        //        - parameter: repeats 是否重复, 如果为true, 默认间隔timeInterval时间执行一次;
        timer2 = Timer(fireAt: Date(timeIntervalSinceNow: 0), interval: 1, target: self, selector: #selector(timer2Action), userInfo: nil, repeats: true)
        
        // 线程是一个类，RunLoop是类里的实例变量
        RunLoop.current.add(timer2!, forMode: .defaultRunLoopMode)
        //.如果计时器不重复执行, 只执行一次, 除了上面的方式, 还可以用下面这种方式, 但是下面这种方式只适合单次的情况, 如果是重复执行, 则无效
        //timer2?.fire()
    }
    // 执行的Action
    @objc  func timer2Action() {
        // 需要执行的操作
        print("第2种定时器开始了")
        // 关闭
        //        timer2?.invalidate()
        //        timer2 = nil
        
        
    }
    //三：类方法
    func timerStart3(){
        // 初始化
        //        - parameter: timeInterval 时间间隔, 重复操作中代表间隔多久执行一次;
        //        - parameter: target "selector"的执行者;
        //        - parameter: selector 计时器触发的Action, 需要执行的操作;
        //        - parameter: userInfo 想通过计时器传递的数据;
        //        - parameter: repeats 是否重复, 如果为true, 默认间隔timeInterval时间执行一次;
        timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer3Action), userInfo: nil, repeats: true)
    }
    @objc  func timer3Action() {
        // 需要执行的操作
        print("第3种定时器开始了")
        //关闭
        //       timer3?.invalidate()
        //        timer3 = nil
    }
    //四：CADisplayLink
    //    屏幕刷新时调用：CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类. CADisplayLink以特定模式注册到runloop后, 每当屏幕显示内容刷新结束的时候, runloop就会向CADisplayLink指定的target发送一次指定的selector消息, CADisplayLink类对应的selector就会被调用一次. 所以通常情况下, 按照iOS设备屏幕的刷新率60次/秒, CADisplayLink默认每秒运行60次, 但是通过它的preferredFramesPerSecond属性可以改变每秒运行帧数，如设置为30, 意味CADisplayLink每秒运行30次.
    // 使用场景：从原理上可以看出，CADisplayLink适合做界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染。
    
    func timerStart4(){
        timer4 = CADisplayLink(target: self, selector: #selector(cadTimerAction))
        // 修改为每秒执行3次
       // timer4?.preferredFramesPerSecond = 5
        // 添加到RunLoop
        timer4?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        // 暂停
        //        timer4?.isPaused = true
        //        // 继续
        //        timer4?.isPaused = false
    }
    @objc  func cadTimerAction() {
        // 需要执行的操作
        print("第4种定时器开始了")
        //移除RunLoop
        //timer4?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        //关闭
        //       timer4?.invalidate()
        //        timer4 = nil
    }
    
}
