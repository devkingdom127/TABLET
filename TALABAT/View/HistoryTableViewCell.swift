//
//  HistoryTableViewCell.swift
//  TALABAT
//
//  Created by Baby on 21.12.2020.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurentImg: UIImageView!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurentImg.layer.borderWidth = 1
        restaurentImg.layer.borderColor = UIColor.black.cgColor
        restaurentImg.layer.cornerRadius = restaurentImg.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
