//
//  HelpManager.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/8.
//  Copyright © 2019 Keyan . All rights reserved.
//


import UIKit
import HealthKit

class HelpManager: NSObject {
    
    class func getCurrentYear() -> NSPredicate {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY"
        let year = formater.string(from: Date())
        formater.dateFormat = "YYYY/MM/dd"
        let startS = "\(year)/01/01"
        let endY = Int(year)!
        let endS = "\(endY)/12/31"
        let startT = formater.date(from: startS)!
        let endT = formater.date(from: endS)!
        return HKQuery.predicateForSamples(withStart: startT, end: endT, options: .strictStartDate)
    }
    
    class func changeStatusBarToWhiteTextBlackBackground(){
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.darkBlackAsNavigation
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}

extension UIColor {
    
    static var darkBlackAsNavigation: UIColor  { return UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1) }
    
    //Colors that go along with from http://www.peise.net/2014/1212/4776.html
    static var brightRed: UIColor  { return UIColor(red: 255/255, green: 141/255, blue: 131/255, alpha: 1) }
    static var brightGreen: UIColor  { return UIColor(red: 147/255, green: 232/255, blue: 135/255, alpha: 1) }
    static var brightYellow: UIColor  { return UIColor(red: 255/255, green: 245/255, blue: 134/255, alpha: 1) }
    static var brightBrown: UIColor  { return UIColor(red: 232/255, green: 198/255, blue: 152/255, alpha: 1) }
    static var lightGreen: UIColor  { return UIColor(red: 87/255, green: 255/255, blue: 231/255, alpha: 1) }
    static var brightOrange: UIColor  { return UIColor(red: 242/255, green: 117/255, blue: 63/255, alpha: 1) }
    static var brightBlue: UIColor  { return UIColor(red: 0/255, green: 153/255, blue: 202/255, alpha: 1)}
    
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

extension UIView {
    
    func shake(count : Float = 2,for duration : TimeInterval = 0.25,withTranslation translation : Float = 4) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
    
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

extension Date{
    static var OneHourEarlierFromNow: Date{ return Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

let viewWidth = UIScreen.main.bounds.size.width



