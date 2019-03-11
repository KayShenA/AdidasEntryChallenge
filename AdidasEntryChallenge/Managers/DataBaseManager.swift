//
//  DataBaseManager.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/10.
//  Copyright © 2019 Keyan . All rights reserved.
//

import Foundation
import UIKit
import FMDB

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
let databasePath = documentsPath.appendingPathComponent("goals.db")

func setupDatabase(){
    
    let filemgr = FileManager.default
    if !filemgr.fileExists(atPath: databasePath as String) {
        
        let goalDB = FMDatabase(path: databasePath as String)
        
        if goalDB.open() {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS GOALS (ID INTEGER PRIMARY KEY, TITLE TEXT, DESCRIPTION TEXT, TYPE TEXT, QUANTITY TEXT, TROPHY TEXT, POINTS TEXT, ACCOMPLISH TEXT)"
            if !goalDB.executeStatements(sql_stmt) {
                print("Error: \(goalDB.lastErrorMessage())")
            }
            goalDB.close()
        } else {
            print("Error: \(goalDB.lastErrorMessage())")
        }
    }
}

class DataBaseManager{
    enum rangeOfFetch {
        case all
        case onlyUnAccomplished
        case onlyAccomplished
    }
    
    class func storeData(goal: GoalsDataModel) -> Bool{
        //check existence of duplicate before insert
        if (!checkExistence(id: goal.id!)){
            
            let goalDB = FMDatabase(path: databasePath as String)
            
            if goalDB.open() {
                
                let insertSQL = "INSERT INTO GOALS (id, title, description, type, quantity, trophy, points, accomplish) VALUES ('\(goal.id!)', '\(goal.title!)', '\(goal.descriptions!)', '\(goal.type!)','\(goal.quantity!)','\(goal.reward!.trophy!)','\(goal.reward!.points!)','NO')"
                
                let result = goalDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [1])
                
                if !result {
                    print("Error: \(goalDB.lastErrorMessage()), failed to add goal")
                    return false
                } else {
                    print("successfull added to database")
                    return true
                }
            } else {
                print("Error: \(goalDB.lastErrorMessage())")
                return false
            }
        }else{
            print("Record already exists!")
            return false
        }
    }
    
    class func checkExistence(id: String)-> Bool{
        
        let goalDB = FMDatabase(path: databasePath as String)
        
        if goalDB.open() {
            let querySQL = "SELECT * FROM GOALS WHERE id == '\(id)'"
            
            let results:FMResultSet? = goalDB.executeQuery(querySQL,
                                                           withArgumentsIn: [1])
            if results?.next() == true {
                goalDB.close()
                return true
            } else {
                goalDB.close()
                return false
            }
        } else {
            print("Error: \(goalDB.lastErrorMessage()), RECORD ALREDAY EXIST")
            return true
        }
    }
    

    
    class func fetchData(range:DataBaseManager.rangeOfFetch)->[GoalsDataModel]{
        var goals = [GoalsDataModel]()
        
        let goalDB = FMDatabase(path: databasePath as String)
        
        if goalDB.open() {
            
            var querySQL = "SELECT * FROM GOALS WHERE accomplish == 'NO'"
            if range == rangeOfFetch.all{
                querySQL = "SELECT * FROM GOALS"
            }
            if range == rangeOfFetch.onlyAccomplished{
                querySQL = "SELECT * FROM GOALS WHERE accomplish == 'YES'"
            }

            
            let results:FMResultSet? = goalDB.executeQuery(querySQL,
                                                           withArgumentsIn: [1])
            
            while results?.next() == true {
                let id = results?.string(forColumn: "id")
                let title = results?.string(forColumn: "title")
                let descriptions = results?.string(forColumn: "description")
                let type = results?.string(forColumn: "type")
                let quantity = results?.string(forColumn: "quantity")
                let trophy = results?.string(forColumn: "trophy")
                let points = results?.string(forColumn: "points")
                let accomplish = results?.string(forColumn: "accomplish")
                let goal = GoalsDataModel.init(id: id!, title: title!, descriptions: descriptions!, type: type!, quantity: quantity!, trophy: trophy!, points: points!, accomplish: accomplish!)
                goals.append(goal)
                
                print("Record Found")
            }
            goalDB.close()
        } else {
            print("Error: \(goalDB.lastErrorMessage())")
        }
        return goals
    }
    
    
    class func updateData(goal: GoalsDataModel) -> Bool{
        if (checkExistence(id: goal.id!)){
            
            let goalDB = FMDatabase(path: databasePath as String)
            
            if goalDB.open() {
                
                let insertSQL = "UPDATE GOALS SET accomplish='YES' WHERE id='\(goal.id!)'"
                
                let result = goalDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [1])
                
                if !result {
                    print("Error: \(goalDB.lastErrorMessage()), failed to update Goal")
                    return false
                } else {
                    print("successfully update database")
                    return true
                }
            } else {
                print("Error: \(goalDB.lastErrorMessage())")
                return false
            }
        }else{
            print("Record already exists!")
            return false
        }
    }
    
}
