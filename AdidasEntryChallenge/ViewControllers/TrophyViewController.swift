//
//  TrophyViewController.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/9.
//  Copyright © 2019 Keyan . All rights reserved.
//

import UIKit
import HealthKit
import BouncyLayout

class TrophyViewController: UIViewController {
    
    @IBOutlet weak var zombieCount: UILabel!
    @IBOutlet weak var goldCount: UILabel!
    @IBOutlet weak var silverCount: UILabel!
    @IBOutlet weak var bronzeCount: UILabel!
    @IBOutlet weak var pointCount: UILabel!
    @IBOutlet weak var kmCount: UILabel!
    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var stepCountHealthKit: UILabel!
    @IBOutlet weak var kmCountHealthKit: UILabel!
    var goals :[GoalsDataModel]?
    var numberOfItems = 0
    var bufferSize = 500
    var randomCellStyle: CellStyle { return arc4random_uniform(10) % 2 == 0 ? .blue : .gray }
    
    lazy var style: [CellStyle] = { (0..<self.bufferSize).map { _ in self.randomCellStyle } }()
    lazy var topOffset: [CGFloat] = { (0..<self.bufferSize).map { _ in CGFloat(arc4random_uniform(250)) } }()
    
    lazy var sizes: [CGSize] = {
        
        return (0..<self.bufferSize).map { _ in
            return CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 3), height: floor((UIScreen.main.bounds.width - (5 * 10)) / 3))
        }
    }()
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 300, left: 0, bottom: 300, right: 0)
    }
    
    var additionalInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    lazy var layout = BouncyLayout(style: .regular)
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.brightBrown
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(CellTrophy.self, forCellWithReuseIdentifier: CellTrophy.cellIdentify())
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brightBrown
        view.clipsToBounds = true
        collectionViewLayouts()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        setsAgain()
        fetchAllTrophiesFromDatabase()
        fetchHealthKitData()
    }
    
    func setsAgain(){
        sizes = {
            return (0..<self.numberOfItems).map { _ in
                return CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 3), height: floor((UIScreen.main.bounds.width - (5 * 10)) / 3))
            }
        }()
    }

    
}



extension TrophyViewController: UICollectionViewDataSource {
    func collectionViewLayouts(){
        // side inset
        collectionView.contentInset = UIEdgeInsets(top: insets.top + additionalInsets.top, left: insets.left + additionalInsets.left, bottom: insets.bottom + additionalInsets.bottom, right: insets.right + additionalInsets.right)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        view.addSubview(collectionView)
        
        //contraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -UIScreen.main.bounds.width/5*3)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTrophy.cellIdentify(), for: indexPath) as! CellTrophy
        let goal = goals![indexPath.item]
        cell.imageView.image = UIImage(named: "\(goal.reward!.trophy!)HighResolution")
        //        cell.imageView.image = UIImage(named: "gold_medalHighResolution")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CellTrophy else { return }
        cell.setCell(style: style[indexPath.row])
        
    }
    
    
}

extension TrophyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < sizes.count{
            return sizes[indexPath.row]
        }else{
            return CGSize.init(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// database and dataprocess
extension TrophyViewController{
    func fetchAllTrophiesFromDatabase(){
        goals = DataBaseManager.fetchData(range: DataBaseManager.rangeOfFetch.onlyAccomplished)
        if goals != nil{
            numberOfItems = goals!.count
            collectionView.reloadData()
            var dict = [String: Int]()
            dict["zombie_hand"] = 0
            dict["gold_medal"] = 0
            dict["silver_medal"] = 0
            dict["bronze_medal"] = 0
            dict["point"] = 0
            dict["km"] = 0
            dict["step"] = 0
            for goal in goals! {
                dict["point"] = dict["point"]! + goal.reward!.points!
                if goal.type == "step"{
                    dict["step"] = dict["step"]! + goal.quantity!
                }else{
                    dict["km"] = dict["km"]! + goal.quantity!/1000
                }
                if goal.reward!.trophy == "zombie_hand"{
                    dict["zombie_hand"] = dict["zombie_hand"]! + 1
                }else if goal.reward!.trophy == "gold_medal"{
                    dict["gold_medal"] = dict["gold_medal"]! + 1
                }else if goal.reward!.trophy == "silver_medal"{
                    dict["silver_medal"] = dict["silver_medal"]! + 1
                }else if goal.reward!.trophy == "bronze_medal"{
                    dict["bronze_medal"] = dict["bronze_medal"]! + 1
                }
                
            }
            
            zombieCount.text = "\(String(describing: dict["zombie_hand"]!))"
            goldCount.text = "\(String(describing: dict["gold_medal"]!))"
            silverCount.text = "\(String(describing: dict["silver_medal"]!))"
            bronzeCount.text = "\(String(describing: dict["bronze_medal"]!))"
            pointCount.text = "\(String(describing: dict["point"]!))"
            kmCount.text = "\(String(describing: (dict["km"]!)))"
            stepCount.text = "\(String(describing: dict["step"]!))"
            
        }else{
            numberOfItems = 0
            
        }
        
    }
}

// fetch healthKit data and save to healthKit
extension TrophyViewController{
    func fetchHealthKitData(){
        HealthDataManager.shareInstance.fetchTheTypeOfData(type: .distanceWalkingRunning)
        self.noticeInfo("Fetch from HK")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[unowned self] in
            HealthDataManager.shareInstance.healthDataModel.printDetailInfo()
            self.kmCountHealthKit.text = "\(HealthDataManager.shareInstance.healthDataModel.totalDistanceWalkingRunning())"

        }
        HealthDataManager.shareInstance.fetchTheTypeOfData(type: .stepCount)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[unowned self] in
            HealthDataManager.shareInstance.healthDataModel.printDetailInfo()
            self.stepCountHealthKit.text = "\(HealthDataManager.shareInstance.healthDataModel.totalStepCount())"
            self.clearAllNotice()

        }

        
    }
}
