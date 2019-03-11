//
//  GoalsViewController.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/9.
//  Copyright © 2019 Keyan . All rights reserved.
//

import UIKit
import AMPopTip
import CRRefresh


class GoalViewController: UIViewController {
    
    
    @IBOutlet weak var goalTableview: UITableView!
    var goals =  [GoalsDataModel]()
    var hud = UIWindow()
    let popTip = PopTip()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        popTip.bubbleColor = UIColor.gray
        registerGoalTableview()
        HelpManager.changeStatusBarToWhiteTextBlackBackground()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGoalsFromEndPoint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hud.hide()
    }
    
    
}

//Tableview
extension GoalViewController:UITableViewDelegate,UITableViewDataSource{
    
    func registerGoalTableview(){
        goalTableview.delegate = self
        goalTableview.dataSource = self
        let cellNib = UINib(nibName: "CellGoal", bundle: nil)
        goalTableview.register(cellNib, forCellReuseIdentifier: CellGoal.cellIdentify())
        goalTableview.separatorStyle = .none
        goalTableview.backgroundColor = UIColor.clear
        goalTableview.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self!.fetchGoalsFromEndPoint()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tip view to show descriptions
        let rectOfCell = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCell, to: tableView.superview)
        let goal = goals[indexPath.row]
        popTip.show(text: "\(goal.descriptions!)", direction: .up, maxWidth: 200, in: self.view, from: CGRect(x: rectOfCellInSuperview.size.width / 2, y: rectOfCellInSuperview.origin.y + tableView.contentOffset.y + rectOfCellInSuperview.size.height / 2, width: 1, height: 1))
        self.goalTableview.deselectRow(at: indexPath, animated: false)
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

        // show the green completion cover / not based on key: accomplish in database
        if goal.accomplish! == "YES"{
            cell.cover?.isHidden = false
            cell.selectionStyle = .none
        }else{
            cell.cover?.isHidden = true
            cell.selectionStyle = .none
        }
        
        // set descriptioni to linked to tableview didselect
        cell.descriptionBtn.tag = indexPath.row
        cell.descriptionBtn.addTarget(self,action:#selector(self.DescriptionBtnAction(sender:)), for: .touchUpInside)
        cell.background.shake()
        
        return cell
        
    }
    
    @objc func DescriptionBtnAction(sender: UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0);
        self.goalTableview.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        tableView(self.goalTableview, didSelectRowAt: indexPath)
    }
    
    
}

//Network
extension GoalViewController{
    func fetchGoalsFromEndPoint(){
        NetworkClient.fetchGoals(succeed: Success(_:), failed: Failure(_:))
        hud = self.pleaseWait()
        
    }
    
    func Success(_ response: AnyObject?) -> Void{
        
        if let dataArray = response?["items"] as? [[String: AnyObject]]{
            goals.removeAll()
            for item in dataArray{
                goals.append(GoalsDataModel.init(dataDic: item))
            }
            for goal in goals{
                storeOneLineDataIntoDatabase(goal: goal)
            }
            getGoalsAccomplished()
            self.goalTableview.reloadData()

            DispatchQueue.main.async {
                self.goalTableview.reloadData()
                self.hud.hide()
                self.goalTableview.cr.endHeaderRefresh()
            }
            
            /*        decodable tryout, failed, will try to find out why
             Goals.decodeJsonWithResponse(response: response?.data(using: .utf8))
             */
        }
    }
    
    func Failure(_ error: NSError?) -> Void {
        self.noticeError("Network Err")
        print(error! as NSError, "fetch Goals Fail")
    }
    
}

//Database
extension GoalViewController{
    func storeOneLineDataIntoDatabase(goal: GoalsDataModel){
        if (DataBaseManager.storeData(goal: goal)){
            self.noticeSuccess("Stored in DB")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.clearAllNotice()
            })
        }
        
    }
    
    func getGoalsAccomplished(){
        goals = DataBaseManager.fetchData(range: .all)
    }
}


