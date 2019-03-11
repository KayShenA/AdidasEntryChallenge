//
//  HealthDataManager.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/8.
//  Copyright © 2019 Keyan . All rights reserved.
//

import UIKit
import HealthKit

class HealthDataManager: NSObject {
    static let shareInstance: HealthDataManager = HealthDataManager()
    
    let healthDataModel = HealthDataModel.shareInstance
    
    let healthStore = HKHealthStore()
    
    weak var delegate: HealthDataManagerDelegate?
    
    func saveObjectWithTypeAndValue(object: [HKObject]) -> Void {
        healthStore.save(object) { (success, error) in
            print(success, " save to Health Kit success")
            print(error as Any,  " save to Health Kit fail")
        }
    }
    
    @available(iOS 9.3, *)
    func authorizeHealthKit(completion:((_ success:Bool,_ error:NSError?)->Void)!){
        
        let healthKitTypesToRead = readType
        let healthKitTypesToWrite = writeType
        
        if !HKHealthStore.isHealthDataAvailable(){
            let error = NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if completion != nil {
                completion!(false, error)
            }
            return
        }
        
        healthStore.requestAuthorization(toShare: healthKitTypesToWrite as? Set<HKObjectType> as! Set<HKSampleType>?, read: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in
            
            if completion != nil{
                completion!(success,error as NSError?)
            }
        }
    }
    
    // fetch current year's data based on type: stepCount/distance walking running
    
    func fetchTheTypeOfData(type: healthData) -> Void {
        let predicateCurrentYear = HelpManager.getCurrentYear()
        
        switch type {
        case .stepCount:
            let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: .stepCount)!, predicate: predicateCurrentYear, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                
                for item in results! {
                    let stepCount = item as? HKQuantitySample
                    let date = stepCount?.startDate
                    if let stepCount = stepCount?.quantity.doubleValue(for: HKUnit.count()){
                        print("\(Int(stepCount)) steps on \(date!)")
                        if !self.healthDataModel.date.contains(date!){
                            self.healthDataModel.stepCount.append(Int(stepCount))
                            self.healthDataModel.date.append(date!)
                        }
                        
                    }
                }
            }
            healthStore.execute(query)
            break
            
        case .distanceWalkingRunning:
            let query = HKSampleQuery(sampleType: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, predicate: predicateCurrentYear, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                
                for item in results! {
                    let distanceWalkingRunning = item as? HKQuantitySample
                    let date = distanceWalkingRunning?.startDate
                    if let distanceWalkingRunning = distanceWalkingRunning?.quantity.doubleValue(for: HKUnit.mile()){
                        if !self.healthDataModel.date.contains(date!){
                            self.healthDataModel.distanceWalkingRunning.append(distanceWalkingRunning)
                            self.healthDataModel.date.append(date!)
                        }
                        print("\(String(format: "%.1f", distanceWalkingRunning/1.6)) kms on \(date!)")
                    }
                }
            }
            healthStore.execute(query)
            break
        }
    }
}

enum healthData: Int {
    case stepCount
    case distanceWalkingRunning
}

@available(iOS 9.3, *)
let readType = NSSet(array:[
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
    ])

@available(iOS 9.3, *)
let writeType = NSSet(array:[
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
    ])

protocol HealthDataManagerDelegate: NSObjectProtocol {
    func researchTheDataAccordingTime(type: healthData, result: String) -> Void
}
