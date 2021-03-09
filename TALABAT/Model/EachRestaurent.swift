/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class EachRestaurent: NSObject {
    var restaurentID: String = ""
    var restaurentCity: String = ""
    var restaurentCategoty: String = ""
    var restaurentName: String = ""
    var restaurentEmail: String = ""
    var restaurentPassword: String = ""
    var restaurentPhone: String = ""
    var restaurentLogo: String = ""
    var restaurentRank: String = ""
    var restaurentStatus: String = ""
    var restaurentFee: String = ""
    var restaurentResStatus: String = ""
    
    init(dic: [String: Any]) {
        self.restaurentID = dic["id"] as! String
        self.restaurentCity = dic["restaurant_city"] as! String
        self.restaurentCategoty = dic["restaurant_category"] as! String
        self.restaurentName = dic["restaurant_name"] as! String
        self.restaurentEmail = dic["email"] as! String
        self.restaurentPassword = dic["password"] as! String
        self.restaurentPhone = dic["phone"] as! String
        self.restaurentLogo = dic["file_name"] as! String
        self.restaurentRank = dic["rank"] as! String
        self.restaurentStatus = dic["status"] as! String
        self.restaurentFee = dic["fee"] as! String
        self.restaurentResStatus = dic["res_status"] as! String
    }
}
