//
//  DailyModifyVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/12.
//

import Foundation
import UIKit
import Alamofire

class DailyModifyVC : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var postNum = 0
    var dailyDetailModel:DailyDetailModel?
    
    // UI이미지 담을 변수(갤러리에서 가져온이미지)
    var newImage: UIImage? = nil
    var selectColor = ""
    var placeHolderText = "사진선택 후 내용을 입력해주세요."
    var dateString = ""
    var qnaword: String?//선택한질문
    var ftID:String? //필터아이디
    let plist = UserDefaults.standard
    var tmpContents = ""
    var dTitle = ""
    var saveImage: UIImage? = nil
    var bgColor = [String]()
    var contentsText = [String]()
    var tmpText = ""
    var tmpImg : String?
    var imgAddress = ""
    
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet var allView: UIView!
    
    @IBOutlet weak var topBg: UIView!
    @IBOutlet weak var bottomBg: UIStackView!
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.font = .systemFont(ofSize: 16)
            textView.text = placeHolderText
            textView.textColor = UIColor.gray
            textView.delegate = self
        }
    }
    @IBOutlet weak var textCount: UILabel!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    //갤러리 창
    @IBAction func pictureBtn(_ sender: Any) {
        // 기본이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        
        picker.delegate = self // 이미지피커컨트롤러 인스턴스의 델리게이트 속성 현재뷰 컨트롤러 인스턴스로설정
        picker.allowsEditing = true // 피커이미지편집 허용
        
        // 이미지피커 화면을 표시한다.
        self.present(picker, animated: true)
    }


    //MARK: - viewdidload
    override func viewDidLoad() {
        //서버호출
        getPostDetail(postNum)
        
        textViewSetupView()
        // 화면이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
        
        //키보드
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "tmpContents")
    }
    
    // 이미지선택시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 선택된이미지를 미리보기에 출력
        self.imageView.image = info[.editedImage] as? UIImage
        
        // 갤러리에서 받아온이미지를 글로벌변수 newImage에 넣는다.
        newImage = info[.editedImage] as? UIImage
        // print("UIImage :\(info[.editedImage] as? UIImage)")
        //갤러리에서 가져온이미지
        saveImage = newImage?.resized(toWidth: 300.0)
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
        
        
        let plist = UserDefaults.standard
        let getText = plist.string(forKey: "tmpContents")
        textView.text = getText
        reloadInputViews()
        
    }
    
    //MARK: - 다음버튼(데이터전달)
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"ModifyInfoVC" , bundle: nil).instantiateViewController(withIdentifier: "ModifyInfoVC") as! ModifyInfoVC
        
        // 글자넘기기
        vc.contentsText = textView.text
        // 제목 넘기기
        vc.rTitle = dTitle
        // 이미지넘기기(갤러리에서 가져온이미지, 서버에서 가져온이미지)
        
        if (saveImage != nil) {
            vc.rImg = saveImage
        }else{
             vc.rImg = saveImage
        }
    
        // 이전글수정시 이미지 넘기기
        if imgAddress != "이미지없음" {
            vc.tmpImg = imgAddress //이미지 URL
        }
        
        print("💎이미지주소",  imgAddress)
        
        
        // 게시글번호
        vc.postNum = postNum
        self.present(vc, animated: true){ }
        
    }
    
    
    
    // MARK: -  UITextView PlaceHolder 설정
    func textViewSetupView() {
        if textView.text == placeHolderText{
            textView.textColor = UIColor.gray
            
            
        } else if textView.text == "" {
            textView.text = placeHolderText
            
            textView.textColor = UIColor.gray
        }
    }
    
    //MARK: - 일상상세페이지호출
    func getPostDetail(_ postNum: Int) {
        
        let getPostNum = postNum
        
        let url = "https://dev.joeywrite.shop/app/posts/detail/\(getPostNum)"
        print("⭐️일상상세url호출:\(url)")
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json"
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result{
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.dailyDetailModel = try JSONDecoder().decode(DailyDetailModel.self, from: dataJSON)
                    
                    print("⭐️dailyDetailModel:\(self.dailyDetailModel)")
                    
                    self.dTitle = self.dailyDetailModel?.result?.dailyTitle ?? ""
        
                    self.textView.text = self.dailyDetailModel?.result?.contents
                    //                    self.dateString.text = self.dailyDetailModel?.result?.createdAt
                    //                    self.otherNickname = self.dailyDetailModel?.result?.nickname ?? "닉네임없음"
                    
                    let imgInfo  = self.dailyDetailModel?.result?.dailyImage
                    self.imgAddress = self.dailyDetailModel?.result?.dailyImage ?? "이미지없음"
                    
                    print("일상이미지" ,imgInfo)
                    if imgInfo != nil {
                        if let imageURL = self.dailyDetailModel?.result?.dailyImage{
                            guard let url = URL(string: imageURL) else {
                                return
                            }
                            // cell.postImg.kf.setImage(with:url)
                            self.imageView.kf.indicatorType = .activity
                            self.imageView.kf.setImage(
                                with: url,
                                placeholder: UIImage(named: "placeholderImage"),
                                options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
                                ])
                            {
                                result in
                                switch result {
                                case .success(_): break
                                    //                        print("HeratVC 킹피셔 Task done")
                                case .failure(let err):
                                    print(err.localizedDescription)
                                }
                            }
                        }
                    }
                    
                    
                } // 디코딩 에러잡기
                catch let DecodingError.dataCorrupted(context) {
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
                
                
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
            }
        }
    }
    
}



// MARK: - 텍스트뷰
extension DailyModifyVC : UITextViewDelegate, UITextFieldDelegate {
    
    // 편집이 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        textViewSetupView()
//        textView.text = ""
        textView.textColor = UIColor.gray
    }
    
    // 편집이 종료될때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textViewSetupView()
        }else{
            //텍스트뷰에 적힌값을 임시저장하기
            tmpContents = textView.text
            plist.setValue(tmpContents, forKey: "tmpContents")//이름이라는 키로 저장
            plist.synchronize()//동기화처리
            print("DailyModifyVC 텍스트저장")
        }
    }
    
    // textCount
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)-> Bool{
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in:stringRange, with: text)
        textCount.text = "\(changedText.count)/2000"
        return changedText.count <= 2000
    }
}
