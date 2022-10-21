//
//  Topic.swift
//  Anding
//
//  Created by 이청준 on 2022/10/09.
//

import Foundation
import UIKit

class Topic {
    
    //    var TopicTitle = ["마무리", "관계", "버킷리스트", "가족", "비밀", "주제6", "주제7"]
    
    var Topic1 = ["Q. 내 삶을 색으로 표현하면, 무슨 색일까요?",
                  "Q. 가장 좋아하는 음식 3가지는???",
                  "Q. 엄마가 좋은지 아빠가 좋은지 말해보세요, 엄마가 좋은지 아빠가 좋은지 말해보세요,엄마가 좋은지 아빠가 좋은지 말해보세요",
                  "Q. 탕수육 부먹 vs 찍먹",
                  "Q. 마라탕이냐 마라샹궈냐",
                  "Q. 짜장 짬뽕",
                  "Q. 짜장 짬뽕"
    ]
    
    var TopicImageOff =  [UIImage(named: "EndTag_d"),
                          UIImage(named: "RelationshipTag_d"),
                          UIImage(named: "BucketTag_d"),
                          UIImage(named: "secretTag_d"),
                          UIImage(named: "FamilyTag_d"),
                          UIImage(named: "MemoryTag_d")
    ]

    var TopicImageOn =  [UIImage(named: "EndTag"),
                         UIImage(named: "RelationshipTag"),
                         UIImage(named: "BucketTag"),
                         UIImage(named: "secretTag"),
                         UIImage(named: "FamilyTag"),
                         UIImage(named: "MemoryTag")
    ]
    
    var sTagImg =  [UIImage(named: "EndTag"),
                    UIImage(named: "RelationshipTag"),
                    UIImage(named: "BucketTag"),
                    UIImage(named: "secretTag"),
                    UIImage(named: "FamilyTag"),
                    UIImage(named: "MemoryTag")
]
 
    
    
    var TopicImg = [UIImage(named: "TopicGraphic"),
                    UIImage(named: "TopicVideo"),
                    UIImage(named: "TopicGraphic"),
                    UIImage(named: "TopicVideo"),
                    UIImage(named: "TopicGraphic"),
                    UIImage(named: "TopicVideo"),
                    UIImage(named: "TopicGraphic")]


    var boxColor = [ UIColor(red: 0.383, green: 0.596, blue: 1, alpha: 0.3).cgColor,
                     UIColor(red: 0.949, green: 0.639, blue: 0.369, alpha: 0.3).cgColor,
                     UIColor(red: 0.314, green: 0.749, blue: 0.624, alpha: 0.3).cgColor,
                     UIColor(red: 0.904, green: 0.351, blue: 0.418, alpha: 0.3).cgColor,
                     UIColor(red: 0.537, green: 0.6, blue: 0.651, alpha: 0.3).cgColor,
                     UIColor(red: 0.533, green: 0.471, blue: 0.749, alpha: 0.3).cgColor,
                     UIColor(red: 0.851, green: 0.549, blue: 0.627, alpha: 0.3).cgColor]
    
    var boxBorder =  [ UIColor(red: 0.383, green: 0.596, blue: 1, alpha: 1).cgColor,
                       UIColor(red: 0.949, green: 0.639, blue: 0.369, alpha: 1).cgColor,
                       UIColor(red: 0.314, green: 0.749, blue: 0.624, alpha: 1).cgColor,
                       UIColor(red: 0.904, green: 0.351, blue: 0.418, alpha: 1).cgColor,
                       UIColor(red: 0.537, green: 0.6, blue: 0.651, alpha: 1).cgColor,
                       UIColor(red: 0.533, green: 0.471, blue: 0.749, alpha: 1).cgColor,
                       UIColor(red: 0.851, green: 0.549, blue: 0.627, alpha: 1).cgColor]
      
    
   
    
    //    var Topic2 = ["클러치백", "솔더백", "크로스백", "도트백", "백팩", "기타(가방)"]
    //    var Topic3 = ["패딩/점퍼", "코트", "맨투맨", "후드티/후드집업", "티셔츠", "자켓"]
    //    var Topic4 = ["패딩/점퍼", "코트", "맨투맨", "후드티/후드집업", "티셔츠"]
    //    var Topic5 = ["스니커즈"]
    //    var Topic6 = ["이사/용달", "인테리어/간판", "청소/세탁/철거"]
    //    var Topic7 = ["주택/빌라", "원룸/투룸", "오피스텔", "아파트"]
}
