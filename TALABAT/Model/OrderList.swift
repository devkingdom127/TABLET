//
//  OrderList.swift
//  TALABAT
//
//  Created by Baby on 17.12.2020.
//

import Foundation

class OrderList {
    var orderedIDOfFood: String = ""
    var OrderedFoodInfoOfFood: EachFood!
    var orderedQuantityOfFood: String = ""
    var orderedSpecialOfFood: String = ""
    var orderedSumOfFood: String = ""

    
    init(orderedIDOfFood: String, OrderedFoodInfoOfFood: EachFood, orderedQuantityOfFood: String,  orderedSpecialOfFood: String, orderedSumOfFood: String) {
        self.orderedIDOfFood = orderedIDOfFood
        self.OrderedFoodInfoOfFood = OrderedFoodInfoOfFood
        self.orderedQuantityOfFood = orderedQuantityOfFood
        self.orderedSpecialOfFood = orderedSpecialOfFood
        self.orderedSumOfFood = orderedSumOfFood

    }
}
