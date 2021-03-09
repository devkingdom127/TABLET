/**
* Copyright (c) 2019 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
* distribute, sublicense, create a derivative work, and/or sell copies of the
* Software in any work that is designed, intended, or marketed for pedagogical or
* instructional purposes related to programming, coding, application development,
* or information technology.  Permission for such use, copying, modification,
* merger, publication, distribution, sublicensing, creation of derivative works,
* or sale is expressly withheld.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import AVFoundation
import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView


class RestaurentListViewController : UIViewController {
    
    var allRestaurents = [EachRestaurent]()
    var cityRestaurents = [EachRestaurent]()
    var selectedRestaurents_show1 = [EachRestaurent]()
    var selectedRestaurents_show2 = [EachRestaurent]()
    var selectedRestaurents_show3 = [EachRestaurent]()
    var selectedRestaurents = [EachRestaurent]()
    var selectedRestaurentInex : Int = 0
    var lastContentOffset : CGFloat = 0

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var DishsBtn: UIButton!
    @IBOutlet weak var FastFoodBtn: UIButton!
    @IBOutlet weak var DesertBtn: UIButton!
    @IBOutlet weak var fastfoodImg: UIImageView!
    @IBOutlet weak var dessertImg: UIImageView!
    @IBOutlet weak var dishImg: UIImageView!
    @IBOutlet weak var loadingView1: NVActivityIndicatorView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBackBtn()
        collectionView?.contentInset = UIEdgeInsets(top: 6, left: 15, bottom: 0, right: 15)
        self.loadingView1.startAnimating()
        fetchRestaurents()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        SharedManager.shared.wrongCount = 0
        SharedManager.shared.sumPrice = "0"
        SharedManager.shared.preparing_AllOrderedFood = [EachOrderedFood]()
        print("\(SharedManager.shared.cityInfo!)")
        
    }
    
    func customBackBtn() {
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .small)
        let largeBoldDoc = UIImage(systemName: "chevron.backward", withConfiguration: largeConfig)
        button.addTarget(self, action: #selector(self.toCitiesPage(_:)), for: UIControl.Event.touchUpInside)
        button.setBackgroundImage(largeBoldDoc, for: UIControl.State.normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc func toCitiesPage(_ sender: AnyObject) {
        
        lastContentOffset = 0
        topConstraint.constant = 0
        if SharedManager.shared.citymenu_flag > 1 {
            SharedManager.shared.citymenu_flag = 1
            self.collectionView?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
            topConstraint.constant = 0
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("iPad")
                lastContentOffset = 180
            }
            else{
                print("not iPad")
                lastContentOffset = 120
            }
            initStatus()
            return
        }
        else {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CitiesPage.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    @IBAction func HomeAction(_ sender: Any)
    {
        self.collectionView?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
        topConstraint.constant = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("iPad")
            lastContentOffset = 180
        }
        else{
            print("not iPad")
            lastContentOffset = 120
        }
        if SharedManager.shared.citymenu_flag != 1 {
            SharedManager.shared.citymenu_flag = 1
            initStatus()
        }
        
    }
    
    @IBAction func FastFoodAction(_ sender: Any)
    {
        if SharedManager.shared.citymenu_flag != 2 {
            SharedManager.shared.citymenu_flag = 2
            self.collectionView?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
            topConstraint.constant = 0
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("iPad")
                lastContentOffset = 180
            }
            else{
                print("not iPad")
                lastContentOffset = 120
            }
            selectedRestaurents = selectedRestaurents_show1
            self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func DessertAction(_ sender: Any)
    {
        if SharedManager.shared.citymenu_flag != 3 {
            SharedManager.shared.citymenu_flag = 3
            self.collectionView?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
            topConstraint.constant = 0
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("iPad")
                lastContentOffset = 180
            }
            else{
                print("not iPad")
                lastContentOffset = 120
            }
            selectedRestaurents = selectedRestaurents_show2
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func DishesAction(_ sender: Any)
    {
        if SharedManager.shared.citymenu_flag != 4 {
            SharedManager.shared.citymenu_flag = 4
            self.collectionView?.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
            topConstraint.constant = 0
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("iPad")
                lastContentOffset = 180
            }
            else{
                print("not iPad")
                lastContentOffset = 120
            }
            selectedRestaurents = selectedRestaurents_show3
            self.collectionView.reloadData()
        }
    }
    
    func CityBtnPressed() {
       
        selectedRestaurents.removeAll()
        cityRestaurents.removeAll()
        selectedRestaurents_show1.removeAll()
        selectedRestaurents_show2.removeAll()
        selectedRestaurents_show3.removeAll()
        
        for restaurent in allRestaurents {
            if restaurent.restaurentCity.contains(SharedManager.shared.cityInfo!) {
                if restaurent.restaurentStatus.contains("1") {
                    if restaurent.restaurentCategoty.contains("1") {
                        selectedRestaurents_show1.append(restaurent)
                    }
                    if restaurent.restaurentCategoty.contains("2") {
                        selectedRestaurents_show2.append(restaurent)
                    }
                    if restaurent.restaurentCategoty.contains("3") {
                        selectedRestaurents_show3.append(restaurent)
                    }
                }
                cityRestaurents.append(restaurent)
            }
        }
        initStatus()
        SharedManager.shared.citymenu_flag = 1
    }
    func initStatus(){
        selectedRestaurents = cityRestaurents
        self.collectionView.reloadData()
    }
    @IBAction func ToSearchAction(_ sender: Any)
    {
        SharedManager.shared.allRestaurents_share = self.allRestaurents
        SharedManager.shared.cityRestaurents_share = self.cityRestaurents
        SharedManager.shared.selectedRestaurents_show1_share = self.selectedRestaurents_show1
        SharedManager.shared.selectedRestaurents_show2_share = self.selectedRestaurents_show2
        SharedManager.shared.selectedRestaurents_show3_share = self.selectedRestaurents_show3
        
        self.performSegue(withIdentifier: "MenuToSearch", sender: self)

    }
}

extension RestaurentListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedRestaurents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurentListCell", for: indexPath as IndexPath) as! RestaurentListCell
        cell.eachrestaurent = selectedRestaurents[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 30)) / 3
        return CGSize(width: itemSize, height: itemSize + 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedRestaurentInex = indexPath.row
        self.performSegue(withIdentifier: "MenuToDetail", sender: self)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuToDetail" {
            SharedManager.shared.preparing_eachRestaurentInfo = selectedRestaurents[selectedRestaurentInex]
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

extension RestaurentListViewController {
    
    func fetchRestaurents() {
        allRestaurents.removeAll()
        let request = AF.request("http://sandwichmap-control.me/public/api/get-restaurant-api/")
        request.responseJSON { [self] data in
            if let result = data.value {
                if let jsonArrays = JSON(result).arrayObject {
                    let restaurantsArr = jsonArrays as! [[String: Any]]
                    var count = 0
                    for item in restaurantsArr {
                        count = count + 1
                        let restaurant = EachRestaurent(dic: item)
                        print(restaurant.restaurentID)
                        
                        self.allRestaurents.append(restaurant)
                        if count == restaurantsArr.count {
                            self.allRestaurents.sort {
                                if $0.restaurentRank != $1.restaurentRank { // first, compare by last names
                                    return Int($0.restaurentRank)! < Int($1.restaurentRank)!
                                }
                                 else { // All other fields are tied, break ties by last name
                                    return $0.restaurentName < $1.restaurentName
                                }
                            }
                            CityBtnPressed()
                        }
                    }
                    self.loadingView1.stopAnimating()
                }
            }
        }
    }
}
extension RestaurentListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if SharedManager.shared.citymenu_flag == 1 {
            let delta = scrollView.contentOffset.y - lastContentOffset
                var minimumConstantValue : CGFloat = 0
                if UIDevice.current.userInterfaceIdiom == .pad {
                    print("iPad")
                    minimumConstantValue = CGFloat(-180)
                }
                else{
                    print("not iPad")
                    minimumConstantValue = CGFloat(-120)
                }
                if delta < 0 {
                    topConstraint.constant = min(topConstraint.constant - delta, 0)
                }
                else {
                    topConstraint.constant = max(minimumConstantValue, topConstraint.constant - delta)
                }
                print(lastContentOffset)
            
        }

  }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if SharedManager.shared.citymenu_flag == 1 {
            lastContentOffset = scrollView.contentOffset.y
        }
    }
}
