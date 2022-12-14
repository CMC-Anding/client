//
//  ScrapTabFeedVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class ScrapTabFeedVC :UIViewController{
    
    var otherScrapModel :OtherScrapModel?
    var scrapDelModel :ScrapDelModel?
    var getFilterId = ""
    var postID = 0
    var delListNum = [Int]()
    var rpostID = [Int]()
    var cellNum = [Int]()
    var timeOption = ""
    var qID = ""
    var checkNum = 0
    var count = ""
    let dissmissDailyVC = Notification.Name("dissmissDailyVC")
    let dismissQnaVC = Notification.Name("dismissQnaVC")
    @IBOutlet weak var timeBtn: UIImageView!
    private let timeOn = UIImage(named:"Property=Time")
    private let timeOff = UIImage(named:"Property=Reverse")
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var editAction: UIButton!
    @IBAction func editAction(_ sender: Any) {
        self.editBtn.isHidden = true
        self.delBtn.isHidden = false
    }
    
    @IBOutlet weak var delBtn: UIButton!
    @IBAction func delBtn(_ sender: Any) {
        //삭제서버호출
        scrapFeedDelete()
        // 삭제완료시
        self.editBtn.isHidden = false
        self.delBtn.isHidden = true
    }

    override func viewDidLoad() {
        
        var myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "sAnnotatedPhotoCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"sAnnotatedPhotoCell")
        let nibName2 = UINib(nibName: "qsmallCell", bundle: nil)
        collectionView.register(nibName2, forCellWithReuseIdentifier:"qsmallCell")
        let nibName3 = UINib(nibName: "sDailySmallCell", bundle: nil)
        collectionView.register(nibName3, forCellWithReuseIdentifier:"sDailySmallCell")
        let nibName4 = UINib(nibName: "sDailyBigCell", bundle: nil)
        collectionView.register(nibName4, forCellWithReuseIdentifier:"sDailyBigCell")
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        // 핀터레스트레이이아웃
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        //시간순호출
        timeOption = "desc"
        getFeedMain(option: timeOption)
        
        //인디케이터
        indicator.isHidden = true
        
        
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(timeAction(tapGestureRecognizer:)))
        timeBtn.addGestureRecognizer(tapImageViewRecognizer)
        timeBtn.isUserInteractionEnabled = true

        self.timeBtn.isHidden = true
        //기본세팅
        self.timeBtn.image = UIImage(named:"Property=Time")
        self.editBtn.isHidden = false
        self.delBtn.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dailyVCupdate(_:)), name: dissmissDailyVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.qndUpdate(_:)), name: dismissQnaVC, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
               super.viewDidDisappear(true)
               NotificationCenter.default.removeObserver(self, name: dissmissDailyVC, object: nil)
               NotificationCenter.default.removeObserver(self, name: dismissQnaVC, object: nil)
       }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.timeBtn.isHidden = true
        //기본세팅
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.timeBtn.isHidden = false
            self.timeBtn.image = UIImage(named:"Property=Time")
//            self.collectionView.reloadData()
//        }
    }
  
    
    // MARK: - timeAction
        @objc func timeAction(tapGestureRecognizer: UITapGestureRecognizer){
            //code
            if self.timeBtn.image === self.timeOff {
                self.timeBtn.image = UIImage(named:"Property=Time")
                
                timeOption = "desc"
                getFeedMain(option: timeOption)
                
            }else{
                self.timeBtn.image = UIImage(named:"Property=Reverse")
                timeOption = "asc"
                getFeedMain(option: timeOption)
            }
          }
    
    // MARK: - noti
       @objc func dailyVCupdate(_ noti: Notification) {
           self.update()
       }
     
     // MARK: - noti
        @objc func qndUpdate(_ noti: Notification) {
            self.update()
        }
    
    func update(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            //code
            if self.timeBtn.image === self.timeOff {
                self.timeBtn.image = UIImage(named:"Property=Time")
                
                self.timeOption = "desc"
                self.getFeedMain(option: self.timeOption)
                
            }else{
                self.timeBtn.image = UIImage(named:"Property=Reverse")
                self.timeOption = "asc"
                self.getFeedMain(option: self.timeOption)
            }
        }
    }
    
    // MARK: -  서버에서 받은 헥스 스트링을 UI Color로 변환하는 함수
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
    
    // MARK: - 피드서버호출(기본)
    func getFeedMain(option :String) {
        
        let time = option
        let url = "https://dev.joeywrite.shop/app/posts/other-clip?chronological=\(time)"
        let token = UserDefaults.standard.value(forKey:"token") as! String
        print(url)
        
        AF.request(url,
                   method: .get,
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
                
                print("내스크랩서버호출")
                do{
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.otherScrapModel = try JSONDecoder().decode(OtherScrapModel.self, from: dataJSON)
                    print("📘스크랩피드모델:\(self.scrapDelModel)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.collectionView.reloadData()
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
    
    //MARK: - 삭제하기 호출
    func scrapFeedDelete(){
        
        self.indicator.isHidden = false
        //start
        self.indicator.startAnimating()
        
        let url = "https://dev.joeywrite.shop/app/posts/clip"
        let token = UserDefaults.standard.value(forKey:"token") as! String

        let param :Parameters = [
            "postId": rpostID
        ]
        print("⭐️삭제글번호:\(param)")
        
        AF.request(url,
                   method:.delete,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json",
                             "X-ACCESS-TOKEN" : token
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler:{ res in
            switch res.result{
            case .success(_):
                
                guard try! res.result.get() is [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.scrapDelModel = try JSONDecoder().decode(ScrapDelModel.self, from: dataJSON)
                    print("⭐️scrapDelFeedModel:\( self.otherScrapModel)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        self.collectionView.reloadData()
                    }
         
                    //메인피드 다시호출
                    self.getFeedMain(option: "desc")

                    
                    //삭제완료얼럿띄우기
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
                        
                        let storyBoard = UIStoryboard.init(name: "ScarpDelVC", bundle: nil)
                        let popupVC = storyBoard.instantiateViewController(identifier: "ScarpDelVC")
                        popupVC.modalPresentationStyle = .overCurrentContext
                        self.present(popupVC, animated: false, completion: nil)
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
                //삭제완료얼럿띄우기
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) { // in half a second...
                    
                    let storyBoard = UIStoryboard.init(name: "UIPopScarpDelVC", bundle: nil)
                    let popupVC = storyBoard.instantiateViewController(identifier: "UIPopScarpDelVC")
//                    popupVC.errorMsg = "삭제에 실패했습니다."
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: false, completion: nil)
                }
            }
        }
        )}
    
    
}

extension ScrapTabFeedVC :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.otherScrapModel?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //삭제버튼이 활성화
        if delBtn.isHidden == false{
            
            getFilterId = self.otherScrapModel?.result?[indexPath.item].filterID ?? "d"
            
            // MARK: - 큰쎌
            if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
                let cell = collectionView.cellForItem(at: indexPath) as? sAnnotatedPhotoCell
                //문답(큰셀)
                if getFilterId != "e"{
                    switch cell?.clickCount
                    {
                    case 1:
                        cell?.clickCount = 0
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        let checkNum = postID
                        delListNum.removeAll(where: { $0 == checkNum })
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️문답큰쏄취소 :\(rpostID)")
                    case 0:
                        cell?.clickCount += 1
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        delListNum.insert(postID, at:0)
                        
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️문답큰쏄선택:\(rpostID)")
                    default:
                        break
                    }
                }
                //일상(큰셀)
                else{
                    let sDailyBigCell = collectionView.cellForItem(at: indexPath) as? sDailyBigCell
                    switch sDailyBigCell?.clickCount
                    {
                    case 1:
                        sDailyBigCell?.clickCount = 0
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        let checkNum = postID
                        delListNum.removeAll(where: { $0 == checkNum })
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️일상큰쏄취소 :\(rpostID)")
                    case 0:
                        sDailyBigCell?.clickCount += 1
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        delListNum.insert(postID, at:0)
                        
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️일상큰쏄선택:\(rpostID)")
                    default:
                        break
                    }
                }
                // MARK: - 작은쎌
            }else{
                //문답(작은쎌)
                let qscell = collectionView.cellForItem(at: indexPath) as? qsmallCell
                if getFilterId != "e"{
                    switch qscell?.clickCount
                    {
                    case 1:
                        qscell?.clickCount = 0
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        let checkNum = postID
                        delListNum.removeAll(where: { $0 == checkNum })
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️문답작은취소 :\(rpostID)")
                    case 0:
                        qscell?.clickCount += 1
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        delListNum.insert(postID, at:0)
                        
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️문답작은선택:\(rpostID)")
                    default:
                        break
                    }
                    
                    //일상(작은셀)
                }else{
                    let sDailySmallCell = collectionView.cellForItem(at: indexPath) as? sDailySmallCell
                    
                    switch sDailySmallCell?.clickCount
                    {
                    case 1:
                        sDailySmallCell?.clickCount = 0
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        let checkNum = postID
                        delListNum.removeAll(where: { $0 == checkNum })
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️일상작은취소 :\(rpostID)")
                    case 0:
                        sDailySmallCell?.clickCount += 1
                        postID = otherScrapModel?.result?[indexPath.item].postID ?? 0
                        delListNum.insert(postID, at:0)
                        
                        let rDelList: Set = Set(delListNum)
                        rpostID = Array(rDelList)
                        print("⭐️일상작은선택:\(rpostID)")
                    default:
                        break
                    }
                    
                }
            }
        // 삭제버튼 비활성화시(상세화면띄우기)
        }else{//
            if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
                
                getFilterId = self.otherScrapModel?.result?[indexPath.item].filterID ?? "d"
                
                // 큰쎌 - 일상
                if getFilterId == "e"{
                    let vc = UIStoryboard(name:"FeedDailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDailyDetailVC") as! FeedDailyDetailVC
                    // 일상VC
                    vc.modalPresentationStyle = .popover
                    vc.FeedNum = self.otherScrapModel?.result?[indexPath.item].postID ?? 0
                    print("일상게시글번호:\(vc.FeedNum)")
                    self.present(vc, animated: true){ }
                    
                    
                    // 큰쎌 - 문답
                }else{
                    // 문답VC
                    let vc = UIStoryboard(name:"FeedDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDetailVC") as! FeedDetailVC
                    vc.modalPresentationStyle = .popover
                    vc.FeedNum = self.otherScrapModel?.result?[indexPath.item].postID ?? 0
                    print("문답게시글번호:\(vc.FeedNum)")
                    self.present(vc, animated: true){ }
                }
                
                // 작은쏄
            }else{
                getFilterId = self.otherScrapModel?.result?[indexPath.item].filterID ?? "d"
                // 작은셀 일상
                if getFilterId == "e"{
                    getFilterId = self.otherScrapModel?.result?[indexPath.item].filterID ?? "d"
                    
                    let vc = UIStoryboard(name:"FeedDailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDailyDetailVC") as! FeedDailyDetailVC
                    // 일상VC
                    vc.modalPresentationStyle = .popover
                    vc.FeedNum = self.otherScrapModel?.result?[indexPath.item].postID ?? 0
                    print("일상게시글번호:\(vc.FeedNum)")
                    self.present(vc, animated: true){ }
                    
                    // 큰쎌 - 문답
                }else{
                 
                    // 문답VC
                    let vc = UIStoryboard(name:"FeedDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDetailVC") as! FeedDetailVC
                    vc.modalPresentationStyle = .popover
                    vc.FeedNum = self.otherScrapModel?.result?[indexPath.item].postID ?? 0
                    print("문답게시글번호:\(vc.FeedNum)")
                    self.present(vc, animated: true){ }
                }
            }
        }//
    }
    
    
    //셀표기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            getFilterId = self.otherScrapModel?.result?[indexPath.item].filterID ?? "d"
        
            //큰셀
            if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
                
                //문답(큰셀)
                if getFilterId != "e"{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sAnnotatedPhotoCell", for: indexPath)
                    if let annotateCell = cell as? sAnnotatedPhotoCell {
                        annotateCell.clickCount = 0
                        // 제목
                        annotateCell.captionLabel.text = self.otherScrapModel?.result?[indexPath.item].qnaQuestion
                        
                        // 배경color
                        let getColor = self.otherScrapModel?.result?[indexPath.item].qnaBackgroundColor
                        annotateCell.bgView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                        
                        self.qID = self.otherScrapModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                        let imgInsert = self.otherScrapModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                        annotateCell.imageView.image = UIImage(named: imgInsert)
                    }
                    return cell
                    //일상(큰셀)
                }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sDailyBigCell", for: indexPath)
                    if let DailyBigCell = cell as? sDailyBigCell {
                        // 제목
                        DailyBigCell.cationLabel.text = self.otherScrapModel?.result?[indexPath.item].dailyTitle
                        DailyBigCell.clickCount = 0
                        // 이미지
                        if ((otherScrapModel?.result?[indexPath.item].dailyImage) != nil) {
                            let imgInfo  = otherScrapModel?.result?[indexPath.item].dailyImage
                            if imgInfo != nil {
                                
                                // 킹피셔를 사용한 이미지 처리방법
                                if let imageURL = otherScrapModel?.result?[indexPath.item].dailyImage {
                                    // 이미지처리방법
                                    guard let url = URL(string: imageURL) else {
                                        //리턴할 셀지정하기
                                        return cell
                                    }
                                    // 이미지를 다운받는동안 인디케이터보여주기
                                    DailyBigCell.dImageView.kf.indicatorType = .activity
                                    //            print("이미지url \(url)")
                                    DailyBigCell.dImageView.kf.setImage(
                                        with: url,
                                        placeholder: UIImage(named: "ex"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                        ])
                                    {
                                        result in
                                        switch result {
                                        case .success(_):
                                            print("")
                                        case .failure(let err):
                                            print(err.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    return cell
                }
                
                
                //작은쎌
            } else {
                //문답셀(작은쏄)
                if getFilterId != "e"{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qsmallCell", for: indexPath)
                    
                    if let smallCell = cell as? qsmallCell {
                        smallCell.clickCount = 0
                        // 제목
                        smallCell.captionLabel.text = self.otherScrapModel?.result?[indexPath.item].qnaQuestion
                        // 배경color
                        let getColor = self.otherScrapModel?.result?[indexPath.item].qnaBackgroundColor
                        smallCell.containerView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                        // 배경color
                        //  annotateCell.containerView.backgroundColor = UIColor.purple
                        self.qID = self.otherScrapModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                        let imgInsert = self.otherScrapModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                        smallCell.imageView.image = UIImage(named: imgInsert)
                    }
                    return cell
                    
                    //일상셀(작은쏄)
                }else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sDailySmallCell", for: indexPath)
                    
                    if let smallCell = cell as? sDailySmallCell {
                        smallCell.clickCount = 0
                        // 제목
                        smallCell.captionLabel.text = self.otherScrapModel?.result?[indexPath.item].dailyTitle ?? "No title"
                        
                        // 이미지
                        if ((otherScrapModel?.result?[indexPath.item].dailyImage) != nil) {
                            let imgInfo  = otherScrapModel?.result?[indexPath.item].dailyImage
                            if imgInfo != nil {
                                
                                // 킹피셔를 사용한 이미지 처리방법
                                if let imageURL = otherScrapModel?.result?[indexPath.item].dailyImage {
                                    // 이미지처리방법
                                    guard let url = URL(string: imageURL) else {
                                        //리턴할 셀지정하기
                                        return cell
                                    }
                                    // 이미지를 다운받는동안 인디케이터보여주기
                                    smallCell.dImageView.kf.indicatorType = .activity
                                    //            print("이미지url \(url)")
                                    smallCell.dImageView.kf.setImage(
                                        with: url,
                                        placeholder: UIImage(named: "ex"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                        ])
                                    {
                                        result in
                                        switch result {
                                        case .success(_):
                                            print("")
                                        case .failure(let err):
                                            print(err.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    return cell
                }
            }
        }

}//end





//MARK: - PINTEREST LAYOUT DELEGATE
extension ScrapTabFeedVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //    return photos[indexPath.item].image.size.height 안됨
        //        return feedMainModel[indexPath.item].dailyImage.size.height ?? 310
        // 높이를 다르게 하려면
        //      return 310
        // 셀사이즈랜덤?
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            return 310
        }else{
            return 180
        }
    }
}




