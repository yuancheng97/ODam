//
//  FoodModel.swift
//  FridgeTest
//
//  Created by Iris Jiang on 3/30/19.
//  Copyright © 2019 Iris Jiang. All rights reserved.
//
import Foundation
import Foundation.NSDate

class FoodModel{
    var id: String?
    var name: String?
    var exp: String?
    var date: String?
    
    init(id:String?, name:String?, exp:String?, date:String?){
        self.id = id
        self.name = name
        self.exp = exp
        self.date = date
    }
}
