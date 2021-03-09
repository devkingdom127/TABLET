//
//  File.swift
//  theMath
//
//  Created by Talent on 23.05.2020.
//  Copyright © 2020 Ron. All rights reserved.
//

import Foundation
class EachFood: NSObject {
    var foodID: String = ""
    var foodName: String = ""
    var foodDescription: String = ""
    var foodPrice: String = ""
    var foodImg: String = ""
    var foodOfRestaurentID: String = ""
    var foodOfRestaurentCategory: String = ""
    
    init(dic: [String: Any]) {
        self.foodID = dic["id"] as! String
        self.foodName = dic["product_name"] as! String
        self.foodDescription = dic["product_description"] as! String
        self.foodPrice = dic["product_price"] as! String
        self.foodImg = dic["product_image_filename"] as! String
        self.foodOfRestaurentCategory = dic["parent_category"] as! String
        self.foodOfRestaurentID = dic["parent_restaurant_id"] as! String
    }
}
