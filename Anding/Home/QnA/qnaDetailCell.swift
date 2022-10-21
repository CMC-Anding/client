//
//  qnaDetailCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/10.
//

import UIKit

class qnaDetailCell: UITableViewCell {
    

    @IBOutlet weak var tagText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tagImg: UIImageView!
    @IBOutlet weak var QImgThumb: UIImageView!
    
    static let identifier = "qnaDetailCell"
    static func nib()-> UINib{
          return UINib(nibName: "qnaDetailCell", bundle: nil)
      }
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
