//
//  UIPopup.swift
//  Anding
//
//  Created by 이청준 on 2022/10/11.
//

import UIKit

class UIPopup: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var Ptitle: UILabel!
    @IBOutlet weak var decTitle: UILabel!
    
    var Ptext: String?
    var PdecText: String?
    var Qtext: String?
    var QdecText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Ptitle.text = Ptext ??  "문답이 저장되었습니다."
        decTitle.text = PdecText ?? "문답을 모아서 자서전을 만들 수 있어요:)"
        
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        popupView.addGestureRecognizer(tapGestureRecognizer)
        
        popupView.cournerRound12()
    }
    
    @objc func closePopup(sender: UITapGestureRecognizer){
//        dismiss(animated: true, completion: nil)
        
        //창모두닫기
        closeAllwindow()
    }

    func closeAllwindow(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
           
            // 아래스택뷰모두닫기
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "viewController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }

      
    }
    
}
