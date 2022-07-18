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

typealias productDisctonary = [Products:Dollar]

var productDic : productDisctonary = [:]
productDic["Bag"] = 20


var T3 = "Generic"

typealias ProductDictionary<T> = [String : T]

var productList : ProductDictionary<Dollar> = [:]

productList["Chees"] = 0


var T4 = "Closures"

typealias buyProducts = (ProductDictionary<Dollar>)->Void

func getProducts(onComplition : @escaping buyProducts){

    onComplition(productList)
}

getProducts { prod in
    print("Datas",prod)
}
