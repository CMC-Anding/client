
//
//  SignUp2VC.swift
//  Anding
//
//  Created by woonKim on 2022/10/11.
//

import UIKit
import Alamofire
import SafariServices

class SignUp2VC: UIViewController, UITextFieldDelegate {

    let nickNameCheckUrl = "https://dev.joeywrite.shop/app/users/check/nickname"
    let phoneNumberCheckUrl = "https://dev.joeywrite.shop/app/users/authentication"
    let signUpUrl = "https://dev.joeywrite.shop/app/users/join"
    
    var idFromSignUp1 = ""
    var pwFromSignUp1 = ""
    var authenticationNumberFromServer = ""
    var nickNameCheck = true
    var phoneNumberCheck = true
    var appPolicyAgreeCheck = false

//    var seconds = 70
//    var timer = Timer()
//    var isTimerRunning = false

    @IBOutlet weak var allArea: UIView!
    @IBOutlet weak var allCheck: UIImageView!
    
    private let checkOn = UIImage(named:"signup_check_on")
    private let checkOff = UIImage(named:"signup_check_off")
    private let allcheckOn = UIImage(named:"AppPolicyCheck")
    private let allcheckOff = UIImage(named:"AppPolicyUncheck")
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var checkArea1: UIView!
    @IBOutlet weak var pText: UILabel!
    @IBOutlet weak var checkImg2: UIImageView!
    @IBOutlet weak var checkArea2: UIView!
    @IBOutlet weak var provisionText: UILabel!
    
    @IBAction func pWebpageBtn(_ sender: Any) {
        // 링크웹에서 보여주기
        // 개인정보처리방침
        let blogUrl = NSURL(string: "https://makeus-challenge.notion.site/1ece6a04fc464acb8b49a10ce025a1e4")
        let blogSafariView: SFSafariViewController = SFSafariViewController(url: blogUrl! as URL)
        self.present(blogSafariView, animated: true, completion: nil)
    }
    @IBAction func pWebpageBtn2(_ sender: Any) {
        // 약관
        let blogUrl = NSURL(string: "https://makeus-challenge.notion.site/d8e60a5822084f1c805b0daa969fc8d0")
        let blogSafariView: SFSafariViewController = SFSafariViewController(url: blogUrl! as URL)
        self.present(blogSafariView, animated: true, completion: nil)
    }
    
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var nickNameCheckLbl: UILabel!
    @IBOutlet weak var validationCodeTimerLbl: UILabel!
    @IBOutlet weak var incorrectNumberLbl: UILabel!
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.delegate = self
        phoneNumber.delegate = self
        verificationCode.delegate = self

        nickName.layer.cornerRadius = 6
        nickName.layer.borderWidth = 1
        nickName.layer.borderColor = UIColor.white.cgColor
        nickName.textColor = .white
        nickName.setLeftPadding(12)
        nickName.autocorrectionType = .no
        
        phoneNumber.layer.cornerRadius = 6
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.white.cgColor
        phoneNumber.textColor = .white
        phoneNumber.setLeftPadding(12)
        
        verificationCode.layer.cornerRadius = 6
        verificationCode.layer.borderWidth = 1
        verificationCode.layer.borderColor = UIColor.white.cgColor
        verificationCode.textColor = .white
        verificationCode.setLeftPadding(12)
        
        
        nickNameCheckLbl.isHidden = true
        validationCodeTimerLbl.isHidden = true
        incorrectNumberLbl.isHidden = true
        
        changeNickNameTextColor()

        
        print(idFromSignUp1)
        print(pwFromSignUp1)
        
        // 체크버튼기본세팅
        self.checkImg.image = UIImage(named:"signup_check_off")
        self.checkImg2.image = UIImage(named:"signup_check_off")
        self.allCheck.image = UIImage(named:"AppPolicyUncheck")

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        checkArea1.addGestureRecognizer(tapGestureRecognizer)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkAction2))
        checkArea2.addGestureRecognizer(tapGesture)
        
        let Allcheck = UITapGestureRecognizer(target: self, action: #selector(Allcheck))
        allArea.addGestureRecognizer(Allcheck)
    }
    
    
    @objc func Allcheck(sender: UITapGestureRecognizer) {
            if self.allCheck.image === self.allcheckOff{
                self.allCheck.image = UIImage(named: "AppPolicyCheck")
                self.checkImg2.image = UIImage(named:"signup_check_on")
                self.checkImg.image = UIImage(named:"signup_check_on")
            }else{
                self.allCheck.image = UIImage(named: "AppPolicyUncheck")
                self.checkImg2.image = UIImage(named:"signup_check_off")
                self.checkImg.image = UIImage(named:"signup_check_off")
            }
    }
    
    
    @objc func checkAction2(sender: UITapGestureRecognizer) {
            if self.checkImg2.image === self.checkOff {
                self.checkImg2.image = UIImage(named:"signup_check_on")
            }else{
                self.checkImg2.image = UIImage(named:"signup_check_off")
            }
    }
    
    @objc func checkAction(sender: UITapGestureRecognizer) {
            if self.checkImg.image === self.checkOff {
                self.checkImg.image = UIImage(named:"signup_check_on")
            }else{
                self.checkImg.image = UIImage(named:"signup_check_off")
            }
    }
    
    @IBAction func escBtn(_ sender: UIButton) {
        
        guard let vc = self.presentingViewController as? SignUp1VC else {
            return
        }
        vc.dismiss(animated: true)
    }
    
    @IBAction func nickNameCheckBtn(_ sender: UIButton) {
        guard let nickName = nickName.text else { return }
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
                    self.nickNameCheckLbl.text = "사용 가능한 닉네임 입니다."
                    self.nickNameCheckLbl.isHidden = false
                }
                    
                if getData.code == 3016 {
                    self.nickNameCheckLbl.text = "이미 등록된 닉네임 입니다."
                    self.nickNameCheckLbl.isHidden = false
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
    
    @IBAction func authenticationNumberBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "문자 인증", message: "인증번호를 전송했습니다.", preferredStyle: .alert)
              let alertAction = UIAlertAction(title: "확인", style: .default) { [self] (_) in


              }
              alert.addAction(alertAction)
              self.present(alert, animated: true, completion: nil)
        
//        validationCodeTimerLbl.isHidden = false
//        seconds = 70
//        runTimer()
        
        guard let inputPhoneNumber = phoneNumber.text else { return }
        let params: Parameters = ["phone" : inputPhoneNumber]
        
        AF.request(phoneNumberCheckUrl,
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
                   
                    let getData = try JSONDecoder().decode(UserData.self, from: dataJson)
                    print(getData)
                        
                    guard let authenticationNum = getData.result.authenticationNumber
                        else { return }
                        
                    self.authenticationNumberFromServer = authenticationNum

                    print(self.authenticationNumberFromServer)
                        
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
                print(e.localizedDescription)
            }
        }
    }
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
        
//        let signUp3 = UIStoryboard(name: "SignUp3VC", bundle: nil)
//        guard let vc = signUp3.instantiateViewController(withIdentifier: "SignUp3VC")as? SignUp3VC else {return}

//        vc.modalPresentationStyle = .currentContext
//        self.present(vc, animated: true, completion: nil)
        
        if nickNameCheck == false {
            
            let alert = UIAlertController(title: "닉네임 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if nickNameCheckLbl.text! == "이미 등록된 닉네임 입니다." {
            
            let alert = UIAlertController(title: "이미 등록된 닉네임 입니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
            
        }
        
//        if validationCodeTimerLbl.text! == "인증번호 유효시간 초과" {
//            let alert = UIAlertController(title: "인증번호 유효시간 초과", message: .none, preferredStyle: .alert)
//
//            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
//            alert.addAction(ok)
//
//            present(alert, animated: true, completion: nil)
//            return
//        }
        
        if nickNameCheckLbl.text! != "사용 가능한 닉네임 입니다." {
            
            let alert = UIAlertController(title: "닉네임 중복 확인이 필요합니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if self.checkImg2.image === self.checkOff || self.checkImg.image === self.checkOff {
            
            let alert = UIAlertController(title: "회원가입시 약관 동의는 필수입니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if incorrectNumberLbl.isHidden == false {

            let alert = UIAlertController(title: "인증번호가 일치하지 않습니다.", message: .none, preferredStyle: .alert)

            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        if verificationCode.text!.count < 6 {
            
            let alert = UIAlertController(title: "인증번호를 입력 해주세요.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if phoneNumberCheck == false {
            
            let alert = UIAlertController(title: "휴대폰 번호 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if nickNameCheck == true && phoneNumberCheck == true && nickNameCheckLbl.text! == "사용 가능한 닉네임 입니다." && incorrectNumberLbl.isHidden == true && verificationCode.text!.count > 0 {
        
        guard let nickName = nickName.text else { return }
        guard let phone = phoneNumber.text else { return }
        let params: Parameters = ["nickname" : nickName, "password" : pwFromSignUp1, "phone" : phone, "userId" : idFromSignUp1]

        AF.request(signUpUrl,
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
               
                let getData = try JSONDecoder().decode(SignUp.self, from: dataJson)
                
                print(getData)
                    
                if getData.code == 1000 {

                    let signUp3 = UIStoryboard(name: "SignUp3VC", bundle: nil)
                    guard let vc = signUp3.instantiateViewController(withIdentifier: "SignUp3VC")as? SignUp3VC else {return}

                    vc.modalPresentationStyle = .currentContext
                    self.present(vc, animated: true, completion: nil)
                }
                
                if getData.code == 2000 {
                    
                    let alert = UIAlertController(title: "회원가입에 실패했습니다.", message: .none, preferredStyle: .alert)
                
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                        
                    self.present(alert, animated: true, completion: nil)
                }
                    
                if getData.code == 3018 {
                    
                    let alert = UIAlertController(title: "이미 가입된 전화번호입니다.", message: .none, preferredStyle: .alert)
                
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                        
                    self.present(alert, animated: true, completion: nil)
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
    }
    
    @IBAction func nickNameChanged(_ sender: UITextField) {
        
        nickNameCheckLbl.text = ""
        nickNameCheck = validateNickName(validNickName: nickName.text!)
        print(nickNameCheck)
        print(nickName.text!.count)
        
        if nickNameCheck == false {
            nickNameCheckLbl.text = "특수문자와 한글 자음, 모음은 사용될 수 없습니다."
            nickNameCheckLbl.isHidden = false
        } else {
            nickNameCheckLbl.isHidden = true
        }
        
        if nickName.text!.count > 12 {
            nickName.deleteBackward()
        }
    }
    
    @IBAction func phoneNumberChanged(_ sender: UITextField) {
        
        if phoneNumber.text!.count > 11 {
            phoneNumber.deleteBackward()
        }
        
        phoneNumberCheck = validatePhoneNumber(validPhoneNumber: phoneNumber.text!)
        print(phoneNumberCheck)
    }
    
//    @IBAction func authenticationNumberChanged(_ sender: UITextField) {
//
//        if sender.text! != authenticationNumberFromServer {
//            incorrectNumberLbl.text = "인증번호가 일치하지 않습니다."
//            incorrectNumberLbl.isHidden = false
//        } else {
//            incorrectNumberLbl.isHidden = true
//        }
//    }
    
    @IBAction func authenticationNumberChanged(_ sender: UITextField) {
        
        if sender.text! != authenticationNumberFromServer {
            incorrectNumberLbl.isHidden = false
        } else {
            incorrectNumberLbl.isHidden = true
        }
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
    
    func validatePhoneNumber(validPhoneNumber : String) -> Bool {
        
        let phoneNumberReg = "^01[0][0-9]{8}$"
        let phoneNumberChanged = NSPredicate(format: "SELF MATCHES %@", phoneNumberReg)
        
        return phoneNumberChanged.evaluate(with: validPhoneNumber)
    }
    
//    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SignUp2VC.updateTimer)), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTimer() {
//        if seconds < 1 {
//            validationCodeTimerLbl.text = "인증번호 유효시간 초과"
//        } else {
//            seconds -= 1
//            validationCodeTimerLbl.text = timeString(time: TimeInterval(seconds))
//        }
//    }
//
//    func timeString(time: TimeInterval) -> String {
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        return String(format: "%02i:%02i", minutes, seconds)
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
}
