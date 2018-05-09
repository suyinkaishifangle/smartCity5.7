//
//  GCDtest.swift
//  smartCity
//
//  Created by MuY on 2018/4/28.
//  Copyright © 2018年 MuY. All rights reserved.
//

import Foundation

class GCDtest:NSObject{
    static let shared = GCDtest()
    private override init() {}
    
    
   // 简介
//    Grand Central Dispatch (GCD) 是Apple开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。
    
//    GCD, NSOperationQueue, NSThread, pthread是iOS中多线程的几种处理方式。Swift4，直接使用。
    
//    特性
//    GCD可用于多核的并行运算
//    GCD会自动利用更多的CPU内核（比如双核、四核）
//    GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
    
    //1.异步执行回主线程写法
    func test1(){
        DispatchQueue.global().async {
            print("async do something\(Thread.current)")
            DispatchQueue.main.async {
                print("come back to main thread\(Thread.current)")
            }
        }
        //2.QoS ，通过QoS来标注每个通信
//        user Interactive 和用户交互相关，比如动画等等优先级最高。比如用户连续拖拽的计算
//        user Initiated 需要立刻的结果，比如push一个ViewController之前的数据计算
//        utility 可以执行很长时间，再通知用户结果。比如下载一个文件，给用户下载进度
//        background 用户不可见，比如在后台存储大量数据
        
        func test2(){
            //方法1创建一个指定QoS的queue
            let queue = DispatchQueue(label: "labelname", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
            queue.async {
                //
            }
            //方法2在提交block的时候，指定QoS
            queue.async(group: nil, qos: .background, flags: .inheritQoS) {
                //
            }
        }
        //3.延迟
       func test3(){
        let deadline = DispatchTime.now() + 5.0
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            //
        }
        
        }
        
//       3. DispatchGroup
//        DispatchGroup用来管理一组任务的执行，然后监听任务都完成的事件。比如，多个网络请求同时发出去，等网络请求都完成后reload UI。
        func test4(){
            let group = DispatchGroup()
            group.enter()
            let handle1 = NetWorkHandle.init(binTag: "ceshi", currentView: nil)
            handle1.httpPostRequest(url: "222", params: nil) { (complete, result, _) in
                print("request complete")
                group.leave()
            }
           
            group.enter()
            let handle2 = NetWorkHandle.init(binTag: "ceshi2", currentView: nil)
            handle2.httpPostRequest(url: "333", params: nil) { (complete, result, _) in
                print("request complete")
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) {
                print("all requests come back")
            }
        }
    }
   //4 Barrier
    //GCD里的Barrier和NSOperationQueue的dependency比较接近，C任务开始之前需要A任务完成，或者A和B任务完成
    func test4(){
        let queue = DispatchQueue(label: "foo", attributes: .concurrent)
        queue.async {
                print("A")
        }
        queue.async {
                print("B")
        }
        queue.async(flags: .barrier) {
                print("C")
        }
    }
    
    

  
}
