//
//  QfirstVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//

import Foundation
import UIKit

class QfirstVC :UIViewController{
    
    var topic = Topic()
    
    @IBOutlet weak var bgColorBtn: UIStackView!
    @IBOutlet weak var topicTitle: UITextView!
    @IBOutlet weak var nextBtn: UIStackView!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)//뷰컨닫기
    }
    
    // 컬러피커
    @IBAction func bgColorAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        topicTitle.text = topic.Topic1[0]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"QSecondVC" , bundle: nil).instantiateViewController(withIdentifier: "QSecondVC") as! QSecondVC

            self.present(vc, animated: true){ }
    }
    
    

   
}

