//
//  SharedManager.swift
//  WLIDrawer-IOS
//
//  Created by Baby on 20.09.2020.
//  Copyright © 2020 Webline india. All rights reserved.
//

import Foundation
import UIKit

class SharedManager {
    static let shared = SharedManager()
    
    var citymenu_flag : Int = 0
    
    
    var preparing_AllOrderedFood = [EachOrderedFood]()
    var preparing_eachRestaurentInfo: EachRestaurent!
    var addmore_flag = false
    var restaurentFee : String!
    var locationLinkFinal :  String!
    var payMethodFinal : String!
    var phoneNumber : String!
    var userName : String!
    var orderID : String!
    var orderNumber : String!
    var wrongCount : Int!
    var totalPriceFinal :  String!
    var sumPrice : String = "0"
    
    var allRestaurents_share = [EachRestaurent]()
    var cityRestaurents_share = [EachRestaurent]()
    var selectedRestaurents_show1_share = [EachRestaurent]()
    var selectedRestaurents_show2_share = [EachRestaurent]()
    var selectedRestaurents_show3_share = [EachRestaurent]()
    
    var cityInfo: String!
    var buttonDoubleFlag = false
    var buttonDoubleFlag1 = false

    
}
