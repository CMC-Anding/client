//
//  DailyDetailVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/13.
//

import Foundation
import UIKit
import Alamofire

class DailyDetailVC :UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareArea: UIView!//체크박스클릭영역
    @IBOutlet weak var checkBox: UIImageView!
    private let checkOn = UIImage(named:"p_check_on")
    private let checkOff = UIImage(named:"p_check_off")
    var Ptext = ""
    var PdecText = [String]()

    @IBOutlet weak var QsaveBtn: UIButton!
    @IBAction func QsaveBtn(_ sender: Any) {
        //저장서버호출
        
        //저장완료팝업(밑에뷰다끄기안에있음)
        saveOkPop()
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "qnaDetailCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier:"qnaDetailCell")
        
        UISetting()
        // 토글액션
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        shareArea.addGestureRecognizer(tapGestureRecognizer)
        
        self.checkBox.image = UIImage(named:"p_check_off")
    }
    
    
    //MARK: - savePop
    func saveOkPop(){
        //저장얼럿띄우기
        let storyBoard = UIStoryboard.init(name: "UIPopup", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(identifier: "UIPopup") as! UIPopup
        popupVC.modalPresentationStyle = .overCurrentContext    //  투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        popupVC.Ptext = "기록이 저장되었습니다."
        popupVC.PdecText = "일상 기록은 오직 나만 볼 수 있어요 ;)"
        self.present(popupVC, animated: false, completion: nil)
    }
    
    
    func UISetting(){
        QsaveBtn.cournerRound12()
    }
    
    //selectsheet
    @objc func checkAction(sender: UITapGestureRecognizer) {
        toggleImage()
    }
    
    func toggleImage(){
        print("checkcheck")
        DispatchQueue.main.async {
            if self.checkBox.image === self.checkOff {
                self.checkBox.image = UIImage(named:"p_check_on")
            }else{
                self.checkBox.image = UIImage(named:"p_check_off")
            }
        }
    }
    
}


extension DailyDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        // return self.pmodel?.result.count ?? 0
    }
    
    
    // 셀 높이 컨텐츠에 맞게 자동으로 설정// 컨텐츠의 내용높이 만큼이다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qnaDetailCell", for: indexPath) as! qnaDetailCell
        
        //        cell.imageView.image = UIImage(named: "01")
        //        cell.mImgView.image =  UIImage(named: "01")
        //            cell.mImgView.image = UIImage(named: models[indexPath.item].imageName)
        //            cell.pdTitle.text = models[indexPath.item].text
        return cell
    }
}
