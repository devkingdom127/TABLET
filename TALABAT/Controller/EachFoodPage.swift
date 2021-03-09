//
//  EachFoodPage.swift
//  TALABAT
//
//  Created by Baby on 07.12.2020.
//

import UIKit
import AVFoundation
import SDWebImage
import NVActivityIndicatorView


class EachFoodPage : UIViewController {
    
    var eachFoodInfo: EachFood!
    var preparing_EachOrderedFood : EachOrderedFood!
    var endEditing = false


    @IBOutlet weak var foodDetailView: UIView!
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    
    @IBOutlet weak var specialRequest: UITextView!
    
    @IBOutlet weak var foodQuantity: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var sumPrice: UILabel!
    @IBOutlet weak var addcartBtn: UIButton!
    @IBOutlet weak var seecartBtn: UIButton!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!

    
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

//        foodImg.makeRounded()

        self.addcartBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])
        self.seecartBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x55C8FA).cgColor,Utils.shared.UIColorFromRGB(0x55C8FE).cgColor])

        loadingView.startAnimating()
        if let url = URL(string: "http://sandwichmap-control.me/public/files/\((eachFoodInfo.foodImg).replacingOccurrences(of: " ", with: "%20"))") {
            self.foodImg.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if( error != nil) {
                print("Error while displaying image" , (error?.localizedDescription)! as String)
                }
                self.loadingView.stopAnimating()
            })
        }
        else {
            let defaultImg: UIImage = UIImage(named: "noImg")!
            self.foodImg.image = defaultImg
            self.loadingView.stopAnimating()
        }
        foodPrice.text = "\(eachFoodInfo.foodPrice) AED"
        foodName.text = eachFoodInfo.foodName
        foodDescription.text = eachFoodInfo.foodDescription
        
        specialRequest.text = "Add more sauce!"
        specialRequest.textColor = UIColor.lightGray
        
//        specialRequest.layer.borderColor = UIColor.brown.cgColor
//        specialRequest.layer.borderWidth = 1
//        specialRequest.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
        foodQuantity.text = "0"
        sumPrice.text = "0 AED"
        seecartCalculating()
        if ( Int(foodQuantity.text!) == 0 ) {
            addcartBtn.isHidden = true
//            seecartBtn.isHidden = true
        }
        else {
            addcartBtn.isHidden = false
//            seecartBtn.isHidden = false

        }

    }
    func seecartCalculating() {
        if SharedManager.shared.sumPrice == "0" {
            if String(Int((sumPrice.text!).replacingOccurrences(of: " AED", with: ""))!) == "0"
            {
                let seecartTitle = "SEE CART      Total 0 AED"
                seecartBtn.setTitle( seecartTitle, for: .normal)
                seecartBtn.isHidden = true
            }
            else {
                let sumprice_temp = String(Int(SharedManager.shared.restaurentFee)! + Int((sumPrice.text!).replacingOccurrences(of: " AED", with: ""))!)
                let seecartTitle = "SEE CART      Total \(sumprice_temp) AED"
                seecartBtn.setTitle( seecartTitle, for: .normal)
                seecartBtn.isHidden = false
            }

        }
        else {
            let sumprice_temp = String(Int((sumPrice.text!).replacingOccurrences(of: " AED", with: ""))! + Int(SharedManager.shared.sumPrice)!)
            let seecartTitle = "SEE CART      Total \(sumprice_temp) AED"
            seecartBtn.setTitle( seecartTitle, for: .normal)
            seecartBtn.isHidden = false
        }
    }
    
    @IBAction func plusBtnAction(_ sender: Any)
    {
        var currentQuantity = Int(foodQuantity.text!)
        currentQuantity = currentQuantity! + 1
        foodQuantity.text = String(currentQuantity!)
        sumPrice.text = "\(String((Int(eachFoodInfo.foodPrice)! * currentQuantity!))) AED"
        seecartCalculating()
        if currentQuantity != 0 {
            addcartBtn.isHidden = false
//            seecartBtn.isHidden = false

        }
    }
    @IBAction func minusBtnAction(_ sender: Any)
    {
        var currentQuantity = Int(foodQuantity.text!)
        if currentQuantity! >= 1 {
            currentQuantity = currentQuantity! - 1
        }
        foodQuantity.text = String(currentQuantity!)
        sumPrice.text = "\(String((Int(eachFoodInfo.foodPrice)! * currentQuantity!))) AED"
        seecartCalculating()
        if currentQuantity == 0 {
            addcartBtn.isHidden = true
//            seecartBtn.isHidden = true
        }
    }
    
    @IBAction func ToCartListAction(_ sender: Any)
    {
        var specialRequest_correct = ""
        if endEditing == true {
            specialRequest_correct = specialRequest.text
        }
        else {
            specialRequest_correct = ""
        }
        preparing_EachOrderedFood = EachOrderedFood(orderedIDOfFood: "\(Date().millisecondsSince1970)", OrderedFoodInfoOfFood: eachFoodInfo, orderedQuantityOfFood: foodQuantity.text!, orderedSpecialOfFood: specialRequest_correct, orderedSumOfFood: (sumPrice.text!).replacingOccurrences(of: " AED", with: ""))
        var count = 0
        var check_flag = false
        for item in SharedManager.shared.preparing_AllOrderedFood {
            if item.OrderedFoodInfoOfFood.foodID  == preparing_EachOrderedFood.OrderedFoodInfoOfFood.foodID {
                SharedManager.shared.preparing_AllOrderedFood[count].orderedQuantityOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[count].orderedQuantityOfFood)! + Int(preparing_EachOrderedFood.orderedQuantityOfFood)!)
                SharedManager.shared.preparing_AllOrderedFood[count].orderedSumOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[count].orderedSumOfFood)! + Int(preparing_EachOrderedFood.orderedSumOfFood)!)
                check_flag = true
            }
            count = count + 1
        }
        if check_flag == true {
            self.performSegue(withIdentifier: "AddCartToCartList", sender: self)
        }
        else {
            SharedManager.shared.preparing_AllOrderedFood.append(preparing_EachOrderedFood)
            self.performSegue(withIdentifier: "AddCartToCartList", sender: self)
        }
    }
    @IBAction func SeeCartListAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "AddCartToCartList", sender: self)
    }
}
extension EachFoodPage : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add more sauce!"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            endEditing = true
        }
    }
}
