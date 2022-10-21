//
//  MyVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/18.
//

import UIKit

class MyVC: UIViewController {
    
    var introduceTxFromProfile = ""
    
    let profileImg = UIImage(named: "profile.svg")
    let profileLineImg = UIImage(named: "profileLine.svg")
    let contentLineImg = UIImage(named: "contentLine.svg")

    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var profileLine: UIImageView!
    @IBOutlet weak var contentLine: UIImageView!
    
    @IBOutlet weak var introduceTxView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile.image = profileImg
        profileLine.image = profileLineImg
        contentLine.image = contentLineImg
        
        introduceTxView.textContainer.maximumNumberOfLines = 2
        introduceTxView.text = introduceTxFromProfile
        
    }
    
    @IBAction func goToProfileSetting(_ sender: UIButton) {
        
        let profile = UIStoryboard(name: "ProfileVC", bundle: nil)
        guard let vc = profile.instantiateViewController(withIdentifier: "ProfileVC")as? ProfileVC else {return}

        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
}
