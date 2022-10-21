//
//  QfirstVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//

import Foundation
import UIKit
import Alamofire

class QfirstVC :UIViewController{
    
    var topic = Topic()
    var colorWell: UIColorWell!
    var placeHolderText = "여기에 내용을 입력해주세요."
    var qnaword: String?
    
    //    @IBOutlet weak var bgColorBtn: UIStackView!
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topicTitle: UITextView!
    @IBOutlet weak var tagImg: UIImageView! // 가져오기
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet weak var topicBox: UIView! // 컬러,테두리 가져오기
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.font = .systemFont(ofSize: 16)
            textView.text = placeHolderText
            //            textView.textColor = UIColor(argb:0x74757B)
            textView.textColor = UIColor.gray
            //            textView.textColor = UIColor(argb:0xFFFFFF)
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var textCount: UILabel!
    
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
        
        textViewSetupView()
        addColorWell()
        topicBox.cournerRound12()
        topicBox.outLineBlueRound()
        topicTitle.text = qnaword
    }
    
    
    
    
    
    //MARK: - addColorWell
    func addColorWell() {
        colorWell = UIColorWell(frame: CGRect(x: 192, y: 730, width: 8, height: 8))
        self.view.addSubview(colorWell)
        //            colorWell.center = view.center
        //            colorWell.image
        colorWell.title = "배경색 선택"
        colorWell.addTarget(self, action: #selector(colorWellChanged(_:)), for: .valueChanged)
    }
    
    // MARK: -  colorPicker
    @objc func colorWellChanged(_ sender: Any) {
        self.view.backgroundColor = colorWell.selectedColor
        self.contentView.backgroundColor = colorWell.selectedColor
        // 배경 컬러값 저장하기
        // 작성된 텍스트
        // 마무리코드?
        print("color:\(colorWell.selectedColor)")
        // color:Optional(kCGColorSpaceModelRGB 0.943611 0.607663 0.456563 1 )헥사로 변환?
        
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
    
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"QnAdetailVC" , bundle: nil).instantiateViewController(withIdentifier: "QnAdetailVC") as! QnAdetailVC
        
        self.present(vc, animated: true){ }
    }
    
}


// MARK: - 텍스트뷰
extension QfirstVC : UITextViewDelegate, UITextFieldDelegate {
    
    // 편집이 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        textViewSetupView()
        textView.text = ""
        textView.textColor = UIColor.gray
    }
    
    // 편집이 종료될때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textViewSetupView()
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

