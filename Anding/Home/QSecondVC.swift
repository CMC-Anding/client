//
//  QSecondVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/09.
//

import Foundation
import UIKit

class QSecondVC :UIViewController{
    
    var topic = Topic()
    @IBOutlet weak var topicTitle: UITextView!
    @IBOutlet weak var nextBtn: UIStackView!

    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        topicTitle.text = topic.Topic1[1]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
//        let vc = UIStoryboard(name:"QThirdVC" , bundle: nil).instantiateViewController(withIdentifier: "QThirdVC") as! QThirdVC
//
//            self.present(vc, animated: true){ }
    }
    
    
}

