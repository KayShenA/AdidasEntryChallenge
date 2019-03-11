//
//  GoalsDataModel.swift
//  AdidasEntryChallenge
//
//  Created by Keyan  on 2019/3/9.
//  Copyright © 2019 Keyan . All rights reserved.
//

import Foundation


class GoalsDataModel: NSObject {
    var id: String?
    var title: String?
    var descriptions: String?
    var type: String?
    var quantity: Int?
    var reward: Reward?
    
    var trophy: String?
    var points: Int?
    
    var accomplish: String?
    
    init(id:String, title:String, descriptions:String, type:String, quantity:String, trophy: String, points: String, accomplish:String){
        self.id = id
        self.title = title
        self.descriptions = descriptions
        self.type = type
        self.quantity = Int(quantity)
        reward = Reward.init(trophy: trophy, points: Int(points)!)
        self.accomplish = accomplish
        super.init()
        
    }
    
    required init(dataDic:[String: AnyObject]) {
        super.init()
        id = dataDic["id"] as? String
        title = dataDic["title"] as? String
        descriptions = dataDic["description"] as? String
        type = dataDic["type"] as? String
        quantity = dataDic["goal"] as? Int
        if let rewardDic = dataDic["reward"] as? [String : AnyObject]{
            reward = Reward.init(dataDic: rewardDic)
        }
    }
}

class Reward: NSObject{
    var trophy: String?
    var points: Int?
    init(trophy: String, points: Int){
        self.trophy = trophy
        self.points = points
    }
    required init(dataDic:[String: AnyObject]) {
        trophy = dataDic["trophy"] as? String
        points = dataDic["points"] as? Int
    }
    
}






//        decodable tryout, failed, will try to find out why

//struct itemsModel: Decodable{
//    let id: Int
//    let title: String
//    let description: String
//    let type: String
//    let goal: Int
//    let reward: reward
//}
//struct reward: Decodable{
//    let trophy: String
//    let points: Int
//}
//
//
//class Goals{
//
//    class func decodeJsonWithResponse(response: NSData){
//        do {
//            let decoder = JSONDecoder()
////            decoder.keyDecodingStrategy = .convertFromSnakeCase
////            let datas = response.data(using: .utf8)
////            let data: Data = NSKeyedArchiver.archivedData(withRootObject: response)
//            let responses = try decoder.decode([items].self, from: response as Data)
//            print("is: ", responses)
//
//        } catch {
//            // handle error
//            print("error handling decode")
//        }
//    }
//}



//struct Goals: Codable {
//    enum CodingKeys: String, CodingKey {
//        case response = "items"
//        case id = "id"
//        case title = "title"
//        case description = "description"
//        case type = "type"
//        case goal = "goal"
//        case reward = "reward"
//        case trophy = "trophy"
//        case points = "points"
//    }
//    
//}

