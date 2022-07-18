//
//  ViewController.swift
//  ConcurrencyAsyncAwait
//
//  Created by Shyamala's MacBook Pro on 25/02/22.
//

import UIKit

// Async/Await , Task , async let , Actor (like class) , in Actor func should call within task block (it should go with background) , MainActor func should not call in backgroud,

class ViewController: UIViewController {
    
    @IBOutlet weak var lable: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        GCDBasic().creatQueue()
       
        
        
//        Task{
//           let va =  await performHeavyTask(2)
//            print("vavavava , \(Date())",va )
//            let vas =  await performHeavyTask(3)
//            print("vasvasvas , \(Date())",vas)
//            print("asdfgh , \(Date())",va + vas)
//        }
//        Task{
//            async let a = performHeavyTask(0)
//            async let b = performHeavyTask(1)
//            print("ABAB , \(Date())",await(a + b))
//        }
//
        let counter = Counter.init(name: "Shyamala")
        Task{
            await counter.addCount()
        }
        
        print("HElloNAme , \(Date())",counter.getName())
        
        DispatchQueue(label: "BACKGROUD", qos: .background).async {
            self.nonCallingBackground()
        }
    }

    func performHeavyTask(_ v: Int) async -> Int{
        print("BAckground , \(Date())",v)
        await Task.sleep(5 * 1_000_000_000)
        return v
    }
    
    @MainActor
    func nonCallingBackground(){
        print("nonCallingBackground , \(Date())")
    }
    
}

actor Counter{
    private let name : String
    private var count  = 0
    init(name : String){
        self.name = name
    }
    func addCount(){
        count += 1
        print("countCount , \(Date())",count)
    }
    nonisolated func getName() -> String{
        return name
    }
}
