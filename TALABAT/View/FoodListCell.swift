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
import SDWebImage

class FoodListCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var orderView: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()

//    containerView.shadowEffect()
    containerView.layer.cornerRadius = 0
    containerView.layer.borderWidth = 1.5
    containerView.layer.borderColor = UIColor.black.cgColor

//        self.layer.backgroundColor = UIColor.white.cgColor
//    containerView.layer.shadowColor = UIColor.gray.cgColor
//    containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//    containerView.layer.shadowRadius = 2.0
//    containerView.layer.shadowOpacity = 1.0
//    containerView.layer.masksToBounds = false
//    orderView.layer.cornerRadius = 12

  }
  
  var eachfood: EachFood? {
    
    didSet {
        if let eachfood = eachfood {
            print(eachfood.foodImg)
            if let url = URL(string: baseFileURL + "\(eachfood.foodImg)") {
//                SDImageCache.shared.removeImage(forKey: url.description, withCompletion: nil)
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "noImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    if( error != nil) {
                    print("Error while displaying image" , (error?.localizedDescription)! as String)
                    }
                })
            }
            else {
                let defaultImg: UIImage = UIImage(named: "noImg")!
                self.imageView.image = defaultImg
            }

            captionLabel.text = (eachfood.foodName).uppercased()
            descriptionLabel.text = eachfood.foodDescription
            commentLabel.text = "\(eachfood.foodPrice) AED".uppercased()
        }
    }
    
  }
}
