import UIKit

var greeting = "Hello, Typealias"

typealias Dollar = Double
typealias Pound = Double
typealias Rupee = Double
typealias Products = String


struct ShoppingBasket{
    let TotalCost : Dollar
    let items : [Products]
}

let yourBasket = ShoppingBasket(TotalCost: 200, items: ["bag","cheese"])


var T1 = "Extending Typealias"

extension Dollar{
    func toRupee() -> Int{
        Int(self*71)
    }
}

let ShopingPriceInRupees = yourBasket.TotalCost.toRupee()


var T2 = "Typealias Dic"

typealias productDisctonary = [String:String]

let productDic : productDisctonary = 
