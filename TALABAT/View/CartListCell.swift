//
//  CartListCell.swift
//  TALABAT
//
//  Created by Baby on 08.12.2020.
//
import UIKit

class CartListCell: UITableViewCell {


    @IBOutlet weak var EachCartContainer: UIView!
    @IBOutlet weak var EachCartImg: UIImageView!
    @IBOutlet weak var EachCartName: UILabel!
    @IBOutlet weak var EachCartSumPrice: UILabel!
    @IBOutlet weak var EachCartQuantity: UILabel!
    @IBOutlet weak var EachCartPlusBtn: UIButton!
    @IBOutlet weak var EachCartMinusBtn: UIButton!
    @IBOutlet weak var EachCartRemoveBtn: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}

