//
//  CartListPage.swift
//  TALABAT
//
//  Created by Baby on 08.12.2020.
//

import UIKit
import AVFoundation
import SDWebImage

class CartListPage : UIViewController, UITableViewDelegate, UITableViewDataSource {
    


    var temp_totalPrice : Int = 0
    
    @IBOutlet weak var CartListTable: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var addmoreBtn: UIButton!
    @IBOutlet weak var FeeView: UIView!
    @IBOutlet weak var backBtn: UIBarButtonItem!

    override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeeView.shadowEffect()
        self.orderBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x17A421).cgColor,Utils.shared.UIColorFromRGB(0x1ED729).cgColor])
        self.addmoreBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x55C8FA).cgColor,Utils.shared.UIColorFromRGB(0x55C8FE).cgColor])
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("iPad")
            CartListTable.rowHeight = 160
        }
        else{
            print("not iPad")
            CartListTable.rowHeight = 100
        }
        SharedManager.shared.preparing_AllOrderedFood.sort {
            $0.orderedIDOfFood < $1.orderedIDOfFood
        }
        for item in SharedManager.shared.preparing_AllOrderedFood {
            temp_totalPrice = temp_totalPrice + Int(item.orderedSumOfFood)!
        }
        totalPrice.text = "\(temp_totalPrice) AED"
        fees.text = "FEES - \(SharedManager.shared.restaurentFee!) AED"
        self.animateTable()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (totalPrice.text)!.replacingOccurrences(of: " AED", with: "") != "0" {
            let feesumPrice = Int((totalPrice.text)!.replacingOccurrences(of: " AED", with: ""))! + Int(SharedManager.shared.restaurentFee)!
            SharedManager.shared.sumPrice = String(feesumPrice)
        }
        else {
            SharedManager.shared.sumPrice = "0"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        SharedManager.shared.addmore_flag = true
        CartListTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
        
    @IBAction func ToAddressPickerAction(_ sender: Any)
    {
        SharedManager.shared.addmore_flag = false
        let allsumprice = Int((totalPrice.text)!.replacingOccurrences(of: " AED", with: ""))
        let fees = Int(SharedManager.shared.restaurentFee)
        if allsumprice == 0 {
            Utils.shared.showAlertWith(title: "Your order was not completed!", content: "Sorry but please retry again.", viewController: self)
            return
        }
        SharedManager.shared.totalPriceFinal = String(allsumprice ?? 0 + fees! )
        self.performSegue(withIdentifier: "CartListToAddress", sender: self)
    }
    
    @IBAction func AddMoreAction(_ sender: Any)
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: EachRestaurentPage.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func plusBtnAction(sender:UIButton, event: Any)
    {
        let buttonRow = sender.tag
        let indexPath = IndexPath(item: buttonRow, section: 0)
        SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood)! + 1)
        
        SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedSumOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodPrice)! * Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood)!)
        temp_totalPrice = temp_totalPrice + Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodPrice)!
        totalPrice.text = "\(temp_totalPrice) AED"
        CartListTable.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func minusBtnAction(sender:UIButton, event: Any)
    {
        let buttonRow = sender.tag
        let indexPath = IndexPath(item: buttonRow, section: 0)
        if SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood != "0"  {
            SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood)! - 1)
            
            SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedSumOfFood = String(Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodPrice)! * Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood)!)
            temp_totalPrice = temp_totalPrice - Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodPrice)!
            totalPrice.text = "\(temp_totalPrice) AED"
            
            if SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood == "0" {
                SharedManager.shared.preparing_AllOrderedFood.remove(at: indexPath.item)
                CartListTable.reloadData()            }
            else {
                CartListTable.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    @objc func removeBtnAction(sender:UIButton, event: Any)
    {
        let buttonRow = sender.tag
        let indexPath = IndexPath(item: buttonRow, section: 0)
        temp_totalPrice = temp_totalPrice - Int(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedSumOfFood)!
        totalPrice.text = "\(temp_totalPrice) AED"
        SharedManager.shared.preparing_AllOrderedFood.remove(at: indexPath.item)
                CartListTable.reloadData()
        
    }

    func animateTable() {
        CartListTable.reloadData()
        let cells = CartListTable.visibleCells
        let tableHeight: CGFloat = CartListTable.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 2.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedManager.shared.preparing_AllOrderedFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartListCell
        if let url =  URL(string:"http://sandwichmap-control.me/public/files/\((SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodImg).replacingOccurrences(of: " ", with: "%20"))") {
//            SDImageCache.shared.removeImage(forKey: url.description, withCompletion: nil)
            cell.EachCartImg.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if( error != nil) {
                print("Error while displaying image" , (error?.localizedDescription)! as String)
                }
            })
        }
        else {
            let defaultImg: UIImage = UIImage(named: "noImg")!
            cell.EachCartImg.image = defaultImg
        }
        cell.EachCartName.text = SharedManager.shared.preparing_AllOrderedFood[indexPath.item].OrderedFoodInfoOfFood.foodName
        cell.EachCartQuantity.text = SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedQuantityOfFood
        cell.EachCartSumPrice.text = "\(SharedManager.shared.preparing_AllOrderedFood[indexPath.item].orderedSumOfFood) AED"
        cell.EachCartPlusBtn.tag = indexPath.row
        cell.EachCartMinusBtn.tag = indexPath.row
        cell.EachCartRemoveBtn.tag = indexPath.row

        cell.EachCartPlusBtn.addTarget(self, action: #selector(plusBtnAction(sender:event:)), for: .touchUpInside)
        cell.EachCartMinusBtn.addTarget(self, action: #selector(minusBtnAction(sender:event:)), for: .touchUpInside)
        cell.EachCartRemoveBtn.addTarget(self, action: #selector(removeBtnAction(sender:event:)), for: .touchUpInside)

        cell.EachCartImg.makeRounded()
        CartListTable.separatorColor = UIColor.brown
        return cell
    }
}

