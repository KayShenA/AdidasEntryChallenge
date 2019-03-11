//
//  HealthDataModel.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/8.
//  Copyright © 2019 Keyan . All rights reserved.
//

import UIKit
import HealthKit
class HealthDataModel: NSObject {
    
    static let shareInstance = HealthDataModel()
    
    var stepCount = [Int]()
    var distanceWalkingRunning = [Double]()
    var date = [Date]()
    
    var countOfWorkouts: Int = 0
    
    func totalStepCount() -> Int{
        return stepCount.reduce(0, +)
    }
    
    func totalDistanceWalkingRunning() -> Double{
        return distanceWalkingRunning.reduce(0, +)*1.6 // * 1.6 to be km
    }

    
    func printDetailInfo() -> Void {
        print("----------")
        print(stepCount, "is stepCount")
        print(distanceWalkingRunning, "is distanceWalking RUnning")
        print("-----------")
    }

}
