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

extension Memo: Identifiable {
    var id: String { return slug }
}


struct APIMemos: Codable {
    let memos: [Memo]
}

extension APIMemos {
    static func getMemos() -> [Memo] {
        let bundlePath = Bundle.main.path(forResource: "memos", ofType: "json")
        let jsonData = try! String(contentsOfFile: bundlePath!).data(using: .utf8)
        let decodedData = try! JSONDecoder().decode(APIMemos.self, from: jsonData!)

        return decodedData.memos
    }
    init? () {
        memos = APIMemos.getMemos()
    }
    
    func sample(id: Int) -> Memo {
        return memos[id]
    }
}
