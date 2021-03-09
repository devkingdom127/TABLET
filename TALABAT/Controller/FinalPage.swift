//
//  FinalPage.swift
//  TALABAT
//
//  Created by Baby on 09.12.2020.
//

import UIKit
import AVFoundation

class FinalPage: UIViewController {

    @IBOutlet weak var FinishBtn: UIButton!
    @IBOutlet weak var orderNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        orderNumber.text = "Your order number : \(SharedManager.shared.orderNumber!)"
        self.FinishBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])

    }
    override func viewWillAppear(_ animated: Bool) {
        SharedManager.shared.buttonDoubleFlag = false
    }
    
    @IBAction func ToHomeAction(_ sender: Any)
    {
        SharedManager.shared.addmore_flag = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: RestaurentListViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
