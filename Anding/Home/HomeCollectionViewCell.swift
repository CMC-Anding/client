//
//  HomeCollectionViewCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    static let identifier = "HomeCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }
    
       func setupLayout() {
//           layer.shadowColor = UIColor.black.cgColor
   //        layer.shadowOpacity = 0.5
   //        layer.shadowRadius = 10
           bgView?.layer.cornerRadius = 10
           bgView?.layer.masksToBounds = true
       }

}
