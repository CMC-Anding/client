//
//  UIPopupTwoBtn.swift
//  Anding
//
//  Created by 이청준 on 2022/10/23.
//

import Foundation
import UIKit
import Alamofire

class PopHiddenVC :UIViewController{
    
    var qnaModel : QnaModel?
    var hiddenModel :HiddenModel?
    var postNum : Int?
    
    @IBOutlet weak var allPopBg: UIView!
    let plist = UserDefaults.standard
    @IBOutlet weak var popupBg: UIView!
    @IBOutlet weak var scrapTitle: UILabel!
    @IBOutlet weak var finalPop: UIView!
    @IBOutlet weak var failText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    
    // 게시글을숨기시겠습니까?
    @IBAction func saveBtn(_ sender: Any) {
        
        print(postNum ?? 0)
        //저장서버요청하기
        scrapSave(postNum ?? 0)
        
        //저장얼럿띄우기
        popupBg.isHidden = true
    }
    
    
    override func viewDidLoad() {
        //버튼두개팝업
        popupBg.cournerRound12()
        
        // viewMap: View 객체
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        allPopBg.addGestureRecognizer(tapGestureRecognizer)
        
        // 스크랩저장완료팝업
        finalPop.cournerRound12()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        finalPop.addGestureRecognizer(tapGesture)
        
        popupBg.isHidden = false
        finalPop.isHidden = true
    }
    
    
    //MARK: - 게시글 가리기 호출
    func scrapSave(_ postNum: Int) {
        
        let getPostNum = postNum
        
        var token = UserDefaults.standard.value(forKey:"token") as! String
        let url = "https://dev.joeywrite.shop/app/posts/hiding/\(getPostNum)"
        
        print(token)

        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json",
                             "X-ACCESS-TOKEN" : token
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
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.hiddenModel = try JSONDecoder().decode(HiddenModel.self, from: dataJSON)
//
                    print("⭐️hiddenModel:\( self.hiddenModel)")
                    
                    let code = self.hiddenModel?.code
                    // 예외처리(변경안함)
                    if code == 4665{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.finalPop.isHidden = false
                            self.failText.text = "이미 숨김처리된 게시글입니다."
                            self.descriptionText.text = ""
                        }
                        
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.finalPop.isHidden = false
                            self.failText.text = "게시글이 숨김처리 되었습니다."
                            self.descriptionText.text = "더 이상 피드에 보이지 않아요."
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
             
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.finalPop.isHidden = false
                    self.failText.text = "게시글 숨기기에 실패했습니다."
                    self.descriptionText.text = ""
                }
            }
        }
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true,completion: nil)
    }
    
    // 저장완료팝업
    @objc func closePopup(sender: UITapGestureRecognizer){
        //창모두닫기
        //        closeAllwindow()
        
        // 저장팝업만닫기
        self.dismiss(animated: true,completion: nil)
        
        //    func closeAllwindow(){
        //
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //
        //            // 아래스택뷰모두닫기
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        //
        //            // This is to get the SceneDelegate object from your view controller
        //            // then call the change root view controller function to change to main tab bar
        //            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        //        }
        //    }
    }
    
}
