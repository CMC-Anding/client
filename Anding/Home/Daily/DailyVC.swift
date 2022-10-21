//
//  DailyVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/13.
//

import Foundation
import UIKit
import Alamofire

class DailyVC :UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var feedUploadModel : FeedUploadModel?
    var qnaword: String?
    // UI이미지 담을 변수(갤러리에서 가져온이미지)
    var newImage: UIImage? = nil
    var colorWell: UIColorWell!
    var selectColor = ""
    var placeHolderText = "여기에 내용을 입력해주세요."
    
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var allView: UIView!
    @IBOutlet weak var topBg: UIView!
    @IBOutlet weak var bottomBg: UIStackView!
    
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
    
    @IBAction func test(_ sender: Any) {
        upLoadImg(newImage)
    }
    
    //MARK: - viewdidload
    override func viewDidLoad() {
        textViewSetupView()
        addColorWell()
        // 화면이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // 사용자가 이미지를 선택하면 자동으로 이 메소드가 호출된다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된이미지를 미리보기에 출력한다.
        self.imageView.image = info[.editedImage] as? UIImage
        
        // 갤러리에서 받아온이미지를 글로벌변수 newImage에 넣는다.
        newImage = info[.editedImage] as? UIImage
        
        // print("UIImage :\(info[.editedImage] as? UIImage)")
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
    }
    
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"DailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "DailyDetailVC") as! DailyDetailVC
        
        self.present(vc, animated: true){ }
    }
    
    
    // MARK: - saveBTn 등록API호출
    func upLoadImg(_ image: UIImage?) {
        //갤러리에서 가져온이미지
        //let newImage = image?.resized(toWidth: 200.0)
        let jwt = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjU1NjUwMTIsImV4cCI6MTY2NzAzNjI0MX0.RKwZZdhTQfbcwERzU69fBmI7oD0Ckaz5ji6-GHNIQFU"
        let url = "https://dev.joeywrite.shop/app/posts"
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
//            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "x-access-token" : jwt
        ]
        
        // 작성내용,BGcolor,category ID,category~번째 질문 json에 넣어전달
        let jsonData: [String: Any] = [
            "contents": textView.text ?? "111",
            "daily_title":"1019",
            "qnaBackgroundColor":"kCGColorSpaceModelRGB 0.943611 0.607661 0.456563 1",
            "filterId":"r",
            "qnaQuestionId" : "r-3",
            "qnaQuestionMadeFromUser" :""
        ] as Dictionary
        
        // 딕셔너리를 string으로 저장
        var jsonObj : String = ""
        do {
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            
            // json데이터를 변수에 삽입 실시
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        
//        print("만든제이순 jsonObj : " , jsonObj)
        
        // post에 담긴 제이슨
        let alamo = AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append("\(jsonObj)".data(using:.utf8)!, withName: "posts", mimeType: "application/json")
        
        // 이미지파일
        multipartFormData.append(UIImage(named: "BucketTag.png")!.jpegData(compressionQuality: 1)!, withName: "file", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            
        }, to: url, method: .post, headers: header)
        .validate(contentType: ["application/json"])
        
        alamo.response { response in
        
//            var json : Dictionary<String, Any> = [String : Any]()
            do {
//                // 딕셔너리에 데이터 저장 실시
//                json = try JSONSerialization.jsonObject(with: Data(jsonObj.utf8), options: []) as! [String:Any]
                print("json:\(response)")
                debugPrint("⭐️디버깅:\(response)")
                print( "알라모응답 = : \(try! response.result.get())!")

                
            } catch {
                print(error.localizedDescription)
            }
            
            // 정상적으로 json 데이터를 받은 경우
//             if(json.count > 0){
//                 print("[parse json data]")
//                 print("json len : " , json.count)
//                 print("json data : " , json) // json 데이터
//                 print("json key : ", json.keys) // json key 리스트
             
        }
    }
    
    
    
    //MARK: - addColorWell
    func addColorWell() {
        colorWell = UIColorWell(frame: CGRect(x: 95, y: 770, width: 8, height: 8))
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
        self.allView.backgroundColor = colorWell.selectedColor
        self.topBg.backgroundColor = colorWell.selectedColor
        self.bottomBg.backgroundColor = colorWell.selectedColor
        
        selectColor = colorWell.selectedColor?.description ?? "컬러없음"
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
    
}




// 이미지 사이즈 줄이기
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}


// MARK: - 텍스트뷰
extension DailyVC : UITextViewDelegate, UITextFieldDelegate {
    
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
