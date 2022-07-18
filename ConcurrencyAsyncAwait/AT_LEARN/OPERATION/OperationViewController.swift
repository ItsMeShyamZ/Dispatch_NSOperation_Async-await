//
//  OperationViewController.swift
//  ConcurrencyAsyncAwait
//
//  Created by Shyamala's MacBook Pro on 22/06/22.
//

import UIKit

class OperationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.createOperation()
        self.createStartBlock()
    }
  

}

extension OperationViewController{
    func createOperation(){
        let operation = BlockOperation{
            print("Operation 1 Started")
            Thread.sleep(forTimeInterval: 1)
            print("Operation 1 Stopped")
        }
        
        let operation1 = BlockOperation{
            print("Operation 2 Started")
        }
    /*
        let queue = OperationQueue()
        queue.addOperation(operation)
        
        operation1.addDependency(operation)
        queue.addOperation(operation1)
        queue.waitUntilAllOperationsAreFinished()
        print("Finished")
        
        /*Output
         
         Operation 1 Started
         Operation 1 Stopped
         Operation 2 Started
         
         ** addDependency will make serial queue feature
         */
     */
        
        let queue = OperationQueue()
        let queue1 = OperationQueue()
        queue.addOperation(operation)
        operation1.addDependency(operation)
        queue1.addOperation(operation1)
        
        queue1.waitUntilAllOperationsAreFinished()
        print("Finished")
        
    }
    
    
    func createStartBlock(){
        let oper = BlockOperation{
            print("1234567")
        }
       
        for i in "Shyamala"{
            oper.addExecutionBlock {
                print("\(i)",Date())
                sleep(1)
            }
        }
        oper.completionBlock = {
            print("Operation Completed")
        }
        oper.start()
      
    }
}
