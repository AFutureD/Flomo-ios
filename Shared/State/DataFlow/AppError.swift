//
//  AppError.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    
    case passwordWrong
    case networkingFailed(Error)
    case loginFailed(String)
    case forbiden
    case parseDataToJSONFailed
    case fetchFailed(String)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case .networkingFailed(let error): return error.localizedDescription
        case .loginFailed(let message): return message
        case .forbiden: return "被服务器限制"
        case .parseDataToJSONFailed: return "转换 JSON 数据失败"
        case .fetchFailed(let message): return message
        }
        
    }
}
