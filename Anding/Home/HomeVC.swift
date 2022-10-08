//
//  HomeVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import Foundation
import UIKit

class HomeVC :UIViewController{
    

    var topic = Topic()
    
    @IBOutlet weak var qtitle: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var qImg: UIImageView!
    @IBOutlet weak var qBtnToggle: UIImageView!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var togleView: UIView! //문답일상버튼
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"HomeCollectionViewCell")
        
        UISetting()
        
        //selectsheet
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleAction))
        togleView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //selectsheet
    @objc func toggleAction(sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            //블로그 방문하기 버튼 - 스타일(default)
            actionSheet.addAction(UIAlertAction(title: "문답", style: .default, handler: {(ACTION:UIAlertAction) in
                print("문답선택")
            }))
            
            //이웃 끊기 버튼 - 스타일(destructive)
            actionSheet.addAction(UIAlertAction(title: "일상", style: .destructive, handler: {(ACTION:UIAlertAction) in
                print("일상선택")
            }))
            
            //취소 버튼 - 스타일(cancel)
            actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)

    }
    
    
    
    func UISetting(){
        // 컬렉션뷰
        collectionView.backgroundColor = UIColor(argb:0x3E4048)
        //버튼라운드
        btnWrite.layer.cornerRadius = 12
    }
    
    
    

    @IBAction func btnWriteAction(_ sender: Any) {
        let vc = UIStoryboard(name:"QfirstVC" , bundle: nil).instantiateViewController(withIdentifier: "QfirstVC") as! QfirstVC

            self.present(vc, animated: true){ }
                        
           //선택한 행의 내용을 feedResult에 담는다.
  //         detailVC.feedResult = self.feedModel?.results[indexPath.row]

  //          vc.modalPresentationStyle = .fullScreen
            // 화면이 띄워진후에 값을 넣어야 널크러쉬가 안남
    }
    
}


// MARK: - extension
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic.TopicTitle.count
    }
    
    
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 다음 화면 뷰컨트롤러의 인스턴스 생성 (StoryBoardID를 이용하여 참조)
      
   
}

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell

        cell.label.text = topic.TopicTitle[indexPath.row]
            return cell
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {

        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    convenience init(rgb: Int) {
           self.init(
               red: (rgb >> 16) & 0xFF,
               green: (rgb >> 8) & 0xFF,
               blue: rgb & 0xFF
           )
       }

    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
