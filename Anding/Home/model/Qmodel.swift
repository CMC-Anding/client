//
//  Qmodel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/17.
//

import Foundation

// MARK: - Qmodel
struct Qmodel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: QResult?
}

// MARK: - Result
struct QResult: Codable {
    let contents: String?
}
