//
//  FeedDedtailVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/23.
//

import Foundation
import UIKit
import Alamofire

class FeedDetailVC : UIViewController{
    
    var feedMainModel:FeedMainModel?
    var qnaModel : QnaModel?
    var scrapModel : ScrapModel?
    var postNum = 0
    var getFilterId = ""
    var getQId = ""
    var otherNickname = ""
    var fillterID = ""
    var getNickname = ""
    var FeedNum : Int? //게시글번호
    let token = UserDefaults.standard.value(forKey:"token") as! String
    var myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
    
    let dismissQnaVC: Notification.Name = Notification.Name("dismissQnaVC")
    
    @IBOutlet var bgColorView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var QtitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var closeBtn: UIImageView!
    
    //MARK: - 더보기버튼
    @IBAction func moreBtn(_ sender: Any) {
        
        print("저장된네임",myNickName)
        print("너의닉네임",otherNickname)
        
        if myNickName == otherNickname {
            myPop()
        }else{
            otherPop()
        }
    }
    
    //MARK: - 스크랩저장페이지 띄우기
    @IBAction func savePopupBtn(_ sender: Any) {
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        
        // 버튼두개팝업 띄우기
        let vc = UIStoryboard(name:"UIPopupTwoBtn" , bundle: nil).instantiateViewController(withIdentifier: "UIPopupTwoBtn") as! UIPopupTwoBtn
        vc.modalPresentationStyle = .overCurrentContext
        vc.postNum = FeedNum
        self.present(vc, animated: false, completion: nil)
    }
    
    
    func otherPop(){
        //게시글수정, 신고버튼팝업띄우기
        let actionSheet = UIAlertController(title: "게시글 메뉴", message: nil, preferredStyle: .actionSheet)
        
        // 게시글 숨기기
        actionSheet.addAction(UIAlertAction(title: "게시글 숨기기", style: .default, handler: {(ACTION:UIAlertAction) in
            self.gotoPopHiddenVC()
        }))
        
        // 신고하기버튼
        actionSheet.addAction(UIAlertAction(title: "게시글 신고하기", style: .default, handler: {(ACTION:UIAlertAction) in
            // "문답 신고하기로 이동"
            self.gotoReportVC()
        }))
    
        // 차단하기
        actionSheet.addAction(UIAlertAction(title: "작성자 차단", style: .default, handler: {(ACTION:UIAlertAction) in
            // "문답 신고하기로 이동"
            self.gotoBlockUserVC()
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func myPop(){
        //게시글수정, 신고버튼팝업띄우기
        let actionSheet = UIAlertController(title: "게시글 메뉴", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "게시글 수정", style: .default, handler: {(ACTION:UIAlertAction) in
            // 수정으로 이동하기
            self.gotoModifyVC()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "게시글 삭제", style: .default, handler: {(ACTION:UIAlertAction) in
            
            // 게시글삭제팝업
            self.gotoDeletePopVC()
        }))
        
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        
        print(FeedNum ?? 0)
        //화면열면 디테일뷰서버호출
        getPostDetail(FeedNum ?? 0)
        
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(escBtn(tapGestureRecognizer:)))
        closeBtn.addGestureRecognizer(tapImageViewRecognizer)
        closeBtn.isUserInteractionEnabled = true
        
        let myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
        print("👻FeedDetail 저장닉네임",myNickName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
    }
    
    
    @objc func escBtn(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: dismissQnaVC, object: nil, userInfo: nil)
    }
    
    //MARK: - 서버에서 받은 헥스 스트링을 UI Color로 변환하는 함수
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //MARK: - 수정페이지로이동
    func gotoModifyVC(){
        let VC = UIStoryboard(name:"QModifyVC", bundle: nil).instantiateViewController(withIdentifier: "QModifyVC") as! QModifyVC
        
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        
        VC.postNum = FeedNum
        VC.fillterID = fillterID
        print("게시글번호:\(FeedNum)")
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true){ }
    }
    
    //MARK: - 신고하기페이지로이동
    func gotoReportVC(){
        let VC = UIStoryboard(name:"FeedReportVC", bundle: nil).instantiateViewController(withIdentifier: "FeedReportVC") as! FeedReportVC
        
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        
        VC.postNum = FeedNum
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true){ }
    }
    
    func gotoDeletePopVC(){
        // 삭제 팝업열기
        let vc = UIStoryboard(name:"DeletePopVC", bundle: nil).instantiateViewController(withIdentifier: "DeletePopVC") as! DeletePopVC
        
        //게시글번호
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        vc.postNum = FeedNum
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    //게시글 숨기기팝업
    func gotoPopHiddenVC(){
        // 팝업열기
        let vc = UIStoryboard(name:"PopHiddenVC", bundle: nil).instantiateViewController(withIdentifier: "PopHiddenVC") as! PopHiddenVC
        
        //게시글번호
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        vc.postNum = FeedNum
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
    // 차단팝업
    func gotoBlockUserVC(){
        // 팝업열기
        let vc = UIStoryboard(name:"PopBlockUserVC", bundle: nil).instantiateViewController(withIdentifier: "PopBlockUserVC") as! PopBlockUserVC
        
        //게시글번호
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        
        vc.postNum = FeedNum
        
        vc.nick  = getNickname
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
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
                
                print("서버호출")
                do{
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.qnaModel = try JSONDecoder().decode(QnaModel.self, from: dataJSON)
                    
                    print("⭐️qnaModel:\(self.qnaModel)")
                    
                    self.QtitleLabel.text = self.qnaModel?.result?.qnaQuestion ?? "문답내용" //질문아이디값받아아와서 다시뿌리기
                    self.textView.text = self.qnaModel?.result?.contents ?? ""
                    // getQId값에 맞는 이미지뿌리기(이미지수급시..)
                    self.getQId = self.qnaModel?.result?.qnaQuestionID ?? "문답아이디없음"
                    
                    let getColor = self.qnaModel?.result?.qnaBackgroundColor
                    self.bgColorView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                    self.dateString.text = self.qnaModel?.result?.createdAt
                    
                    let imgInsert = self.qnaModel?.result?.qnaQuestionID ?? "d-1"
                    self.imageView.image = UIImage(named: imgInsert)
                    self.otherNickname = self.qnaModel?.result?.nickname ?? "닉네임없음"
                    self.getNickname = self.qnaModel?.result?.nickname ?? "닉네임없음"
                    self.fillterID = self.qnaModel?.result?.filterID ?? "d"
                    
                    
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
