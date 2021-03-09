//
//  InputPhonePage.swift
//  TALABAT
//
//  Created by Baby on 09.12.2020.
//


import UIKit
import Alamofire
import AVFoundation
import NVActivityIndicatorView

class InputPhonePage: UIViewController {


    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPhoneField: UITextField!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NextBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])

    }
    
    @IBAction func ToVerifyPhoneAction(_ sender: Any)
    {
        if userNameField.text == ""
        {
            Utils.shared.showAlertWith(title: "Sorry but you didn't input your name now.", content: "Please input your name.", viewController: self)
            return
        }
        if userPhoneField.text == ""
        {
            Utils.shared.showAlertWith(title: "Sorry but you didn't input your phone number now.", content: "Please input your phone number.", viewController: self)
            return
        }
        
        let str = userPhoneField.text!
//        let comp = str.components(separatedBy: "5012")
//        print(comp)
//        let str1 = comp.last
//        print(str1!)
        


        SharedManager.shared.phoneNumber = "971" + str
        SharedManager.shared.userName = userNameField.text!
        SharedManager.shared.orderID = String(Date().millisecondsSince1970) + "_\(SharedManager.shared.phoneNumber!)"
        if SharedManager.shared.buttonDoubleFlag1 == false {
            SharedManager.shared.buttonDoubleFlag1 = true
            sendPhoneNumber()
        }

    }
    func sendPhoneNumber (){
        loadingView.startAnimating()

        let parameters : [String: Any] = [
            "orderID" :  SharedManager.shared.orderID!,
            "orderUserName" : SharedManager.shared.userName!,
            "orderMobile" : SharedManager.shared.phoneNumber!
        ]
        print(parameters)
        
        AF.request("http://sandwich-map.store/api/send-verify-sms", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON
        { [self] (response) in
                print(response.result)
            if "\(response.result)" == "success(ok)" {
                loadingView.stopAnimating()
                self.performSegue(withIdentifier: "PhoneToVerify", sender: self)
            }
            else {
                loadingView.stopAnimating()
            }

        }
    }
}
