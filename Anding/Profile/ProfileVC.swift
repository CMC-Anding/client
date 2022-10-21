//
//  ProfileVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/18.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let profileEditImg = UIImage(named: "profileEdit.svg")
    var nickNameSameCheck = true
    let nickNameCheckUrl = "https://dev.joeywrite.shop/app/users/check/nickname"
    let modifyUserProfileUrl = "https://dev.joeywrite.shop/app/users/profile"
    
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var nickNameSameCheckAlarmLbl: UILabel!
    
    @IBOutlet weak var introduceTxCount: UILabel!
    
    @IBOutlet weak var profileEdit: UIImageView!
    
    @IBOutlet weak var nickNameTxField: UITextField!
    
    @IBOutlet weak var introduceTxField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileEdit.image = profileEditImg
        
        nickNameTxField.delegate = self
        nickNameTxField.layer.cornerRadius = 6
        nickNameTxField.layer.borderWidth = 1
        nickNameTxField.layer.borderColor = UIColor.white.cgColor
        nickNameTxField.textColor = .white
        nickNameTxField.setLeftPadding(12)
        nickNameTxField.autocorrectionType = .no
        
        introduceTxField.delegate = self
        introduceTxField.layer.cornerRadius = 6
        introduceTxField.layer.borderWidth = 1
        introduceTxField.layer.borderColor = UIColor.white.cgColor
        introduceTxField.textColor = .white
        introduceTxField.setLeftPadding(12)
        introduceTxField.autocorrectionType = .no
        
        self.changeNickNameTextColor()
        
        nickNameSameCheckAlarmLbl.isHidden = true
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        guard let vc = self.presentingViewController as? MyVC else {
            return
        }
        vc.dismiss(animated: true)
    }
    
    
    
    @IBAction func nickNameTxEditingChanged(_ sender: UITextField) {
        
        nickNameSameCheckAlarmLbl.text = ""
        
        if (nickNameTxField.text!.count > 0) {
        nickNameSameCheck = validateNickName(validNickName: nickNameTxField.text!)
        }
        print(nickNameSameCheck)
        print(nickNameTxField.text!.count)
        
        if nickNameSameCheck == false {
            nickNameSameCheckAlarmLbl.text = "특수문자와 한글 자음, 모음은 사용될 수 없습니다."
            nickNameSameCheckAlarmLbl.isHidden = false
        } else {
            nickNameSameCheckAlarmLbl.isHidden = true
        }
        
        if nickNameTxField.text!.count > 12 {
            nickNameTxField.deleteBackward()
        }
        
    }

    @IBAction func nickNameSameCheckBtn(_ sender: Any) {
        
        if nickNameSameCheck == false {
            let alert = UIAlertController(title: "닉네임 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let nickName = nickNameTxField.text else { return }
        let params: Parameters = ["nickname" : nickName]
        
        AF.request(nickNameCheckUrl,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
            switch response.result {
                case .success(let obj):
                print(obj)
                
                do {
                // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
               
                let getData = try JSONDecoder().decode(SameIdNickName.self, from: dataJson)
                print(getData)
                    
                if getData.code == 1002 {
                    self.nickNameSameCheckAlarmLbl.text = "사용 가능한 닉네임 입니다."
                    self.nickNameSameCheckAlarmLbl.isHidden = false
                }

                if getData.code == 3016 {
                    self.nickNameSameCheckAlarmLbl.text = "이미 등록된 닉네임 입니다."
                    self.nickNameSameCheckAlarmLbl.isHidden = false
                }
                    
                print(getData.code)

                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            
                case .failure(let e):
                    // 통신 실패
                    print(e.localizedDescription)
            }
        }
        
        
    }
    
    
    @IBAction func introduceTxFieldEditingChanged(_ sender: UITextField) {
       
        introduceTxCount.text = String(introduceTxField.text!.count)
        
        if introduceTxField.text!.count > 30 {
            introduceTxField.deleteBackward()
        }
    }
    
    @IBAction func completion(_ sender: Any) {
        
        if nickNameTxField.text!.count > 0 && nickNameSameCheckAlarmLbl.isHidden == true {
            
            let alert = UIAlertController(title: "닉네임 중복 확인이 필요합니다.", message: .none, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        if nickNameSameCheck == false {
            let alert = UIAlertController(title: "닉네임 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        
        guard let nickName = nickNameTxField.text else { return }
        guard let introduction = introduceTxField.text else { return }
        let params: Parameters = ["nickname" : nickName, "introduction" : introduction]
        
        AF.request(modifyUserProfileUrl,
                   method: .patch,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
            switch response.result {
                case .success(let obj):
                print(obj)
                
                do {
                // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
               
                let getData = try JSONDecoder().decode(ModifyUserProfile.self, from: dataJson)
                print(getData)
                    
//                if getData.code == 1002 {
//                    self.nickNameSameCheckAlarmLbl.text = "사용 가능한 닉네임 입니다."
//                    self.nickNameSameCheckAlarmLbl.isHidden = false
//                }
//
//                if getData.code == 3016 {
//                    self.nickNameSameCheckAlarmLbl.text = "이미 등록된 닉네임 입니다."
//                    self.nickNameSameCheckAlarmLbl.isHidden = false
//                }
                    
                print(getData.code)

                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                
                
                let my = UIStoryboard(name: "MyVC", bundle: nil)
                guard let vc = my.instantiateViewController(withIdentifier: "MyVC")as? MyVC else {return}
                vc.modalPresentationStyle = .currentContext
                self.present(vc, animated: true, completion: nil)
            
            
                case .failure(let e):
                    // 통신 실패
                    print(e.localizedDescription)
            }
        }
        
        
   
    }
        
        
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let login = UIStoryboard(name: "LoginVC", bundle: nil)
        guard let vc = login.instantiateViewController(withIdentifier: "LoginVC")as? LoginVC else {return}

        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func changeNickNameTextColor() {
        
        guard let text = self.nickNameLbl.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
        self.nickNameLbl.attributedText = attributedString
    }
    
    func validateNickName(validNickName : String) -> Bool {
        
        let nickNameReg = "[a-zA-z0-9가-힣]{1,12}"
        let nickNameChanged = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        
        return nickNameChanged.evaluate(with: validNickName)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        introduceTxCount.text = String(textView.text!.count) //the textView parameter is the textView where text was
    }
}
