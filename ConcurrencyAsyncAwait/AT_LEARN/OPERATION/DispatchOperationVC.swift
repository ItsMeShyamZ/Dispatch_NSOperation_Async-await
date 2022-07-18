//
//  DispatchOperationVC.swift
//  ConcurrencyAsyncAwait
//
//  Created by Shyamala's MacBook Pro on 13/07/22.
//

import UIKit

class DispatchOperationVC: UIViewController {
    
    
    @IBOutlet weak var progressView : UIView!
    @IBOutlet weak var progressBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var progressImg : UIImageView!
    @IBOutlet weak var progressLbl : UILabel!
    @IBOutlet weak var ps1 : UIView!
    @IBOutlet weak var ps2 : UIView!
    @IBOutlet weak var ps3 : UIView!
    @IBOutlet weak var ps4 : UIView!
    @IBOutlet weak var ps5 : UIView!
    let progressData : [String] = ["Please wait... We are finding a cab for you. Your ride will start soon...","Looking for more drivers","Contacting drivers","Seeking more drivers","Requesting Drivers"]
    let progressImgs : [String] = ["ps1","ps2","ps3","ps4","ps1"]
    
    
//    private lazy var queue = OperationQueue()
    let queue = DispatchQueue(label: "com.mytask")
    let group = DispatchGroup()
    var wrkItem : DispatchWorkItem?
    
    var selectedView : Int = 0{
        didSet{
            setupDispatchQueue(count: selectedView)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupProgressView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeObserve), name: Notification.Name("anim"), object: nil)
        self.setvalue()
        self.setupDispatchQueue(count: 0)
    }
    
    @objc func changeObserve(){
     
        self.selectedView =  self.selectedView + 1
    }

    
    func setvalue(){
        self.progressView.isHidden  = false
        self.progressImg.layer.cornerRadius = self.progressImg.frame.height / 2
        self.progressImg.clipsToBounds = true
        [self.ps1,self.ps2,self.ps3,self.ps4,self.ps5].forEach { view in
            view?.layer.borderColor = UIColor(named: "appColor")?.cgColor ?? UIColor.blue.cgColor
            view?.layer.borderWidth = 1
            view?.layer.cornerRadius = 2
            view?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            self.progressImg.image = UIImage(named: self.progressImgs[0])
            self.progressLbl.text = self.progressData[0]
            view?.startProgressAnimation(isStop: true)
           
        }
        
        self.cancelBtn.addTap {
            self.setvalue()
            
            self.selectedView = 0
        }

    }

    
    func setupDispatchQueue(count : Int){
        
        if count == 0{
            DispatchQueue.main.async {
                self.progressImg.image = UIImage(named: self.progressImgs[0])
                self.progressLbl.text = self.progressData[0]
                self.ps1.startProgressAnimation()
            }
        }
        if count == 1{
            DispatchQueue.main.async {
                self.progressImg.image = UIImage(named: self.progressImgs[1])
                self.progressLbl.text = self.progressData[1]
                self.ps2.startProgressAnimation()
            }
        }
        if count == 2{
            DispatchQueue.main.async {
                self.progressImg.image = UIImage(named: self.progressImgs[2])
                self.progressLbl.text = self.progressData[2]
                self.ps3.startProgressAnimation()
            }
        }
        if count == 3{
            DispatchQueue.main.async {
                self.progressImg.image = UIImage(named: self.progressImgs[3])
                self.progressLbl.text = self.progressData[3]
                self.ps4.startProgressAnimation()
            }
        }
        if count == 4{
            DispatchQueue.main.async {
                self.progressImg.image = UIImage(named: self.progressImgs[4])
                self.progressLbl.text = self.progressData[4]
                self.ps5.startProgressAnimation()
            }
        }
    }
}


extension UIView : CAAnimationDelegate {
    
   
    
    public func animationDidStart(_ anim: CAAnimation) {
        print("StartStartStart")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Stopped")
        NotificationCenter.default.post(name: Notification.Name("anim"), object: nil)
    }

    func startProgressAnimation(isStop:Bool = false)
    {
    let layer = CALayer()
    layer.backgroundColor = UIColor(named: "appColor")?.cgColor ?? UIColor.blue.cgColor
    layer.masksToBounds = true
    layer.anchorPoint = .zero
    

    layer.frame = CGRect.init(x: 0,y: 0, width: self.frame.width ,
                              height: self.frame.height)
    let anim : CAAnimationGroup?
    if isStop{
        guard let sublayers = self.layer.sublayers else { return }

        for sublayer in sublayers where sublayer.isKind(of: CALayer.self) {
                sublayer.removeFromSuperlayer()
        }
    }else{
        self.layer.addSublayer(layer)
        let boundsAnim:CABasicAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        boundsAnim.fromValue = 0
        boundsAnim.toValue = self.frame.width
        anim = CAAnimationGroup()
        anim?.animations = [boundsAnim]
        anim?.isRemovedOnCompletion = false
        anim?.duration = 20
        anim?.delegate = self
        layer.add(anim!, forKey: "bounds.size.width")
    }
}}

private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10
public enum closureActions : Int{
    case none = 0
    case tap = 1
    case swipe_left = 2
    case swipe_right = 3
    case swipe_down = 4
    case swipe_up = 5
}

public struct closure {
    typealias emptyCallback = ()->()
    static var actionDict = [Int:[closureActions : emptyCallback]]()
    static var btnActionDict = [Int:[String: emptyCallback]]()
}

extension UIView{
    
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTap(Action action:@escaping ()->Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {
        
        if type == .none{
            return
        }
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
}


// MARK: - custom UI appearance

extension UIView{
    
    var identifiers : String{
          return "\(self)"
      }
    
    @objc func initView(view: UIView , vc : UIViewController) -> UIView{
          return self
      }
    
    @objc func deInitView(view: UIView , vc : UIViewController) -> UIView{
        removeFromSuperview()
        return self
    }
}

