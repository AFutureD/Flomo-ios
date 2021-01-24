//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/07.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import Combine
import Alamofire

struct LoginRequest {
    let email: String
    let password: String

    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            let parameters = [ "email": email, "password": password ]
            AF.request("https://flomoapp.com/login/", method: .get)
                .responseData { response in
                    switch response.result {
                    case let .success(data):
//                        var xsrf_token
                        if let headerFields = response.response?.allHeaderFields as? [String: String],
                           let URL = response.request?.url {
                            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)

                            var xsrf_token: String?
                            for cookie in cookies {
                                if cookie.name == "XSRF-TOKEN" {
                                    xsrf_token = cookie.value.string
                                    break
                                }
                            }
                            let Headers: HTTPHeaders = [
                                "x-xsrf-token": xsrf_token!,
                                "Content-Type": "application/json; charset=utf-8"
                            ]
                            
                            AF.request("https://flomoapp.com/api/user/login/",
                                       method: .post,
                                       parameters: parameters,
                                       encoding: JSONEncoding.prettyPrinted,
                                       headers: Headers
                                )
                                .responseData { response in
                                    print("code: \(response.response!.statusCode)")
                                    switch response.response!.statusCode {
                                    case 200...300:
                                        switch response.result {
                                        case let .success(data):
                                            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)  else {
                                                return promise(.failure(AppError.parseDataToJSONFailed))
                                            }
                                            switch loginResponse.code {
                                            case 0:
//                                                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
//
//                                                var xsrf_token: String?
//                                                for cookie in cookies {
//                                                    if cookie.name == "XSRF-TOKEN" {
//                                                        xsrf_token = cookie.value.string
//                                                        break
//                                                    }
//                                                }
                                                // TODO: User 保存 token 的方式，以便后续利用。
                                                let user = User(email: email, token: xsrf_token!)
                                                promise(.success(user))
//                                            case  -1:
//                                                promise(.failure(AppError.passwordWrong))
                                            default:
//                                                print(loginResponse)
                                                promise(.failure(AppError.loginFailed(loginResponse.message)))
                                            }
                                        case let .failure(error):
                                            promise(.failure(AppError.networkingFailed(error)))
                                        }
                                    default:
                                        promise(.failure(AppError.forbiden))
                                    }
                                }
                        }
                    case let .failure(error):
                        promise(.failure(AppError.networkingFailed(error)))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

struct LoginResponse: Codable {
    var code: Int
    var message: String
}
