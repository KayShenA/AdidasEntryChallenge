//
//  CellMainView.swift
//  BarcodeScanner
//
//  Created by Keyan  on 2019/3/3.
//  Copyright © 2019 Keyan . All rights reserved.
//
import UIKit
import Foundation

class CellGoal: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var walkOrRunImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionBtn: UIButton!
    @IBOutlet weak var NoOfstepsOrDistance: UILabel!
    @IBOutlet weak var stepOrDistance: UILabel!
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var points: UILabel!
    
    
    var cover : UIView?
    var checkImage : UIImageView?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.borderWidth = 2
        background.layer.borderColor = UIColor.black.cgColor
        background.layer.cornerRadius = 10
        background.backgroundColor = UIColor.lightGray
        stepOrDistance.layer.cornerRadius = 15
        stepOrDistance.layer.masksToBounds = true
        NoOfstepsOrDistance.layer.cornerRadius = 15
        NoOfstepsOrDistance.layer.masksToBounds = true
        addGreenCheckCover()
    }

    override func layoutSubviews() {
        
    }
    
    class func cellIdentify() -> String
    {
        return "cellGoal"
    }
    
}

extension CellGoal{
    func setCellDataWithDataModelWithLogics(goal: GoalsDataModel){
        self.title.text = goal.title
        
        self.points.text = "\(goal.reward!.points!)pts"
        
        self.trophyImage.image = UIImage(named: "\(goal.reward?.trophy ?? "")")
        
        // set the unit to step or KM based on dict["type"] contains distance/step, and color accordingly, and NoOfStepsOrDisatance accordingly
        if (goal.type?.contains("step"))! {
            self.stepOrDistance.text = "Steps"
            self.stepOrDistance.backgroundColor = UIColor.brightBrown
            self.NoOfstepsOrDistance.text = "\(goal.quantity ?? 0)"}
        else if((goal.type?.contains("distance"))!){
            self.stepOrDistance.text = "Km";
            self.stepOrDistance.backgroundColor = UIColor.lightGreen
            self.NoOfstepsOrDistance.text = "\(goal.quantity!/1000)"}
        else{ print("API fetchGoal Changed!")}
        
        // set walk/run image based on type
        if (goal.type?.contains("walk"))!||(goal.type?.contains("step"))!{ self.walkOrRunImage.image = UIImage(named: "walk")}
        else if(goal.type?.contains("run"))!{ self.walkOrRunImage.image = UIImage(named: "run")}
        else{ print("API fetchGoal Changed!")}
        
        // set NoOfStepsOrDistance's color to green, yellow, red according to trophy
        if (goal.reward?.trophy == "zombie_hand") || (goal.reward?.trophy == "gold_medal"){self.NoOfstepsOrDistance.backgroundColor = UIColor.brightRed}
        else if (goal.reward?.trophy == "silver_medal"){ self.NoOfstepsOrDistance.backgroundColor = UIColor.brightYellow }
        else if (goal.reward?.trophy == "bronze_medal"){ self.NoOfstepsOrDistance.backgroundColor = UIColor.brightGreen }
        else{ print("API fetchGoal Changed!")}
    }

}

extension CellGoal{
    
    func addGreenCheckCover(){
        cover = UIView()
        let check = UIImage(named: "check")
        let maskedCheck = check!.maskWithColor(color: UIColor.brightGreen)
        checkImage = UIImageView(image: maskedCheck)
        checkImage?.tintColor = UIColor.brightGreen
        cover!.layer.borderWidth = 2
        cover!.layer.borderColor = UIColor.black.cgColor
        cover!.layer.cornerRadius = 10
        cover!.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        cover!.frame = CGRect(x: 0, y: 3, width: viewWidth - 32, height: 73.5)
        checkImage!.frame = CGRect(x: viewWidth - 32 - viewWidth*(1-0.618), y: 80/2 - 22.5 - 5.5, width: 45, height: 45)
        cover!.addSubview(checkImage!)
        self.addSubview(cover!)
        cover!.isHidden = true
    }
}
