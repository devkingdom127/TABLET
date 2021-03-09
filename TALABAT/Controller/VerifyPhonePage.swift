//
//  VerifyPhonePage.swift
//  TALABAT
//
//  Created by Baby on 09.12.2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import AVFoundation
import NVActivityIndicatorView

class VerifyPhonePage: UIViewController {

    var backgroundMusicPlayer: AVAudioPlayer?
    var player:AVAudioPlayer = AVAudioPlayer()
    @discardableResult func playSound(named soundName: String) -> AVAudioPlayer {
        let audioPath = Bundle.main.path(forResource: soundName, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        player.play()
        return player
    }

    var verifycodeOfService: String!
    var orderlist: [String: String] = [:]
    var orderlists = [Any]()
    var sendCode_flag = false
    var sendOrder_flag = false
    
    @IBOutlet weak var verifycodeOfUser: UITextField!
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NextBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])

    }
    override func viewWillAppear(_ animated: Bool) {
        SharedManager.shared.buttonDoubleFlag1 = false
    }
    
    @IBAction func ToFinishAction(_ sender: Any)
    {
        if verifycodeOfUser.text == ""
        {
            Utils.shared.showAlertWith(title: "Wrong verify code!", content: "Please input your correct verify code.", viewController: self)
            return
        }

        if SharedManager.shared.buttonDoubleFlag == false {
            SharedManager.shared.buttonDoubleFlag = true
            sendCode()
        }
        
    }
    func sendCode (){

        let parameters1 : [String: Any] = [
            "orderID" : SharedManager.shared.orderID!,
            "orderverifycode" : verifycodeOfUser.text!,
            "orderMobile" : SharedManager.shared.phoneNumber!
        ]
       
    print(parameters1)
        AF.request("http://sandwich-map.store/api/check-verifycode", method: .post, parameters: parameters1, encoding: JSONEncoding.default).responseJSON
        { (response) in
                print(response.result)
            if "\(response.result)" == "success(ok)" {
                self.genericMethod()
            }
            else {
                SharedManager.shared.wrongCount = SharedManager.shared.wrongCount + 1
                if SharedManager.shared.wrongCount <= 2 {
                    Utils.shared.showAlertWith(title: "Wrong verify code!", content: "You can request verifycode again from previous page.", viewController: self)
                    return
                }
                else {
                    let refreshAlert = UIAlertController(title: "Wrong verify code!", message: "Your order was cancelled automatically because you sent wrong verifycode for 3 times.", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        SharedManager.shared.addmore_flag = false
                        
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: RestaurentListViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
   func genericMethod (){
        self.loadingView.startAnimating()

        var orderDateTime :String!
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        orderDateTime = String(formatter.string(from: now))
        
        orderlists.removeAll()
        for item in SharedManager.shared.preparing_AllOrderedFood {
            var order: [String: String] = [String: String]()
            order["foodId"] = item.OrderedFoodInfoOfFood.foodID
            order["foodCount"] = item.orderedQuantityOfFood
            order["orderDetail"] = item.orderedSpecialOfFood
            order["foodName"] = item.OrderedFoodInfoOfFood.foodName
            orderlists.append(order)
        }
        let parameters : [String: Any] = [
            "orderDate" : orderDateTime!,
            "orderLocation" : SharedManager.shared.locationLinkFinal!,
            "orderMobile" : SharedManager.shared.phoneNumber!,
            "totalBill" : SharedManager.shared.totalPriceFinal!,
            "orderPayment" : SharedManager.shared.payMethodFinal!,
            "foodRestaurant" : SharedManager.shared.preparing_eachRestaurentInfo.restaurentName,
            "foodRestaurantId" : SharedManager.shared.preparing_eachRestaurentInfo.restaurentID,
            "foodRestaurantCity" : SharedManager.shared.preparing_eachRestaurentInfo.restaurentCity,
            "orderFoods" : orderlists
        ]
    print(parameters)
        
        AF.request("http://sandwich-map.store/public/api/store-order-infomation", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON
        { [self] (response) in
                print(response.result)
            if "\(response.result)" != "success(no)" {
                let str = "\(response.result)"
                let comp = str.components(separatedBy: "(")
                let str1 = comp.last
                
                let str2 = str1?.replacingOccurrences(of: ")", with: "")
                SharedManager.shared.orderNumber = str2!
                playSound(named: "sound")
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                self.loadingView.stopAnimating()
                self.performSegue(withIdentifier: "VerifyToFinish", sender: self)
            }
            else {
                Utils.shared.showAlertWith(title: "Your order was not completed!", content: "Sorry but please retry again.", viewController: self)
                SharedManager.shared.addmore_flag = false
                self.loadingView.stopAnimating()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: RestaurentListViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }

        }
    }
}
