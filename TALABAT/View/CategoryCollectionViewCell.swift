//
//  CategoryCollectionViewCell.swift
//  TALABAT
//
//  Created by Baby on 14.12.2020.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var whatisthis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.whatisthis.textColor = .black
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor

        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false

    }
    
    override var isSelected: Bool{
        willSet {
            super.isSelected = newValue
            if newValue {
                
                self.whatisthis.textColor = .white
                
                self.layer.cornerRadius = 10
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.lightGray.cgColor

                self.layer.backgroundColor = UIColor.black.cgColor
                self.layer.shadowColor = UIColor.gray.cgColor
                self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
                self.layer.shadowRadius = 2.0
                self.layer.shadowOpacity = 1.0
                self.layer.masksToBounds = false
            
            }
            else {
                
                self.whatisthis.textColor = .black
                
                self.layer.cornerRadius = 10
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.lightGray.cgColor

                self.layer.backgroundColor = UIColor.white.cgColor
                self.layer.shadowColor = UIColor.gray.cgColor
                self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
                self.layer.shadowRadius = 2.0
                self.layer.shadowOpacity = 1.0
                self.layer.masksToBounds = false
                
            }
 
        }
    }
}

