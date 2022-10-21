//
//  HomeVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class HomeVC :UIViewController{

    var qmodel : Qmodel?
    var qresult: QResult?
    
    var topic = Topic()
    private let qnAImg = UIImage(named:"BtnWrite")
    private let routineImg = UIImage(named:"BtnWriteR")
    var dateString = ""
    var qnaword = [String]()//질문저장
    
    @IBOutlet weak var todayDate: UILabel!//오늘날짜
    @IBOutlet weak var topicBox: UIView!// 문항박스
    @IBOutlet weak var qtitle: UITextView! // 문항타이틀
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var qImg: UIImageView! //이미지썸네일
    @IBOutlet weak var tagSImg: UIImageView! //태그이미지
    @IBOutlet weak var leftQna: UILabel!//문항남은갯수
    @IBOutlet weak var qBtnToggle: UIImageView! //문답토글이미지
    @IBOutlet weak var routineText: UILabel!// 일상타이틀
    @IBOutlet weak var btnWrite: UIButton! //기록버튼
    @IBOutlet weak var togleView: UIView! //문답일상버튼
    
    
    override func viewWillAppear(_ animated: Bool) {

    }

    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"HomeCollectionViewCell")
        // UI
        UISetting()
        date()
        getTest()
        
        //selectsheet
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleAction))
        togleView.addGestureRecognizer(tapGestureRecognizer)
        
        //문답갯수
        self.leftQna.text = "10"
        //날짜
        self.todayDate.text = dateString
    }
    
    // MARK: - 날짜
    func date(){
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 (E)"
        dateString = dateFormatter.string(from: today as Date)
        print(dateString) //"2016년 2월 21일"
    }
    
    // MARK: -  기본세팅
    func UISetting(){
        //토픽아웃라인
        topicBox.outLineBlueRound()
        // 컬렉션뷰
        collectionView.bgColorGray()
        //버튼라운드
        btnWrite.layer.cornerRadius = 12
        // 토글이미지
        self.qBtnToggle.image = UIImage(named:"BtnWrite")
        // 일상텍스트 히든
        self.routineText.isHidden = true
        //토글 세팅
//        self.qBtnToggle.image = UIImage(named:"BtnWrite")
    }
    
    
    // MARK: -  주제카테고리스냅킷
   
   
    // MARK: -  문답일상선택
    @objc func toggleAction(sender: UITapGestureRecognizer) {
        toggleImage()
    }
    
    func toggleImage() {
        DispatchQueue.main.async {
            if self.qBtnToggle.image === self.qnAImg {
                // 일상
                self.qBtnToggle.image = UIImage(named:"BtnWriteR")
                self.topicBox.isHidden = true
                self.collectionView.isHidden = true
                self.routineText.isHidden = false
            }else{
                // 문답
                self.qBtnToggle.image = UIImage(named:"BtnWrite")
                self.topicBox.isHidden = false
                self.collectionView.isHidden = false
                self.routineText.isHidden = true
            }
        }
    }
      
    
// 토글버튼액션
    @IBAction func btnWriteAction(_ sender: Any) {
        
        if self.qBtnToggle.image == UIImage(named:"BtnWrite") {
            let vc = UIStoryboard(name:"QfirstVC" , bundle: nil).instantiateViewController(withIdentifier: "QfirstVC") as! QfirstVC

                vc.qnaword = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."

               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true){ }
            
        }else{
            let vc = UIStoryboard(name:"DailyVC" , bundle: nil).instantiateViewController(withIdentifier: "DailyVC") as! DailyVC

                vc.qnaword = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."
               //선택한 행의 내용을 feedResult에 담는다.
    //           detailVC.feedResult = self.feedModel?.results[indexPath.row]

               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true){ }
        }
    }
    
    //MARK: - 문답가져오기
    func getTest() {
        let fillterID = "m"
        let url = "https://dev.joeywrite.shop/app/questions/\(fillterID)"
        //LCId=&MCId=&SCId=
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json",
                             "X-ACCESS-TOKEN" : "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjU1NjUwMTIsImV4cCI6MTY2NzAzNjI0MX0.RKwZZdhTQfbcwERzU69fBmI7oD0Ckaz5ji6-GHNIQFU"
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
                    
                    self.qmodel = try JSONDecoder().decode(Qmodel.self, from: dataJSON)
                    
                    print("⭐️qmodel:\(self.qmodel)")
                    
                    OperationQueue.main.addOperation { // DispatchQueue도 가능.
                        self.collectionView.reloadData()
                        self.qtitle.text = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."
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


// MARK: - extension
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic.TopicImageOff.count
    }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 다음 화면 뷰컨트롤러의 인스턴스 생성 (StoryBoardID를 이용하여 참조)
      
      //셀하단 이미지 변경
      DispatchQueue.main.async {
          self.topicBox.layer.backgroundColor = self.topic.boxColor[indexPath.row]
          self.topicBox.layer.borderColor = self.topic.boxBorder[indexPath.row]
          self.tagSImg.image = self.topic.sTagImg[indexPath.row]
          self.qImg.image = self.topic.TopicImg[indexPath.row]
//          self.qtitle.text = self.qmodel?.result?.contents ?? "요청에 실패"
          self.leftQna.text = "10"
      }
}


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.imgView.image = self.topic.TopicImageOff[indexPath.row]
        //index순서대로 이미지 적용하기

        return cell
    }
}


extension HomeVC: HomeCellDelegate{
    func selectBtn(Index: Int) {
        //셀버튼 클릭시 실행할내용
        //카테고리On
//        self.imgView.image = self.topic.TopicImageOn[Index]
//        imgView.image = self.topic.TopicImageOff[Index]
//        cell.imgView.image = self.topic.TopicImageOn[Index]
    }
}
