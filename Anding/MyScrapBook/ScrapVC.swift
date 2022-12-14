//
//  ScrapVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import Foundation
import UIKit

class ScrapVC :UIViewController{
    
    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var editBtn: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var delBtn: UIImageView!
    var myNickName = ""
    
    @IBAction func delBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
        //닉네임불러오기
        print("내가스크랩한곳 내닉넴 ",myNickName)
        
        titleText.text = "나의 스크랩북"
        
        //닫기
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(btnAlltag(tapGestureRecognizer:)))
        closeBtn.addGestureRecognizer(tapImageViewRecognizer)
        closeBtn.isUserInteractionEnabled = true

        //기본세팅
        self.titleText.text = "나의 스크랩북"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
    }
    
    
    @objc func editBtnAction(tapGestureRecognizer: UITapGestureRecognizer){
          // 수정버튼
            self.titleText.text = "삭제할 기록을 선택해주세요"
            self.editBtn.isHidden = true
            self.delBtn.isHidden = false
    }
    
    
    @objc func btnAlltag(tapGestureRecognizer: UITapGestureRecognizer){
          // 닫기 버튼
         dismiss(animated: true, completion: nil)
      }
 

    
}
