//
//  MemoModel.swift
//  flomo
//
//  Created by AFuture on 2021/1/8.
//

import Foundation

struct Memo: Codable {
    var content: String
    let created_at: String
    let slug: String
    
}

extension Memo: Identifiable, Hashable {
    var id: String { return slug }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(slug)
    }
}


struct APIMemos: Codable {
    let code: Int
    let message: String
    let memos: [Memo]
}

extension APIMemos {
    static func getMemos() -> APIMemos {
        let bundlePath = Bundle.main.path(forResource: "memos", ofType: "json")
        let jsonData = try! String(contentsOfFile: bundlePath!).data(using: .utf8)
        let decodedData = try! JSONDecoder().decode(APIMemos.self, from: jsonData!)

        return decodedData
    }
    init? () {
        code = APIMemos.getMemos().code
        message = APIMemos.getMemos().message
        memos = APIMemos.getMemos().memos
    }
    
    func sample(id: Int) -> Memo {
        return memos[id]
    }
}
