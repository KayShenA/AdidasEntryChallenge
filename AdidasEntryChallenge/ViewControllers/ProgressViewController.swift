//
//  ProgressViewController.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/9.
//  Copyright © 2019 Keyan . All rights reserved.
//

import UIKit
import AMPopTip
import CRRefresh
import PopupDialog
import Lottie
import HealthKit


class ProgressViewController: UIViewController {
    
    
    @IBOutlet weak var progressTableView: UITableView!
    var goals =  [GoalsDataModel]()
    var hud = UIWindow()
    let popTip = PopTip()
    var selectedRow = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        popTip.bubbleColor = UIColor.gray
        registerprogressTableView()
        HelpManager.changeStatusBarToWhiteTextBlackBackground()
        instructionAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearAllNotice()
        getGoalsNotAccomplished()
        self.progressTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedRow = -1
        self.hud.hide()
    }
    
    
}

//Tableview
extension ProgressViewController:UITableViewDelegate,UITableViewDataSource{
    
    func registerprogressTableView(){
        progressTableView.delegate = self
        progressTableView.dataSource = self
        let cellNib = UINib(nibName: "CellGoal", bundle: nil)
        progressTableView.register(cellNib, forCellReuseIdentifier: CellGoal.cellIdentify())
        progressTableView.separatorStyle = .none
        progressTableView.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.progressTableView.reloadRows(at: [indexPath], with: .automatic)
        self.progressTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellGoal.cellIdentify()) as! CellGoal
        let goal = goals[indexPath.row]
        
        cell.setCellDataWithDataModelWithLogics(goal: goal)
        cell.selectionStyle = .none

        cell.background.backgroundColor = UIColor.brightOrange
        cell.descriptionBtn.isHidden = true
        cell.title.textColor = UIColor.black
        cell.points.textColor = UIColor.black
        
        cell.descriptionBtn.tag = indexPath.row
        cell.descriptionBtn.addTarget(self,action:#selector(self.DescriptionBtnAction(sender:)), for: .touchUpInside)
        if (indexPath.row % 2 == 0){
            cell.shake(count: 2, for: 0.25, withTranslation: 4)
        }else{
            cell.shake(count: 2, for: 0.25, withTranslation: -4)
        }
        
        if (indexPath.row == selectedRow) && selectedRow >= 0{
            //shake it and reset the indicator
            cell.shake(count: 10, for: 1.25, withTranslation: 4)
            let goal = goals[selectedRow]
            openTheDialog(title: goal.title ?? "", description: goal.descriptions ?? "", trophy: goal.reward!.trophy ?? "")
        }
        
        return cell
        
    }
    
    @objc func DescriptionBtnAction(sender: UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0);
        self.progressTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView(self.progressTableView, didSelectRowAt: indexPath)
    }
    
    
}

//Network
extension ProgressViewController{
    
    
}

//Database
extension ProgressViewController{
    func getGoalsNotAccomplished(){
        goals = DataBaseManager.fetchData(range: .onlyUnAccomplished)
    }
    func updateAccomplish(goal: GoalsDataModel){
        if (DataBaseManager.updateData(goal: self.goals[self.selectedRow])){
            self.noticeSuccess("Updated to DB")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.clearAllNotice()
            })
            self.getGoalsNotAccomplished()
            self.progressTableView.reloadData()
        }
    }
}

//Instruction Animation{
extension ProgressViewController{
    func instructionAnimation(){
        let hoverView = UIView()
        hoverView.frame = self.view.frame
        hoverView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.view.addSubview(hoverView)
        let animationView = LOTAnimationView(name: "handGesture")
        animationView.frame = CGRect(x: self.view.frame.width*2/3, y: self.view.center.y - self.view.frame.height/3, width: 80, height: 80)
        hoverView.addSubview(animationView)
        animationView.play{ (finished) in
            // Do Something
            hoverView.removeFromSuperview()
        }
    }
}

//Dialog
extension ProgressViewController{
    func openTheDialog(title:String, description:String, trophy: String){

        let cleanTrophyString = trophy.replacingOccurrences(of: "_", with: " ")
        let cleanTrophyString2 = cleanTrophyString.replacingOccurrences(of: "medal", with: "trophy")
        
        let titleDetailed = "Congratulation! Are you ready to collect \(cleanTrophyString2)?"
        let message = "You successfully complete the goal: \(title): \(description)"
        let image = UIImage(named: "\(trophy)HighResolution")
        
        let popup = PopupDialog(title: titleDetailed,
                                message: message,
                                image: image,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                preferredWidth: 100,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
        }
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = .darkGray
        dialogAppearance.titleFont            = .boldSystemFont(ofSize: 20)
        dialogAppearance.titleColor           = UIColor.white
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = .systemFont(ofSize: 17)
        dialogAppearance.messageColor         = UIColor.white
        dialogAppearance.messageTextAlignment = .center
        
        let containerAppearance = PopupDialogContainerView.appearance()
        containerAppearance.cornerRadius    = 15

        let buttonOne = CancelButton(title: "CANCEL") {
        }
        let buttonTwo =  DefaultButton(title: "Collect it!") {
            //update database
            let goal = self.goals[self.selectedRow]
            self.updateAccomplish(goal: goal)
            //store sample to HealthKit
            self.noticeSuccess("Updated to HK")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.clearAllNotice()
            })
            let quantity = String(goal.quantity!)
            if goal.type == "step"{
                self.storeHKSample(quantityinString: quantity, isStepNorDistance: true)
            }else{
                self.storeHKSample(quantityinString: quantity, isStepNorDistance: false) // /1.6 to be miles for HealthKit
            }
            self.selectedRow = -1
        }
        popup.addButtons([buttonOne, buttonTwo])
        
        self.present(popup, animated: true, completion: nil)
        
    }
    
}

//HealthKit
extension ProgressViewController{
    func storeHKSample(quantityinString: String, isStepNorDistance: Bool){

        //default using one hour earlier to now
        if isStepNorDistance{
            let quantity =  HKQuantity.init(unit: HKUnit.count(), doubleValue:quantityinString.toDouble()!)
            let quantitySample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, quantity: quantity, start: Date.OneHourEarlierFromNow, end: Date())
            HealthDataManager.shareInstance.saveObjectWithTypeAndValue(object: [quantitySample])

        }else{
            let quantity =  HKQuantity.init(unit: HKUnit.mile(), doubleValue:quantityinString.toDouble()!/1.6/1000) // /1.6 to be mile, /1000 to be km
            let quantitySample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, quantity: quantity, start: Date.OneHourEarlierFromNow, end: Date())
            HealthDataManager.shareInstance.saveObjectWithTypeAndValue(object: [quantitySample])

        }
        
        
    }
}



