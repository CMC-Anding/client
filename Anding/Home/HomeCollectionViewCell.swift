//
//  HomeCollectionViewCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//
import Foundation
import UIKit

protocol HomeCellDelegate{
    func selectBtn(Index:Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    var topic = Topic()

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var index : Int = 0
    var delegate : HomeCellDelegate?
    var isTag = false
    
    static let identifier = "HomeCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
    
                             
    override var isSelected: Bool{
           didSet {
                   if isSelected {
                       imgView.image = topic.TopicImageOn[index]
                   } else {
                        imgView.image = topic.TopicImageOff[index]
                   }
               }
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
        
        //셀클릭이벤트
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
        //마무리태그 눌러져있게하기
//        isTag = true
//        imgView.image = topic.TopicImageOn[0]
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
     // 원하는 대로 코드 구성
        self.delegate?.selectBtn(Index: index)
    }

    
       func setupLayout() {
//           layer.shadowColor = UIColor.black.cgColor
   //        layer.shadowOpacity = 0.5
   //        layer.shadowRadius = 10
           bgView?.layer.cornerRadius = 10
           bgView?.layer.masksToBounds = true
       }

}

//상태변경
//    override var isSelected: Bool {
//            didSet{
//                if isSelected {
//
//                    label.textColor = .white
//                    bgView?.layer.backgroundColor = UIColor(displayP3Red: 98/255, green: 152/255, blue: 255/255, alpha: 1).cgColor
//                }
//                else {
////                    seperateLine.backgroundColor = .clear
//                    label.textColor = .black
//                    bgView?.layer.backgroundColor = UIColor(displayP3Red: 116/255, green: 117/255, blue: 123/255, alpha: 1).cgColor
//                }
//            }
//        }
