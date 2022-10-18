//
//  UserData.swift
//  Anding
//
//  Created by woonKim on 2022/10/12.
//

import Foundation
import Alamofire

struct UserData: Codable {
    let code: Int?
    let message: String?
    let result: Result
}

struct Result: Codable {
    let authenticationNumber: String?
    let jwt: String?
    let nickname: String?
}

struct SameId: Codable {
    let code: Int?
    let message: String?
    let nickname: String?
}

struct SignUp: Codable {
    let code: Int?
    let nickname: String?
    let password: String?
    let phone: String?
    let userId: String?
}

struct Login: Codable {
    let code: Int?
    let message: String?
    let result: Result
}









 



