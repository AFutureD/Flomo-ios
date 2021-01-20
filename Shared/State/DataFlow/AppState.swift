//
//  AppState.swift
//  flomo
//
//  Created by AFuture on 2021/1/15.
//

import Foundation
import Combine

struct AppState {
    var settings = Settings()
    var memoList = MemoList()
}

extension AppState {
    struct Settings{
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting = false
        var loginError: AppError?
        
        var checker = AccountChecker()
        var isEmailValid: Bool = false
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main
                    )
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }

                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }

                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
                .map { $0 && ($1 || $2) }
                .eraseToAnyPublisher()
            }
        }
    }
    struct MemoList {
        var memos:[String: Memo]?
        var loadingMemos = false
        
        var allMemosByTime:[Memo] {
            guard let memos = memos?.values else {
                return []
            }
            return memos.sorted{$0.created_at < $1.created_at}
        }
    }
}
