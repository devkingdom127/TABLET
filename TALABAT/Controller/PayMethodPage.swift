//
//  ViewController.swift
//  RadioButton
//
//  Created by Jithin Balan on 14/4/20.
//  Copyright © 2020 Jithin Balan. All rights reserved.
//

import UIKit
import AVFoundation

class PayMethodPage: UIViewController {
    
    var buttons : [RadioButton]?
    var payMethod : Int = 0
    
    @IBOutlet weak var violet: RadioButton!
    @IBOutlet weak var indigo: RadioButton!
    
    @IBOutlet weak var NextBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NextBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])
        
        buttons = [violet, indigo]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func radioButtonTapped(_ sender: RadioButton) {
        buttons?.forEach({ $0.isSelected = false})
        sender.isSelected = true
        payMethod = sender.tag
        print (sender.tag)
    }
    
    @IBAction func ToInputPhoneAction(_ sender: Any)
    {
        if payMethod == 0
        {
            Utils.shared.showAlertWith(title: "Sorry but you didn't paymethod now.", content: "Please select your paymethod.", viewController: self)
            return
        }
        else {
            SharedManager.shared.payMethodFinal = String(payMethod)
            self.performSegue(withIdentifier: "PayToPhone", sender: self)
        }
    }
}

    
    

