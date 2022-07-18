//
//  gcd_basic.swift
//  ConcurrencyAsyncAwait
//
//  Created by Shyamala's MacBook Pro on 22/04/22.
//

import Foundation
class GCDBasic{

    
    func creatQueue(){
        let queue = DispatchQueue(label: "com.dispatch.queue")
        queue.async {
            for i in 0..<10{
                print("Hello Async",Date())
            }
        }
        print("Hello Data On Main thread",Date())
    }
    
}
