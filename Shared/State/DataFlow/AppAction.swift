//
//  AppAction.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)

    case loadMemos
    case loadMemosDone(result: Result<[Memo], AppError>)
}
