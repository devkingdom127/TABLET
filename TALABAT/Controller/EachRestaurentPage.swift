//
//  EachRestaurentPage.swift
//  TALABAT
//
//  Created by Baby on 07.12.2020.
//



import UIKit
import AVFoundation
import Cosmos
import SDWebImage
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class EachRestaurentPage : UIViewController {
    
    var lastContentOffset : CGFloat = 0
    var initialselected = false
    var lastSelected:Bool = false
    var lastSelectedIndexPath:IndexPath?
    var eachRestaurentInfo: EachRestaurent!
    var allFoods = [EachFood]()
    var selectedFoodInex : Int = 0
    var categoryofRestaurent = [String]()
    var AllfoodsOfRestaurent:[String:[EachFood]] = [String:[EachFood]]()
    var FoodsofselectedCategory = [EachFood]()
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView_food: UICollectionView!
    @IBOutlet weak var collectionView_category: UICollectionView!
    @IBOutlet weak var restaurentRating: CosmosView!
    @IBOutlet weak var restaurentImg: UIImageView!
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var restaurentName_City: UILabel!
    @IBOutlet weak var restaurentCategory: UILabel!
    @IBOutlet weak var restaurentStatus: UILabel!
    @IBOutlet weak var restaurentFee: UILabel!
    @IBOutlet weak var seecartBtn: UIButton!
    @IBOutlet weak var loadingView1: NVActivityIndicatorView!
    @IBOutlet weak var loadingView2: NVActivityIndicatorView!
    
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seecartBtn.applyGradient(colors: [Utils.shared.UIColorFromRGB(0x55C8FA).cgColor,Utils.shared.UIColorFromRGB(0x55C8FE).cgColor])
        loadingView2.startAnimating()
        
        customBackBtn()
        eachRestaurentInfo = SharedManager.shared.preparing_eachRestaurentInfo
        collectionView_food?.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        EachRestaurentInfo_Show()
        fetchCategory()
        loadingView2.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let seecartTitle = "SEE CART      Total \(SharedManager.shared.sumPrice ) AED"
        seecartBtn.setTitle( seecartTitle, for: .normal)
        if SharedManager.shared.sumPrice != "0"{
            seecartBtn.isHidden = false
        }
        else {
            seecartBtn.isHidden = true
        }
        
    }
    
    @IBAction func SeeCartListAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "EachRestaurentToCartList", sender: self)
    }
    
    func customBackBtn() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)
        let largeBoldDoc = UIImage(systemName: "chevron.backward", withConfiguration: largeConfig)
        button.addTarget(self, action: #selector(self.toRestaurentListPage(_:)), for: UIControl.Event.touchUpInside)
        button.setBackgroundImage(largeBoldDoc, for: UIControl.State.normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func toRestaurentListPage(_ sender: AnyObject) {
        if SharedManager.shared.addmore_flag == true {
            let refreshAlert = UIAlertController(title: "DO YOU WANT TO EXIT?", message: "Note that your order will be cancelled if you left this page without completing the order.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                SharedManager.shared.addmore_flag = false
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: RestaurentListViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                return
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func EachRestaurentInfo_Show(){
        
        loadingView1.startAnimating()
       
        print("\(eachRestaurentInfo.restaurentLogo)")
        if let url = URL(string: "http://sandwichmap-control.me/public/files/\((eachRestaurentInfo.restaurentLogo).replacingOccurrences(of: " ", with: "%20"))") {
//            SDImageCache.shared.removeImage(forKey: url.description, withCompletion: nil)
            self.restaurentImg.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { [self] (image, error, cacheType, imageURL) in
                if( error != nil) {
                print("Error while displaying image" , (error?.localizedDescription)! as String)
                }
                loadingView1.stopAnimating()
            })
        }
        else {
            let defaultImg: UIImage = UIImage(named: "noImg")!
            self.restaurentImg.image = defaultImg
            loadingView1.stopAnimating()

        }
        loadingView1.stopAnimating()
        restaurentName_City.text = "\((eachRestaurentInfo.restaurentName).uppercased()) - \(ConvertNumberAndCity(number: eachRestaurentInfo.restaurentCity))"
        restaurentCategory.text = ConvertNumberAndCategory(number: eachRestaurentInfo.restaurentCategoty)
        restaurentStatus.text = ConvertNumberAndStatus(number: eachRestaurentInfo.restaurentResStatus)
        restaurentFee.text = "DELIVERY FEES \(eachRestaurentInfo.restaurentFee) AED"
        SharedManager.shared.restaurentFee = eachRestaurentInfo.restaurentFee
        
//        restaurentImg.makeRounded()

        restaurentRating.rating = 4.7
        restaurentRating.settings.fillMode = .precise
        restaurentRating.settings.starSize = 15
//        feeView.layer.cornerRadius = 10
//        feeView.shadowEffect()
    }
    func ConvertNumberAndCity(number: String) -> String{
        var cityName : String!
        switch number {
        case "1":
            cityName = "Abu Dhabi"
        case "2":
            cityName = "Abu Dhabi"
        case "3":
            cityName = "Dubai"
        case "4":
            cityName = "Al ain"
        case "5":
            cityName = "Sharjah"
        case "6":
            cityName = "Ajman"
        case "7":
            cityName = "Ras Alkhaima"
        case "8":
            cityName = "Fujaira"
        default:
            cityName = "Um Alquwain"
        }
        return cityName
    }
    
    func ConvertNumberAndCategory(number: String) -> String{
        var categoryName : String!
        switch number {
        case "1":
            categoryName = "FAST FOOD"
        case "2":
            categoryName = "SWEETS"
        case "3":
            categoryName = "DISHES"
        default:
            categoryName = "FAST FOOD"
        }
        return categoryName
    }
    
    func ConvertNumberAndStatus(number: String) -> String{
        var statusName : String!
        switch number {
        case "1":
            statusName = "OPEN"
        case "2":
            statusName = "CLOSED"
        case "3":
            statusName = "BUSY"
        default:
            statusName = "OPEN"
        }
        return statusName
    }
}

extension EachRestaurentPage: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionView_category {
            return categoryofRestaurent.count
        }
        else {
            return FoodsofselectedCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView_category {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            if categoryofRestaurent[indexPath.item] == "AAAAAAAAAAAAAAAAA" {
                cell.whatisthis.text = "All"
               
            }
            else {
                cell.whatisthis.text = categoryofRestaurent[indexPath.item]
            }

            if initialselected == false {
                cell.whatisthis.textColor = .white

                cell.layer.cornerRadius = 10
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.lightGray.cgColor

                cell.layer.backgroundColor = UIColor.black.cgColor
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.masksToBounds = false
                initialselected = true
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodListCell", for: indexPath as IndexPath) as! FoodListCell
            cell.eachfood = FoodsofselectedCategory[indexPath.item]
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView_food {
            let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
            return CGSize(width: itemSize, height: itemSize + 50)
        }
        else {
            let itemSize = collectionView.frame.height
            if categoryofRestaurent[indexPath.row] == "AAAAAAAAAAAAAAAAA" {
                return CGSize(width: CGFloat(3) * 10 + 10  , height: itemSize - 10)
            }
            else {
                return CGSize(width: CGFloat(categoryofRestaurent[indexPath.item].count) * 10 + 10  , height: itemSize - 10)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView_category {
            FoodsofselectedCategory.removeAll()
            FoodsofselectedCategory = AllfoodsOfRestaurent[categoryofRestaurent[indexPath.item]]!
            
            if indexPath != [0, 0] {
                let selectedCell = collectionView.cellForItem(at: [0, 0]) as! CategoryCollectionViewCell
                selectedCell.whatisthis.textColor = .black

                selectedCell.layer.cornerRadius = 10
                selectedCell.layer.borderWidth = 1.0
                selectedCell.layer.borderColor = UIColor.lightGray.cgColor

                selectedCell.layer.backgroundColor = UIColor.white.cgColor
                selectedCell.layer.shadowColor = UIColor.gray.cgColor
                selectedCell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
                selectedCell.layer.shadowRadius = 2.0
                selectedCell.layer.shadowOpacity = 1.0
                selectedCell.layer.masksToBounds = false
            }

            collectionView_food.reloadData()
        }
        else {
            if eachRestaurentInfo.restaurentResStatus == "2" {
                Utils.shared.showAlertWith(title: "Sorry but you can't order now.", content: "This restaurent was closed.", viewController: self)
                return
            }
            if eachRestaurentInfo.restaurentResStatus == "3" {
                Utils.shared.showAlertWith(title: "Sorry but you can't order now.", content: "This restaurent is very busy.", viewController: self)
                return
            }
            selectedFoodInex = indexPath.row
            self.performSegue(withIdentifier: "FoodToDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodToDetail" {
            let controller = segue.destination as! EachFoodPage
            controller.eachFoodInfo = FoodsofselectedCategory[selectedFoodInex]
        }
    }
}

extension EachRestaurentPage {
    
    func fetchFoods() {
        allFoods.removeAll()
        AllfoodsOfRestaurent.removeAll()
        FoodsofselectedCategory.removeAll()
        var temp_AllfoodsOfRestaurent = [EachFood]()
        var temp_AllfoodsOfRestaurent1 = [EachFood]()
        // 1
        let request = AF.request("http://sandwichmap-control.me/public/api/get-product-api/\(eachRestaurentInfo.restaurentID)")
        request.responseJSON { [self] data in
            if let result = data.value {
                if let jsonArrays = JSON(result).arrayObject {
                    let foodsArr = jsonArrays as! [[String: Any]]
                    print("response data is \(foodsArr)")
                    for item in foodsArr {
                        let food = EachFood(dic: item)
                        self.allFoods.append(food)
                    }
                    self.allFoods.sort {
                        $0.foodName < $1.foodName
                    }
                }
            }
            for category in categoryofRestaurent {
                temp_AllfoodsOfRestaurent.removeAll()
                for food in allFoods {
                    if food.foodOfRestaurentCategory.contains(category) {
                        temp_AllfoodsOfRestaurent.append(food)
                        temp_AllfoodsOfRestaurent1.append(food)
                    }
                }
                AllfoodsOfRestaurent[category] = temp_AllfoodsOfRestaurent
            }
            AllfoodsOfRestaurent["AAAAAAAAAAAAAAAAA"] = temp_AllfoodsOfRestaurent1
            FoodsofselectedCategory = AllfoodsOfRestaurent["AAAAAAAAAAAAAAAAA"]!
            print(FoodsofselectedCategory)
            collectionView_food.reloadData()
        }

    }
    
    func fetchCategory() {
        initialselected = false
        categoryofRestaurent.removeAll()
        // 1
        print(eachRestaurentInfo.restaurentID)
        let request = AF.request("http://sandwichmap-control.me/public/api/get-restaurant-category/\(eachRestaurentInfo.restaurentID)")
        request.responseJSON { [self] data in
            if let result = data.value {
                if let jsonArrays = JSON(result).arrayObject {
                    let categoryArr = jsonArrays as! [String]
                    print("response data111111 is \(categoryArr)")
                    self.categoryofRestaurent = categoryArr
                    self.categoryofRestaurent.append("AAAAAAAAAAAAAAAAA")
                    print(self.categoryofRestaurent.count)
                    self.categoryofRestaurent.sort {
                        $0 < $1
                    }
                }
                collectionView_category.reloadData()
                fetchFoods()
            }
        }
    }
}


