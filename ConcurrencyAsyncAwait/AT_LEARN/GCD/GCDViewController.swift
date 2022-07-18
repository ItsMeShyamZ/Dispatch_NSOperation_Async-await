//
//  GCDViewController.swift
//  ConcurrencyAsyncAwait
//
//  Created by Shyamala's MacBook Pro on 22/04/22.
//

import UIKit

class GCDViewController: UIViewController {

    @IBOutlet weak var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.createCustomBGTread()
//        self.creatSyncBGTread()
//        self.creatTread_with_priority_async_run_sync()
//        creatTread_with_priority_async_run_parllel()
//        diff_priority()
//        initiallyInactive()
//        delayQueue()
//        main_gloabl_queue()
//        dispatchWorkItem()
//        dispatchBarrier()
        
//        semaphore()
//        callSemaPhore()
        
//        dwi()
//        cancelWorkItem()
//        twoDWI()
        twoWAITDWI()
    }
}

extension GCDViewController{
    func createCustomBGTread(){
        let queue = DispatchQueue(label: "com.queue.custom")
        queue.async { // BG thread
            for i in 0..<10{
                DispatchQueue.main.async {
                    self.label.text = "queue,\(i)"
                    print("Hello Main Async",i)
                }
                print("Hello BGAsync")
            }
            
        }
    }
    
    func creatSyncBGTread(){
        let queue = DispatchQueue(label: "com.queue.custom")
        queue.sync { // BG sync thread
            for i in 0..<10{
                print("Hello BG_sync",i)
            }
            
        }
        print("creat async")
    }
    
    
    func creatTread_with_priority_async_run_sync(){
        let pt = DispatchQueue(label: "com.p.t", qos: .userInteractive)
        pt.async {
            for i in 0..<10{
                print("userInteractive",i)
            }
        }
        pt.async {
            for i in 0..<10{
                print("userInteractive_second",i+10)
            }
        }
        print("Mainthread")
    }
    
    func creatTread_with_priority_async_run_parllel(){
        let pt = DispatchQueue(label: "com.p.t", qos: .userInteractive,attributes: .concurrent)
        pt.async {
            for i in 0..<10{
                print("userInteractive",i)
            }
        }
        pt.async {
            for i in 0..<10{
                print("userInteractive_second",i+10)
            }
        }
        pt.async {
            for i in 0..<10{
                print("userInteractive_second",i+30)
            }
        }
        print("Mainthread")
    }
    
    func diff_priority(){
        let thread = DispatchQueue(label: "com.p.t",qos: .userInteractive)
        DispatchQueue(label: "com.p.t",qos: .background).sync {
            print("DispatchQueue__background")
        }
        thread.async {
            print("DispatchQueue__userInteractive")
        }
        
        DispatchQueue(label: "com.p.t",qos: .userInitiated).async {
            print("DispatchQueue__userInitiated")
        }
        
        DispatchQueue(label: "com.p.t",qos: .utility).async {
            print("DispatchQueue__utility")
        }
        
        DispatchQueue(label: "com.p.t",qos: .default).async {
            print("DispatchQueue__default")
        }
    }
    
    func initiallyInactive(){
        let thread = DispatchQueue(label: "com.p.t",qos: .userInteractive,attributes: .initiallyInactive)
        thread.async {  // thread.sync will not work
            for i in 0..<10{
                print("HelloThread",i)
            }
        }
        thread.activate()
       
    }
    
    func delayQueue(){
        let delayQueue = DispatchQueue(label: "com.delay.queue")
        print("Hello Time",Date())
        delayQueue.asyncAfter(deadline: .now() + .seconds(4)) {
            print("Hello Detaly Time",Date()+20)
        }
    }
    
    func main_gloabl_queue(){
//        So, Far we are creating a custom queue, but the system creates a collection of background queues which is known as global queues
        
        let queue = DispatchQueue.global(qos: .background)
        queue.sync {
            for i in 0..<10{
            print("Defalt global queue",i)
            }
        }
        
        DispatchQueue.main.async {
            print("Defalt main queue")
        }
    }
    
    
    func dispatchWorkItem(){
        let work = DispatchWorkItem{
            for i in 0..<10{
                print("DispatchWorkItemDispatchWorkItem")
                self.label.text = "sdf"
            }
        }
        work.notify(queue: .main) {
            print("queue_main")
        }
        work.perform()
        
//        DispatchQueue.global().async(execute: work)
        
    }
    
    
    func dispatchBarrier(){
        let queue = DispatchQueue(label: "com.d.barrier",qos: .userInitiated,attributes: .concurrent)
        queue.async(flags : .barrier){
            print("All Dispatch task executed then this barrier will executed")
        }
    }
    
    //Dispactsemaphore
    func semaphore(){
        let queue = DispatchQueue(label: "com.semaphore")
        let semaphore = DispatchSemaphore(value: 4)
        for i in 0...10{
            queue.async {
                Thread.sleep(forTimeInterval: 1)
                print("Semaphore_Value\(i)")
                semaphore.signal()
                
            }
         //   semaphore.wait()
            
        }
        DispatchQueue.main.async {
            print("Came To Main Threed")
        }
    }
    
    
    func callSemaPhore(){
        let concurrentTasks = 4

        // Create Concurrent Queue
        let queue = DispatchQueue(label: "com.swiftpal.dispatch.explosion", attributes: .concurrent)

        // Create Semaphore object
        let semaphore = DispatchSemaphore(value: 1)

        for i in 0 ... 10 {
            // Async Tasks
            queue.async {
                Thread.sleep(forTimeInterval: 1)
                print("Executed Task \(i)",Date())
                semaphore.signal()   // Sema Count Increased
            }
            semaphore.wait() //Sema Count Decreased
        }

        // Async Task
        DispatchQueue.main.async {
            print("All Tasks Completed")
        }
    }
}

extension GCDViewController{
    func ConcurrentGlobalQ_Memory(){
       
        // Global queques are Concurrent queues that are shared by the whole system it always return the same queue whereas custom concurrent queue is private returning new queue every time you create it.
        
        print("global1",Unmanaged.passUnretained(DispatchQueue.global()).toOpaque())
        print("global2",Unmanaged.passUnretained(DispatchQueue.global()).toOpaque())
        let cc = DispatchQueue(label: "serial_queue1",attributes: [.concurrent])
        print("custom3",Unmanaged.passUnretained(cc).toOpaque())
        
        let cc1 = DispatchQueue(label: "serial_queue1",attributes: [.concurrent])
        print("custom4",Unmanaged.passUnretained(cc1).toOpaque())

        
        let cc2 = DispatchQueue(label: "serial_queue1",attributes: [.concurrent])
        print("custom5",Unmanaged.passUnretained(cc2).toOpaque())

        
        let cc3 = DispatchQueue(label: "serial_queue1",attributes: [.concurrent])
        print("custom6",Unmanaged.passUnretained(cc3).toOpaque())
        
        
  /*      output :
        
        global1 0x0000000109eec080
        global2 0x0000000109eec080
        custom3 0x0000600003da8b00
        custom4 0x0000600003da9300
        custom5 0x0000600003da9380
        custom6 0x0000600003da9400
 
 */
      
    }
}


extension ViewController{
    func createSerialQueue(){
        let SQ = DispatchQueue(label: "serial_queue4")
        SQ.async {
            print("Task_1_Started")
            print("Task_1_Ended")
        }
        
        SQ.async {
            print("Task_2_Started")
            print("Task_2_Ended")
        }
        
        print("CustomQueue",Unmanaged.passUnretained(SQ).toOpaque())
    }
    
    func ConcurrentDQ(){
        let CDQ = DispatchQueue(label: "concurrent_queue",attributes: .concurrent)
        CDQ.async {
            print("Task_1_Started")
            print("Task_1_ended")
        }
        CDQ.async {
            print("Task_2_Started")
            print("Task_2_ended")
        }
        CDQ.async {
            print("Task_3_Started")
            print("Task_3_ended")
        }
        
        print("CustomQueue",Unmanaged.passUnretained(CDQ).toOpaque())
    }
}

// Dispatch WorkITem
extension GCDViewController{
    func dwi(){
        let workItem = DispatchWorkItem{
            print("numbers",Date())
            Thread.sleep(forTimeInterval: 3)
        }
        DispatchQueue.global().sync(execute: workItem)
        print("Hello",Date())
        
        workItem.notify(queue: .main) {
            print("WorkItem Task Completed",Date())
        }
    }
    
    func cancelWorkItem(){
        var workItem : DispatchWorkItem!
         workItem = DispatchWorkItem{
            for i in 0..<100{
                if workItem.isCancelled {
                    print("Work Item Cantelled")
                    break
                }
                print(i)
                sleep(1)
            }
        }
        let queues = DispatchQueue.global(qos: .utility)
        queues.async(execute: workItem)
        queues.asyncAfter(deadline: .now() + .seconds(3)) {
        //Do required task asfter 3 seconds
            workItem.cancel()
        }
       
        workItem.notify(queue: .main) {
            print("Task Completed",workItem.isCancelled)
        }
       
    }
    
    func twoDWI(){
        let dwi1 = DispatchWorkItem{
            for i in 0...10{
                print("I values is ", i ,Date())
            }
        }
        let dwi2 = DispatchWorkItem{
            for i in 11...20{
                print("I2 value is",i, Date())
            }
        }
        dwi1.notify(queue: .main) {
            dwi2.cancel()
            dwi2.perform()
        }
        
        dwi2.notify(queue: .main) {
            print("Task Completed")
        }
        
        DispatchQueue.global().async(execute: dwi1)
    }
    
    
    func twoWAITDWI(){
        let dwi1 = DispatchWorkItem{
            for i in 0...10{
                print("I values is ", i ,Date())
                sleep(1)
            }
        }
        let dwi2 = DispatchWorkItem{
            for i in 11...20{
                print("I2 value is",i, Date())
            }
        }
        
        dwi1.notify(queue: .main) {
            print("Task1 Completed")
        }
        
        dwi2.notify(queue: .main) {
            print("Task Completed")
        }
        
        DispatchQueue.global().async(execute: dwi1)
        dwi1.wait()
        DispatchQueue.global().async(execute: dwi2)
    }
}
