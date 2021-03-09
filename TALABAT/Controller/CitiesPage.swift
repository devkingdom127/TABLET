//
//  CitiesPage.swift
//  TALABAT
//
//  Created by Baby on 24.12.2020.
//
import UIKit
import AVFoundation
import Foundation
import Alamofire
import SwiftyJSON

class CitiesPage : UIViewController {
    
    var allRestaurents = [EachRestaurent]()
    var cityInfo_temp : String!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalTitle: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var Btn6: UIButton!
    @IBOutlet weak var Btn7: UIButton!
    @IBOutlet weak var Btn8: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])
        defaultBtnEffect()
        modalTitle.removeshadowEffect()
      
    }
    @IBAction func CityBtnPressed(_ sender: UIButton) {

        SharedManager.shared.cityInfo = "\(sender.tag)"
        switch sender.tag {
        case 1:
            defaultBtnEffect()
            Btn1.shadowEffect()
            img1.isHidden = false
        case 2:
            defaultBtnEffect()
            Btn2.shadowEffect()
            img2.isHidden = false

        case 3:
            defaultBtnEffect()
            Btn3.shadowEffect()
            img3.isHidden = false

        case 4:
            defaultBtnEffect()
            Btn4.shadowEffect()
            img4.isHidden = false

        case 5:
            defaultBtnEffect()
            Btn5.shadowEffect()
            img5.isHidden = false

        case 6:
            defaultBtnEffect()
            Btn6.shadowEffect()
            img6.isHidden = false

        case 7:
            defaultBtnEffect()
            Btn7.shadowEffect()
            img7.isHidden = false

        case 8:
            defaultBtnEffect()
            Btn8.shadowEffect()
            img8.isHidden = false
        default:
            defaultBtnEffect()
        }
    }
    
    @IBAction func ToRestaurentListPage(_ sender: UIButton) {

        if SharedManager.shared.cityInfo == nil {
            Utils.shared.showAlertWith(title: "You didn't select your city!", content: "Please select your city.", viewController: self)
            return
        }
        else {
            self.performSegue(withIdentifier: "citiesTorestaurents", sender: nil)
        }
    }
    
    func defaultBtnEffect() {
        
        Btn1.removeshadowEffect()
        Btn2.removeshadowEffect()
        Btn3.removeshadowEffect()
        Btn4.removeshadowEffect()
        Btn5.removeshadowEffect()
        Btn6.removeshadowEffect()
        Btn7.removeshadowEffect()
        Btn8.removeshadowEffect()
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        img4.isHidden = true
        img5.isHidden = true
        img6.isHidden = true
        img7.isHidden = true
        img8.isHidden = true

    }
}

